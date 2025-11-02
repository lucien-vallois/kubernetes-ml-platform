# Kubernetes ML Platform Runbook

## Emergency Contacts

- **Platform Team**: ml-platform-team@company.com
- **On-call Engineer**: +1-555-0123 (PagerDuty)
- **AWS Support**: Enterprise support case

## Quick Start

### Deploy New Environment
```bash
# 1. Clone repository
git clone https://github.com/company/kubernetes-ml-platform.git
cd kubernetes-ml-platform

# 2. Configure AWS credentials
aws configure

# 3. Initialize Terraform
cd terraform
terraform init

# 4. Plan deployment
terraform plan -var-file=production.tfvars

# 5. Apply changes
terraform apply -var-file=production.tfvars

# 6. Configure kubectl
aws eks update-kubeconfig --name ml-platform-cluster

# 7. Deploy services
cd ..
helm install ml-platform ./helm/ml-service
helm install monitoring ./helm/monitoring
```

### Access Services
```bash
# Get cluster info
kubectl cluster-info

# List namespaces
kubectl get namespaces

# Access Grafana
kubectl port-forward -n monitoring svc/grafana 3000:80
# Open http://localhost:3000 (admin/admin123)

# Access Prometheus
kubectl port-forward -n monitoring svc/prometheus-server 9090:80
# Open http://localhost:9090
```

## Monitoring

### Key Metrics to Monitor

#### Infrastructure Metrics
- **Cluster CPU/Memory**: Should not exceed 80%
- **Node Status**: All nodes should be Ready
- **Pod Status**: No pods in CrashLoopBackOff
- **Storage Usage**: EFS and S3 usage below 90%

#### ML Metrics
- **Training Jobs**: Success rate > 95%
- **Inference Latency**: P95 < 500ms
- **GPU Utilization**: Should be > 70% during training
- **Model Accuracy**: Monitor for degradation

### Alerting Rules

#### Critical Alerts (Page immediately)
- **Cluster Unavailable**: EKS control plane unreachable
- **Node Failures**: > 20% of nodes unhealthy
- **Storage Full**: EFS or S3 at > 95% capacity
- **Training Job Failures**: > 5 jobs failed in 1 hour

#### Warning Alerts (Monitor closely)
- **High Resource Usage**: CPU/Memory > 85%
- **Inference Latency**: P95 > 1000ms
- **GPU Memory Issues**: GPU memory allocation failures

## Troubleshooting

### Common Issues

#### 1. Pods Not Starting
```bash
# Check pod status
kubectl get pods -n ml-platform

# Check pod events
kubectl describe pod <pod-name> -n ml-platform

# Check node capacity
kubectl describe nodes

# Common causes:
# - Insufficient resources (CPU/Memory)
# - Image pull failures
# - Network issues
```

#### 2. GPU Not Available
```bash
# Check GPU nodes
kubectl get nodes -l node-type=gpu

# Check NVIDIA device plugin
kubectl logs -n kube-system daemonset/nvidia-device-plugin

# Check GPU allocation
kubectl describe pod <training-pod>
```

#### 3. Training Job Hanging
```bash
# Check job status
kubectl get jobs -n ml-platform

# Check pod logs
kubectl logs <training-pod> -n ml-platform

# Common causes:
# - GPU memory issues
# - Network timeouts
# - Dataset access problems
```

#### 4. High Inference Latency
```bash
# Check HPA status
kubectl get hpa -n ml-platform

# Check pod resource usage
kubectl top pods -n ml-platform

# Check network policies
kubectl get networkpolicies -n ml-platform

# Common causes:
# - Insufficient replicas
# - Resource constraints
# - Network congestion
```

#### 5. Storage Issues
```bash
# Check PVC status
kubectl get pvc -n ml-platform

# Check EFS mount
kubectl describe pvc <pvc-name> -n ml-platform

# Check S3 access
kubectl logs <pod-using-s3> -n ml-platform
```

## Maintenance Procedures

### Cluster Updates

#### EKS Version Upgrade
```bash
# 1. Check available versions
aws eks describe-cluster --name ml-platform-cluster --query cluster.version

# 2. Update Terraform configuration
# Edit terraform/variables.tf - update kubernetes_version

# 3. Plan upgrade
terraform plan

# 4. Apply upgrade
terraform apply

# 5. Update kubeconfig
aws eks update-kubeconfig --name ml-platform-cluster

# 6. Verify cluster health
kubectl get nodes
kubectl get pods -A
```

