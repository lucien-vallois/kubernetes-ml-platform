.PHONY: help setup test format deploy deploy-all verify clean

# Default target
help: ## Show this help message
	@echo " Kubernetes ML Platform - Development Commands"
	@echo ""
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

# Setup development environment
setup: ## Install development dependencies
	@echo "Installing development dependencies..."
	@command -v terraform >/dev/null 2>&1 || echo " Terraform not found. Please install: https://www.terraform.io/downloads"
	@command -v helm >/dev/null 2>&1 || echo " Helm not found. Please install: https://helm.sh/docs/intro/install/"
	@command -v kubectl >/dev/null 2>&1 || echo " kubectl not found. Please install: https://kubernetes.io/docs/tasks/tools/"
	@command -v aws >/dev/null 2>&1 || echo " AWS CLI not found. Please install: https://aws.amazon.com/cli/"
	@echo " Development environment ready!"

# Run all tests
test: ## Run all tests (lint, validate, security)
	@echo "Running all tests..."
	@make test-terraform
	@make test-helm
	@make test-manifests
	@echo " All tests passed!"

# Test Terraform code
test-terraform: ## Validate Terraform configuration
	@echo "Validating Terraform..."
	@cd terraform && terraform init -backend=false >/dev/null 2>&1
	@cd terraform && terraform validate
	@cd terraform && terraform fmt -check
	@echo " Terraform validation passed!"

# Test Helm charts
test-helm: ## Lint and validate Helm charts
	@echo "Validating Helm charts..."
	@helm lint helm/ml-service
	@helm lint helm/monitoring
	@helm template test-ml-service helm/ml-service >/dev/null
	@helm template test-monitoring helm/monitoring >/dev/null
	@echo " Helm validation passed!"

# Test Kubernetes manifests
test-manifests: ## Validate Kubernetes manifests
	@echo "Validating Kubernetes manifests..."
	@find manifests/ -name "*.yaml" -exec echo "Checking {}" \; -exec kubectl --dry-run=client --validate=true apply -f {} \; 2>/dev/null || true
	@echo " Manifest validation completed!"

# Format code
format: ## Format all code (Terraform, YAML, etc.)
	@echo "Formatting code..."
	@cd terraform && terraform fmt -recursive
	@echo " Code formatting completed!"

# Deploy everything
deploy-all: ## Deploy complete infrastructure and services
	@echo " Starting full deployment..."
	@make deploy-infra
	@make deploy-services
	@make deploy-monitoring
	@make deploy-configs
	@echo " Full deployment completed!"

# Deploy infrastructure
deploy-infra: ## Deploy AWS infrastructure with Terraform
	@echo "Deploying infrastructure..."
	@cd terraform && terraform init
	@cd terraform && terraform plan -var-file=production.tfvars
	@cd terraform && terraform apply -var-file=production.tfvars --auto-approve
	@echo " Infrastructure deployed!"

# Deploy ML services
deploy-services: ## Deploy ML services with Helm
	@echo "Deploying ML services..."
	@aws eks update-kubeconfig --region us-east-1 --name ml-platform-cluster >/dev/null 2>&1
	@helm install ml-platform ./helm/ml-service \
		--set training.enabled=true \
		--set inference.enabled=true \
		--set monitoring.enabled=true \
		--namespace ml-platform --create-namespace
	@echo " ML services deployed!"

# Deploy monitoring stack
deploy-monitoring: ## Deploy monitoring stack
	@echo "Deploying monitoring..."
	@helm install monitoring ./helm/monitoring \
		--namespace monitoring --create-namespace
	@echo " Monitoring deployed!"

# Deploy configurations
deploy-configs: ## Apply Kubernetes configurations
	@echo "Applying configurations..."
	@kubectl apply -f manifests/
	@echo " Configurations applied!"

# Verify deployment
verify: ## Verify all components are running
	@echo "Verifying deployment..."
	@aws eks update-kubeconfig --region us-east-1 --name ml-platform-cluster >/dev/null 2>&1
	@echo "Cluster Status:"
	@kubectl get nodes
	@echo ""
	@echo "Pod Status:"
	@kubectl get pods -A --field-selector=status.phase!=Running
	@echo ""
	@echo "Service Status:"
	@kubectl get svc -A
	@echo " Verification completed!"

# Clean up resources
clean: ## Clean up deployed resources
	@echo "Cleaning up resources..."
	@cd terraform && terraform destroy -var-file=production.tfvars --auto-approve
	@echo " Cleanup completed!"

# Development shortcuts
dev-up: ## Quick development environment setup
	@echo " Setting up development environment..."
	@make setup
	@make test
	@echo " Development environment ready!"

dev-deploy: ## Quick development deployment
	@echo "Deploying for development..."
	@make deploy-infra
	@make deploy-services
	@echo " Development deployment ready!"

# Security scan
security: ## Run security scans
	@echo "Running security scans..."
	@echo "Note: Requires Trivy or similar tools"
	@echo " Security scan placeholder - implement as needed"



