#!/bin/bash

# rollback.sh
# Uso: ./rollback.sh <ENVIRONMENT>

# Configuración
APP_NAME="astral-cinema-app"
AWS_REGION="us-east-1"

# Verificar que se proporcione el entorno
if [ -z "$1" ]; then
    echo "Uso: $0 <ENVIRONMENT>"
    echo "Ejemplo: $0 dev"
    exit 1
fi

ENVIRONMENT=$1

# Configurar nombres de recursos según el entorno
BUCKET_NAME="${APP_NAME}-${ENVIRONMENT}-static-assets"
FUNCTION_NAME="${APP_NAME}-${ENVIRONMENT}-ssr-function"

# Verificar que AWS CLI esté instalado
if ! command -v aws &> /dev/null; then
    echo "AWS CLI no está instalado. Por favor, instálalo y configura tus credenciales."
    exit 1
fi

# Función para listar las versiones disponibles de Lambda
list_versions() {
    echo -e "\nVersiones disponibles de Lambda en el entorno $ENVIRONMENT:"
    aws lambda list-versions-by-function \
        --function-name $FUNCTION_NAME \
        --query 'Versions[?Version!=`$LATEST`].[Version, LastModified, Description]' \
        --output table
}

# Listar versiones disponibles
list_versions

# Pedir al usuario que ingrese la versión a la que desea hacer rollback
echo -e "\nIngresa el número de versión a la que deseas hacer rollback:"
read VERSION

# Verificar que se haya proporcionado una versión
if [ -z "$VERSION" ]; then
    echo "Debes especificar un número de versión."
    exit 1
fi

# Verificar que la versión exista
echo -e "\nVerificando la versión $VERSION en el entorno $ENVIRONMENT..."
aws lambda get-function \
    --function-name $FUNCTION_NAME:$VERSION \
    --query 'Configuration.[Version,LastModified,Description]' \
    --output table

if [ $? -ne 0 ]; then
    echo "La versión $VERSION no existe en el entorno $ENVIRONMENT."
    exit 1
fi

# Confirmar rollback
echo -e "\n¿Deseas hacer rollback a la versión $VERSION en el entorno $ENVIRONMENT? (y/n)"
read confirmation

if [ "$confirmation" != "y" ]; then
    echo "Operación cancelada."
    exit 0
fi

# Obtener la versión actual (dañada)
CURRENT_VERSION=$(aws lambda list-aliases \
    --function-name $FUNCTION_NAME \
    --query "Aliases[?Name=='production'].FunctionVersion" \
    --output text)

# Actualizar el alias 'production' a la versión anterior
echo -e "\nActualizando el alias 'production' a la versión $VERSION..."
aws lambda update-alias \
    --function-name $FUNCTION_NAME \
    --name production \
    --function-version $VERSION

if [ $? -ne 0 ]; then
    echo "Error al actualizar el alias de Lambda."
    exit 1
fi

# Sincronizar los archivos estáticos de la versión anterior
echo -e "\nSincronizando archivos estáticos desde S3..."
aws s3 sync \
    s3://$BUCKET_NAME/versions/$VERSION/static \
    s3://$BUCKET_NAME/static \
    --delete

if [ $? -ne 0 ]; then
    echo "Error al sincronizar archivos estáticos en S3."
    exit 1
fi

# Invalidar caché de CloudFront
echo -e "\nInvalidando caché de CloudFront..."
DISTRIBUTION_ID=$(aws cloudfront list-distributions \
    --query "DistributionList.Items[?contains(Aliases.Items, '$BUCKET_NAME.s3.$AWS_REGION.amazonaws.com')].Id" \
    --output text)
aws cloudfront create-invalidation \
    --distribution-id $DISTRIBUTION_ID \
    --paths "/*"

if [ $? -ne 0 ]; then
    echo "Error al invalidar la caché de CloudFront."
    exit 1
fi

# Eliminar versiones posteriores a la versión de rollback
echo -e "\nEliminando versiones posteriores a la versión $VERSION..."
VERSIONS=$(aws lambda list-versions-by-function \
    --function-name $FUNCTION_NAME \
    --query 'Versions[?Version!=`$LATEST`].Version' \
    --output text)

for V in $VERSIONS; do
    if [ "$V" -gt "$VERSION" ]; then
        echo "Eliminando versión $V de Lambda..."
        aws lambda delete-function \
            --function-name $FUNCTION_NAME \
            --qualifier $V

        echo "Eliminando versión $V de S3..."
        aws s3 rm \
            s3://$BUCKET_NAME/versions/$V/static \
            --recursive
    fi
done

echo -e "\n✅ Rollback completado a la versión $VERSION en el entorno $ENVIRONMENT."
echo -e "🗑️ Versiones posteriores a $VERSION eliminadas."