#### Node Group Updates
```bash
# 1. Update instance types in terraform/eks.tf
# 2. Plan changes
terraform plan

# 3. Apply changes (will trigger rolling update)
terraform apply

# 4. Monitor rollout
kubectl get nodes --watch
```

### Backup Procedures

#### Infrastructure Backup
```bash
# Terraform state is automatically backed up to S3
# Verify backup location
terraform show
```

#### Data Backup
```bash
# EFS snapshots (AWS managed)
aws efs describe-file-systems --file-system-id <fs-id>

# S3 versioning enabled automatically
aws s3api get-bucket-versioning --bucket <artifacts-bucket>
```

#### Model Backup
```bash
# Models stored in S3 with versioning
aws s3 ls s3://<artifacts-bucket>/models/ --recursive

# Create manual backup
aws s3 cp s3://<source-bucket>/models/ s3://<backup-bucket>/models/ --recursive
```

## Scaling Procedures

### Horizontal Scaling

#### Scale Inference Service
```bash
# Manual scaling
kubectl scale deployment ml-inference -n ml-platform --replicas=5

# Update HPA
kubectl edit hpa ml-inference-hpa -n ml-platform
```

#### Scale Training Nodes
```bash
# Update node group in terraform/eks.tf
# Change desired_size in gpu_training node group

# Apply changes
terraform apply
```

### Vertical Scaling

#### Update Resource Limits
```bash
# Edit deployment
kubectl edit deployment ml-inference -n ml-platform

# Update resource requests/limits
resources:
  requests:
    cpu: "2"
    memory: "4Gi"
  limits:
    cpu: "4"
    memory: "8Gi"
```

## Security Procedures

### Access Control
```bash
# Create service account
kubectl create serviceaccount ml-user -n ml-platform

# Create role binding
kubectl create rolebinding ml-user-binding \
  --clusterrole=edit \
  --serviceaccount=ml-platform:ml-user \
  --namespace=ml-platform
```

### Certificate Rotation
```bash
# Check certificate expiration
kubectl get secrets -n ml-platform

# Rotate certificates (AWS managed for EKS)
# Certificates are automatically rotated by AWS
```

## Performance Tuning

### GPU Optimization
```bash
# Enable GPU sharing
kubectl apply -f manifests/gpu-scheduling/gpu-sharing-config.yaml

# Monitor GPU usage
kubectl logs -n monitoring prometheus-gpu-exporter
```

### Network Optimization
```bash
# Check network policies
kubectl get networkpolicies -n ml-platform

# Update network policies if needed
kubectl edit networkpolicy ml-platform-network-policy -n ml-platform
```

### Storage Optimization
```bash
# Monitor EFS performance
aws efs describe-file-systems --file-system-id <fs-id>

# Enable EFS performance mode if needed
aws efs modify-file-system \
  --file-system-id <fs-id> \
  --performance-mode maxIO
```

## Incident Response

### Severity Levels

#### P1 - Critical (Response: 15 minutes)
- Complete service outage
- Data loss
- Security breach
- Production impacting issues

#### P2 - High (Response: 1 hour)
- Partial service degradation
- Performance issues affecting users
- Failed deployments

#### P3 - Medium (Response: 4 hours)
- Minor functionality issues
- Monitoring alerts
- Non-production issues

#### P4 - Low (Response: 24 hours)
- Cosmetic issues
- Documentation updates
- Feature requests

### Incident Response Process

1. **Acknowledge**: Confirm receipt of alert
2. **Assess**: Determine impact and severity
3. **Communicate**: Notify stakeholders
4. **Investigate**: Gather information and logs
5. **Resolve**: Implement fix
6. **Document**: Record incident and resolution
7. **Review**: Post-mortem analysis

### Communication Templates

#### Initial Response
```
INCIDENT ACKNOWLEDGED

Status: Investigating
Impact: <description of impact>
ETA: <estimated resolution time>
Updates: Every 30 minutes

On-call: <engineer name>
```

#### Resolution
```
INCIDENT RESOLVED

Root Cause: <brief description>
Resolution: <what was done>
Prevention: <preventive measures>

Duration: <time from alert to resolution>
Affected: <systems/services impacted>
```

## Post-Mortem Process

### Timeline Requirements
- Create timeline within 24 hours of incident
- Include all key events and actions
- Identify detection and response times

### Analysis Requirements
- Root cause analysis (5 Whys)
- Impact assessment
- Contributing factors

### Action Items
- Immediate fixes (within 24 hours)
- Short-term improvements (within 1 week)
- Long-term changes (within 1 month)

### Follow-up
- Action item tracking
- Effectiveness verification
- Documentation updates



