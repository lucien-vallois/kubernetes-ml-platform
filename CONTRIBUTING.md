# Contributing to Kubernetes ML Platform

Thank you for your interest in contributing to the Kubernetes ML Platform! This document provides guidelines and information for contributors.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [How to Contribute](#how-to-contribute)
- [Development Workflow](#development-workflow)
- [Testing](#testing)
- [Documentation](#documentation)
- [Pull Request Process](#pull-request-process)
- [Community](#community)

## Code of Conduct

This project follows a code of conduct to ensure a welcoming environment for all contributors. By participating, you agree to:

- Be respectful and inclusive
- Focus on constructive feedback
- Accept responsibility for mistakes
- Show empathy towards other community members

## Getting Started

### Prerequisites

Before you begin, ensure you have:

- **Terraform** >= 1.0
- **Helm** >= 3.0
- **kubectl** >= 1.24
- **AWS CLI** >= 2.0
- **Git** >= 2.0

### Quick Setup

```bash
# Fork and clone the repository
git clone https://github.com/lucien-vallois/kubernetes-ml-platform.git
cd kubernetes-ml-platform

# Set up development environment
make setup

# Run tests to ensure everything works
make test
```

## Development Setup

### 1. Clone the Repository

```bash
git clone https://github.com/lucien-vallois/kubernetes-ml-platform.git
cd kubernetes-ml-platform
```

### 2. Create Development Environment

```bash
# Set up all dependencies
make setup

# Or manually:
# - Install Terraform
# - Install Helm
# - Install kubectl
# - Configure AWS CLI
```

### 3. Configure AWS (Optional for Local Development)

```bash
aws configure
# Enter your AWS credentials
```

### 4. Verify Setup

```bash
# Run all tests
make test

# Or individually:
make test-terraform
make test-helm
make test-manifests
```

## How to Contribute

### Types of Contributions

- **Bug Fixes**: Fix existing issues
- **Features**: Add new functionality
- **Documentation**: Improve documentation
- **Tests**: Add or improve tests
- **Tools**: Development tools and scripts

### Finding Issues to Work On

1. Check the [Issues](https://github.com/lucien-vallois/kubernetes-ml-platform/issues) page
2. Look for issues labeled `good first issue` or `help wanted`
3. Comment on the issue to indicate you're working on it

### Reporting Bugs

When reporting bugs, please include:

- **Description**: Clear description of the issue
- **Steps to reproduce**: Step-by-step instructions
- **Expected behavior**: What should happen
- **Actual behavior**: What actually happens
- **Environment**: Terraform version, AWS region, etc.
- **Logs**: Relevant error messages or logs

## Development Workflow

### 1. Choose an Issue

Select an issue from the [Issues](https://github.com/lucien-vallois/kubernetes-ml-platform/issues) page or create your own.

### 2. Create a Branch

```bash
# Create a feature branch
git checkout -b feature/your-feature-name

# Or for bug fixes
git checkout -b fix/issue-number-description
```

### 3. Make Changes

```bash
# Make your changes
# Follow the coding standards and conventions

# Format your code
make format

# Run tests
make test
```

### 4. Commit Changes

```bash
# Add your changes
git add .

# Commit with a clear message
git commit -m "feat: add new feature description

- What was changed
- Why it was changed
- How it was implemented"

# Or for fixes:
git commit -m "fix: resolve issue with component

- Root cause
- Solution implemented
- Tests added"
```

### 5. Push and Create PR

```bash
# Push your branch
git push origin feature/your-feature-name

# Create a Pull Request on GitHub
```

## Testing

### Running Tests

```bash
# Run all tests
make test

# Run specific test suites
make test-terraform    # Terraform validation
make test-helm        # Helm chart linting
make test-manifests   # Kubernetes manifest validation
```

### Adding Tests

- **Terraform**: Add test files in `terraform/tests/`
- **Helm**: Update chart tests in `helm/*/tests/`
- **Integration**: Add end-to-end tests in `tests/`

### Test Coverage

Aim for comprehensive test coverage:

- Unit tests for individual components
- Integration tests for component interaction
- End-to-end tests for complete workflows

## Documentation

### Documentation Standards

- Use clear, concise language
- Include code examples where helpful
- Keep documentation up to date
- Use consistent formatting

### Updating Documentation

```bash
# Update README.md
# Update docs/ files
# Update inline code comments

# Test documentation builds
make docs
```

## Pull Request Process

### PR Requirements

- [ ] Tests pass (`make test`)
- [ ] Code formatted (`make format`)
- [ ] Documentation updated
- [ ] Commit messages follow conventional commits
- [ ] PR description clearly explains changes

### PR Template

Please use the PR template and include:

1. **Description**: What changes were made and why
2. **Type of change**: Bug fix, feature, documentation, etc.
3. **Testing**: How changes were tested
4. **Breaking changes**: Any breaking changes
5. **Screenshots**: If UI changes were made

### Review Process

1. **Automated Checks**: CI/CD pipeline runs
2. **Peer Review**: At least one maintainer reviews
3. **Approval**: PR approved and merged
4. **Deployment**: Changes deployed to staging/production

## Community

### Getting Help

- **Email**: Contact maintainers directly
- **Discussions**: Use GitHub Discussions for questions
- **Issues**: Report bugs and request features

### Communication Channels

- **GitHub Issues**: Bug reports and feature requests
- **GitHub Discussions**: General questions and discussions
- **Pull Requests**: Code contributions

### Recognition

Contributors are recognized through:

- GitHub contributor statistics
- Mention in release notes
- Special contributor badges

## Recognition

We appreciate all contributions! Contributors may be:

- Listed in `CONTRIBUTORS.md`
- Mentioned in release notes
- Invited to become maintainers
- Featured in community spotlights

---

Thank you for contributing to the Kubernetes ML Platform!



