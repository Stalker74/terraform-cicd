# Production AWS Infrastructure with Terraform

Complete production-ready infrastructure using Terraform modules and GitHub Actions CI/CD.

## Architecture

```
VPC (10.0.0.0/16)
├── Public Subnet → EC2 (Apache) → Internet
├── Private Subnet
├── S3 Buckets (State, Artifacts, Logs)
├── DynamoDB (State Lock)
├── IAM Roles
└── CloudWatch Logs
```

## Project Structure

```
Production/
├── .github/workflows/
│   └── terraform.yml          # CI/CD Pipeline
├── terraform/
│   ├── main.tf               # Root module
│   ├── variables.tf
│   ├── outputs.tf
│   ├── state-setup/
│   │   └── main.tf           # S3 + DynamoDB
│   ├── environments/
│   │   ├── dev.tfvars
│   │   └── prod.tfvars
│   └── modules/
│       ├── vpc/              # Network module
│       ├── ec2/              # Compute module
│       ├── s3/               # Storage module
│       ├── iam/              # Security module
│       └── cloudwatch/       # Monitoring module
└── simple/                   # Web application
```

## Setup Steps

### 1. Setup State Backend

```bash
cd terraform/state-setup
terraform init
terraform apply
```

Note the output bucket name and update `terraform/main.tf` backend configuration.

### 2. Configure GitHub

**Add Secrets:**
- Go to: Repository → Settings → Secrets → Actions
- Add: `AWS_ACCESS_KEY_ID`
- Add: `AWS_SECRET_ACCESS_KEY`

**Create Environments:**
- Go to: Repository → Settings → Environments
- Create `dev` environment
- Create `prod` environment (enable required reviewers)

### 3. Deploy

**Dev Environment:**
```bash
git checkout -b develop
git add .
git commit -m "Initial setup"
git push origin develop
```

**Prod Environment:**
```bash
git checkout main
git add .
git commit -m "Production deployment"
git push origin main
```

## Manual Deployment

```bash
cd terraform

# Dev
terraform init
terraform apply -var-file=environments/dev.tfvars

# Prod
terraform apply -var-file=environments/prod.tfvars
```

## CI/CD Pipeline

- **develop branch** → Auto-deploy to dev
- **main branch** → Manual approval → Deploy to prod
- Validates → Plans → Applies → Deploys app

## Monitoring

```bash
# View logs
aws logs tail /aws/ec2/webapp-dev --follow

# Get URL
cd terraform
terraform output web_url
```

## Cleanup

```bash
terraform destroy -var-file=environments/dev.tfvars
terraform destroy -var-file=environments/prod.tfvars
```
