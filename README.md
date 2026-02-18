# aws-uptime-monitor-iac

Production-style AWS uptime monitor built with Terraform (IaC).  
It provisions a web target (EC2 + Elastic IP) and an automated monitoring pipeline (Lambda + EventBridge + SNS) with CloudWatch logs and remote Terraform state.

## Architecture

- Custom VPC (public subnet)
- EC2 (Apache) + Elastic IP
- Lambda uptime checker (Python)
- EventBridge schedule (rate: 1 minute)
- SNS email alerts
- CloudWatch logs
- Terraform remote backend (S3 + DynamoDB locking)

## Project structure

```
bootstrap/   # S3 backend + DynamoDB locking
infra/       # VPC, EC2, EIP, SNS, Lambda, EventBridge
docs/        # screenshots used in this README
```

## Demo evidence

### Web target online
![Web target](docs/phase2-browser.png)

### Lambda check working (CloudWatch logs)
![Lambda proof](docs/phase4-cloudwatch-proof.png)

### Scheduled execution every minute
![Automatic execution](docs/phase5-automatic-execution.png)

### Outage detected + email alert
![Down detected](docs/phase6-down-detected.png)
![Email alert](docs/phase6-email-alert.png)

### Recovery detected
![Recovery](docs/phase6-recovery.png)

## Deploy

### 1) Bootstrap remote state

```bash
cd bootstrap
terraform init
terraform apply -var="name_prefix=uptime-iac-yourname"
```

### 2) Deploy infrastructure + monitoring

```bash
cd ../infra
terraform init
terraform apply \
  -var="name_prefix=uptime-iac-yourname" \
  -var="alert_email=you@example.com" \
  -var="check_url=http://<ELASTIC_IP>"
```

## Destroy

```bash
cd infra
terraform destroy \
  -var="name_prefix=uptime-iac-yourname" \
  -var="alert_email=you@example.com" \
  -var="check_url=http://<ELASTIC_IP>"
```

## Notes

- Region: `eu-west-2`
- Terraform: `1.14.x`
