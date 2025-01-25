# Nuxt Minimal Starter

Look at the [Nuxt documentation](https://nuxt.com/docs/getting-started/introduction) to learn more.

## Setup

Make sure to install dependencies:

```bash
# npm
npm install

# pnpm
pnpm install

# yarn
yarn install

# bun
bun install
```

## Development Server

Start the development server on `http://localhost:3000`:

```bash
# npm
npm run dev

# pnpm
pnpm dev

# yarn
yarn dev

# bun
bun run dev
```

## Production

Build the application for production:

```bash
# npm
npm run build

# pnpm
pnpm build

# yarn
yarn build

# bun
bun run build
```

Locally preview production build:

```bash
# npm
npm run preview

# pnpm
pnpm preview

# yarn
yarn preview

# bun
bun run preview
```

Check out the [deployment documentation](https://nuxt.com/docs/getting-started/deployment) for more information.



# Astral Cinema App - Infrastructure and CI/CD

Este proyecto incluye la configuración de infraestructura con **Terraform**, scripts para manejar despliegues y rollbacks, y flujos de **GitHub Actions** para CI/CD. A continuación, se detalla la estructura del proyecto y cómo utilizarlo.

---

## Estructura del proyecto


```
.
├── .github/
│   └── workflows/
│       ├── deploy.yml                   # Workflow para el despliegue de la aplicación
│       ├── rollback.yml                 # Workflow para revertir a una versión anterior
│       └── code-quality-scanning.yml    # Workflow para analisis, covertura y calidad
├── scripts/
│   ├── cleanup-old-versions.sh          # Script para eliminar versiones antiguas de Lambda y S3
│   └── rollback.sh                      # Script para revertir a una versión anterior
├── terraform/
│   ├── app/
│   │   ├── environments/
│   │   │   ├── dev/
│   │   │   │   └── terraform.tfvars    # Variables de entorno `dev`
│   │   │   ├── prod/
│   │   │   │   └── terraform.tfvars    # Variables de entorno `prod`
│   │   │   └── staging/
│   │   │       └── terraform.tfvars    # Variables de entorno `staging`
│   │   │
│   │   ├── api_gateway.tf              # Configuración del API Gateway
│   │   ├── cloudfront.tf               # Configuración de CloudFront
│   │   ├── lambda.tf                   # Configuración de la función Lambda
│   │   ├── outputs.tf                  # Salidas de la infraestructura
│   │   ├── policy.tf                   # Configuración de IAM Policy
│   │   ├── providers.tf                # Configuración del provider
│   │   ├── s3.tf                       # Configuración del bucket de S3
│   │   ├── variables.tf                # Variables utilizadas en la configuración
│   │   └── waf.tf                      # Configuración de WAF para restringir el acceso
│   └── iam/
│       ├── environments/
│       │   ├── dev/
│       │   │   └── terraform.tfvars    # Variables de entorno `dev`
│       │   ├── prod/
│       │   │   └── terraform.tfvars    # Variables de entorno `prod`
│       │   └── staging/
│       │       └── terraform.tfvars    # Variables de entorno `staging`
│       ├── main.tf
│       ├── providers.tf
│       └── variables.tf 
├── .output/                         # Carpeta con los archivos generados durante el build
├── README.md                        # Documentación del proyecto
└── .gitignore                       # Archivo para ignorar archivos en Git
```


---

## Requisitos previos

Antes de utilizar este proyecto, asegúrate de tener instaladas las siguientes herramientas:

- **Terraform**: Para gestionar la infraestructura en AWS.
- **AWS CLI**: Para interactuar con los servicios de AWS.
- **Node.js y Yarn**: Para gestionar dependencias y compilar la aplicación.
- **Git**: Para el control de versiones.

---

## Configuración de Terraform

El proyecto utiliza Terraform para gestionar la infraestructura en AWS. La configuración está dividida en dos módulos:

### 1. **Módulo IAM** (`terraform/iam`)
Este módulo define los roles y políticas de IAM necesarios para desplegar la aplicación.

### 2. **Módulo App** (`terraform/app`)
Este módulo define los recursos de AWS para la aplicación, como:
- Bucket de S3 para archivos estáticos.
- Función Lambda para el servidor SSR.
- API Gateway para exponer la función Lambda.

#### Cómo aplicar la configuración de Terraform:

1. Navega a la carpeta del módulo que deseas aplicar (por ejemplo, `terraform/iam` o `terraform/app`).
2. Inicializa Terraform:
   ```bash
   terraform init
   ```
3. Revisa el plan de ejecución:
    ```bash
    terraform plan -var-file=environments/dev/terraform.tfvars
    ```    
4. terraform init
    ```bash
    terraform plan -var-file=environments/dev/terraform.tfvars
    ```    


Scripts
-------

### 1. **rollback.sh**

Este script permite hacer rollback a una versión específica de la función Lambda y los archivos estáticos en S3.

#### Uso:
```bash
./scripts/rollback.sh <VERSION> <ENVIRONMENT>
```    
*   **VERSION**: Número de versión a la que deseas hacer rollback (por ejemplo, 2).
*   **ENVIRONMENT**: Entorno en el que deseas hacer el rollback (dev, staging, prod).
*   **Ejemplo**:
```bash
./scripts/rollback.sh 2 dev
```

### 2. **cleanup-old-versions.sh**

*   Este script elimina versiones antiguas de la función Lambda y los archivos estáticos en S3, manteniendo solo las últimas 10 versiones.
#### Uso:
```bash
./scripts/cleanup-old-versions.sh <ENVIRONMENT>
```
*   **ENVIRONMENT**: Entorno en el que deseas hacer el rollback (dev, staging, prod).    
*   **Ejemplo**:
```bash
./scripts/cleanup-old-versions.sh dev
```

---

GitHub Actions
--------------

El proyecto incluye dos flujos de GitHub Actions:

### 1. **deploy.yml**

Este flujo se ejecuta en cada push a la rama main y realiza lo siguiente:

1.  **Análisis de calidad de código**:
    *   Ejecuta un linter y pruebas de cobertura.
    *   Realiza un escaneo con SonarQube.
        
2.  **Despliegue en AWS** (solo si el mensaje de commit incluye \[deploy:dev\], \[deploy:staging\] o \[deploy:prod\]):
    *   Despliega archivos estáticos en un bucket de S3.
    *   Actualiza la función Lambda.
    *   Invalida la caché de CloudFront.
    *   Crea un tag y un release en GitHub.
        

#### Ejemplo de mensaje de commit para desplegar en dev:
```bash
feat(App): add new feature [deploy:dev]
```

### 2. **rollback.yml**

Este flujo permite hacer rollback a una versión específica de la función Lambda y los archivos estáticos en S3.

#### Cómo ejecutarlo:
1.  Ve a la pestaña **Actions** en GitHub.
2.  Selecciona el flujo **Rollback Lambda Function and Static Assets**.
3.  Proporciona el número de versión y el entorno al que deseas hacer rollback.

---

Variables de entorno y secrets
------------------------------

### Variables de entorno:
| Nombre de la variable | Valor (dev) | Valor (staging) | Valor (prod) |
|-----------------------|-------------|-----------------|--------------|
| `APP_NAME`            | `astral-cinema-app` | `astral-cinema-app` | `astral-cinema-app` |
| `AWS_REGION`          | `us-east-1` | `us-east-1` | `us-east-1` |

### Secrets:
| Nombre del secret | Valor |
|-------------------|-------|
| `AWS_ROLE_ARN`    | `arn:aws:iam::123456789012:role/github-actions-role` |
| `SONARCLOUD_TOKEN` | `XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX` |

---



