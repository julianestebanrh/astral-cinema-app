#!/bin/bash

# cleanup-old-versions.sh
# Uso: ./cleanup-old-versions.sh <ENVIRONMENT>

# Configuración
APP_NAME="astral-cinema-app"
AWS_REGION="us-east-1"
MAX_VERSIONS_TO_KEEP=10  # Número de versiones antiguas que se conservarán

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

# Eliminar versiones antiguas de Lambda
echo "Limpiando versiones antiguas de Lambda en el entorno $ENVIRONMENT..."
VERSIONS=$(aws lambda list-versions-by-function \
    --function-name $FUNCTION_NAME \
    --query 'Versions[?Version!=`$LATEST`].Version' \
    --output text)

VERSIONS_ARRAY=($VERSIONS)
NUM_VERSIONS=${#VERSIONS_ARRAY[@]}
NUM_VERSIONS_TO_DELETE=$((NUM_VERSIONS - MAX_VERSIONS_TO_KEEP))

if [ $NUM_VERSIONS_TO_DELETE -gt 0 ]; then
    echo "Eliminando $NUM_VERSIONS_TO_DELETE versiones antiguas de Lambda..."
    for ((i=0; i<NUM_VERSIONS_TO_DELETE; i++)); do
        VERSION=${VERSIONS_ARRAY[$i]}
        echo "Eliminando versión $VERSION de Lambda..."
        aws lambda delete-function \
            --function-name $FUNCTION_NAME \
            --qualifier $VERSION
        if [ $? -ne 0 ]; then
            echo "Error al eliminar la versión $VERSION de Lambda."
        fi
    done
else
    echo "No hay versiones antiguas de Lambda para eliminar en el entorno $ENVIRONMENT."
fi

# Eliminar versiones antiguas de S3
echo "Limpiando versiones antiguas de S3 en el entorno $ENVIRONMENT..."
VERSIONS=$(aws s3 ls s3://$BUCKET_NAME/versions/ --output text | awk '{print $2}' | sed 's/\///g')

VERSIONS_ARRAY=($VERSIONS)
NUM_VERSIONS=${#VERSIONS_ARRAY[@]}
NUM_VERSIONS_TO_DELETE=$((NUM_VERSIONS - MAX_VERSIONS_TO_KEEP))

if [ $NUM_VERSIONS_TO_DELETE -gt 0 ]; then
    echo "Eliminando $NUM_VERSIONS_TO_DELETE versiones antiguas de S3..."
    for ((i=0; i<NUM_VERSIONS_TO_DELETE; i++)); do
        VERSION=${VERSIONS_ARRAY[$i]}
        echo "Eliminando versión $VERSION de S3..."
        aws s3 rm \
            s3://$BUCKET_NAME/versions/$VERSION/ \
            --recursive
        if [ $? -ne 0 ]; then
            echo "Error al eliminar la versión $VERSION de S3."
        fi
    done
else
    echo "No hay versiones antiguas de S3 para eliminar en el entorno $ENVIRONMENT."
fi

echo "✅ Limpieza de versiones antiguas completada en el entorno $ENVIRONMENT."