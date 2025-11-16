# Full-Stack GitOps

This repository implements a GitOps workflow for managing both infrastructure and application deployments. It is an extension of a previous project, with a focus on CI/CD pipelines for both infrastructure and application stacks.

## Repository Structure

```
full-stack_gitops/
├── application/               # Application stack (frontend, backend, etc.)
├── infrastructure/            # Infrastructure as Code (Terraform, Ansible, etc.)
├── .github/workflows/         # CI/CD workflows
└── README.md                  # Project documentation
```

## CI/CD Overview

### Branches

- **`deployment`**: Used for deploying the application stack.
- **`infra_features`**: Feature branch for infrastructure development.
- **`infra_main`**: Main branch for infrastructure deployment.
- **`integration`**: Used for integrating and testing application changes.

### Infrastructure CI/CD

The infrastructure CI/CD pipelines are defined in the `.github/workflows/` directory and include the following workflows:

#### 1. **`terraform_validate.yaml`**
- **Trigger**: Push to `infra_features` branch.
- **Purpose**: Validates Terraform configurations.
- **Steps**:
  - Initialize Terraform.
  - Format and validate Terraform code.

#### 2. **`terraform_plan.yaml`**
- **Trigger**: Pull request to `infra_main` branch.
- **Purpose**: Generates a Terraform execution plan and posts it as a PR comment.
- **Steps**:
  - Initialize Terraform.
  - Generate and comment on the Terraform plan.
  - Generate cost estimates using Infracost.

#### 3. **`terraform_apply.yaml`**
- **Trigger**: Push to `infra_main` branch.
- **Purpose**: Deploys infrastructure using Terraform and configures monitoring with Ansible.
- **Steps**:
  - Initialize and apply Terraform configurations.
  - Run Ansible playbooks to configure monitoring.

### Application CI/CD

The application CI/CD pipelines are defined in the `.github/workflows/` directory. These workflows manage Docker image builds, pushes, and deployments.

#### 1. **`ci-application.yaml`**
- **Trigger**: Push to `integration` branch.
- **Purpose**: Builds and pushes Docker images to Docker Hub.
- **Steps**:
  - Build and push Docker images for the frontend and backend.
  - Update the `compose.app.yaml` file with the new image tags.

#### 2. **`cd-application.yaml`**
- **Trigger**: Push to `deployment` branch.
- **Purpose**: Deploys the application stack to the provisioned infrastructure.
- **Steps**:
  - Clone the repository on the remote VM.
  - Pull the latest changes from the `deployment` branch.
  - Deploy the application stack using Docker Compose.

### Monitoring Stack

The monitoring stack is managed using Ansible and includes Prometheus, Grafana, and Loki. The `ansible_monitoring.yaml` workflow sets up the monitoring stack after the infrastructure is deployed.

#### Workflow: `ansible_monitoring.yaml`
- **Trigger**: Completion of the `Deploy infrastructure` workflow.
- **Purpose**: Configures and deploys the monitoring stack.
- **Steps**:
  - Install Ansible and required collections.
  - Create Docker networks for the monitoring stack.
  - Deploy the monitoring stack using Docker Compose.

## Getting Started

### Prerequisites
- Docker and Docker Compose
- Terraform
- Ansible
- GitHub Actions

### Setting Up the Repository
1. Clone the repository:
   ```bash
   git clone git@github.com:deltron-fr/full-stack_gitops.git
   ```
2. Navigate to the repository:
   ```bash
   cd full-stack_gitops
   ```

### Running Workflows

#### Infrastructure Workflows
1. Push changes to the `infra_features` branch to validate Terraform configurations.
2. Create a pull request to `infra_main` to review and plan infrastructure changes.
3. Merge the pull request to `infra_main` to deploy infrastructure.

#### Application Workflows
1. Push changes to the `integration` branch to build and push Docker images.
2. Push changes to the `deployment` branch to deploy the application stack.

## Future Improvements
- Add automated tests for the application stack.
- Implement advanced monitoring and alerting.
- Enhance security with automated vulnerability scanning.

## License
This project is licensed under the MIT License. See the [LICENSE](infrastructure/LICENSE) file for details.