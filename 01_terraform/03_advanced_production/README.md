# 🏗️ Level 3: Production-Grade Highly Available Python App on AWS

## 🎯 Project Overview
This project provisions a production-grade, Highly Available Python web application on AWS using fully modular Terraform. The application accepts user registrations via an HTML form and persists the data to a MySQL database. The architecture enforces a strict zero-trust security model — no EC2 instance is publicly accessible, SSH is replaced entirely by AWS Systems Manager (SSM), and every layer only communicates with the layer directly behind it.

## 🏗️ Architecture Breakdown
- **Reusable Modules:** Every layer — networking, security groups, load balancer, compute, database, and storage — is abstracted into its own Terraform module. Zero hardcoded values.
- **Two Environments:** `dev` and `prod` are driven entirely by `environments/dev.tfvars` and `environments/prod.tfvars`.
- **Multi-AZ Deployment:** Distributed across two Availability Zones (`us-east-1a` and `us-east-1b`) for fault tolerance.
- **Public Tier:** Houses the Application Load Balancer (ALB) only.
- **Private Tier:** Houses EC2 instances (via ASG) and RDS MySQL. No public IPs. No open ports. No key pairs.
- **NAT Gateway:** Allows private EC2 instances outbound access for SSM agent communication and pulling `app.zip` from S3.
- **ASG + Launch Template:** Self-healing EC2 fleet with CloudWatch CPU alarms driving automatic scaling.
- **SSM Session Manager:** Replaces SSH (Port 22) entirely for secure, audited access.
- **S3 Storage:** Stores Terraform state with native locking and hosts the application deployment artifacts.

---

## 🔒 Security Model

| From | To | Port | Allowed |
|------|----|------|---------|
| Internet | ALB | 80 | ✅ |
| ALB SG | EC2 | 80 | ✅ |
| EC2 SG | RDS | 3306 | ✅ |
| EC2 SG | Internet | 443 | ✅ (SSM + S3 via NAT) |
| Anywhere | EC2 | 22 | ❌ Removed entirely |
| Internet | RDS | Any | ❌ |
| Internet | EC2 | Any | ❌ |

---

## 🗺️ Step-by-Step Execution & Architectural Rationale

### Step 1: The Network Foundation (`modules/networking`)
**What I Did:** Created a custom VPC spanning two AZs with two public and two private subnets. Configured an Elastic IP and a NAT Gateway in the public subnet to handle private subnet outbound routing.
**Rationale:** No compute resource should be directly reachable from the internet. The NAT Gateway provides a secure "one-way" door for updates and artifact pulling while blocking unsolicited inbound probes.

### Step 2: Defense in Depth (`modules/security_groups`)
**What I Did:** Created chained security groups where rules reference **Security Group IDs** rather than CIDR ranges.
**Rationale:** This ensures that even if a private IP is compromised, an attacker cannot move laterally unless they are coming from the specific allowed upstream security group.

### Step 3: The Traffic Cop (`modules/alb`)
**What I Did:** Deployed an external ALB across public subnets with a Target Group configured for active `/health` checks.
**Rationale:** The ALB provides a single stable DNS entry point. If an instance fails, the ALB stops routing to it instantly, ensuring zero downtime for the end user.

### Step 4: The Self-Healing Compute Fleet (`modules/asg`)
**What I Did:** Defined a Launch Template with an IAM profile for SSM and S3 access. The `user_data` script automates the installation of dependencies and the Flask service.
**Rationale:** Using `health_check_type = "ELB"` ensures that if the Flask app hangs (even if the VM is "up"), the ASG will terminate and replace the instance.

### Step 5: App Deployment via S3 (`modules/s3`)
**What I Did:** Used a `null_resource` with `local-exec` to zip the application and upload it to S3 during `terraform apply`. Used `filemd5` triggers to detect code changes.
**Rationale:** This treats the application code as an immutable artifact. Updating the app is now a single-command process: `terraform apply`.

### Step 6: The Database Layer (`modules/rds`)
**What I Did:** Provisioned RDS MySQL in a private DB Subnet Group. Multi-AZ is enabled in production for automatic failover.
**Rationale:** Database isolation is the highest priority. Multi-AZ ensures that if an entire AWS Data Center goes offline, the database survives with no manual intervention.

---

## 🌍 Environment Comparison

| Setting | Dev | Prod |
|---------|-----|------|
| VPC CIDR | 10.0.0.0/16 | 10.1.0.0/16 |
| EC2 instance type | t3.micro | t3.micro |
| ASG min / desired / max | 1 / 1 / 2 | 2 / 2 / 6 |
| CPU scale-up threshold | 70% | 60% |
| RDS Multi-AZ | false | true |

---

## 📸 Proof of Execution

### 1. Terraform Init
![Terraform Init](./screenshots/01_terraform_init.png)

### 2. Terraform Plan
![Terraform Plan](./screenshots/02_terraform_plan.png)

### 3. Terraform Apply Complete
![Terraform Apply](./screenshots/03_terraform_apply.png)

### 4. S3 — State File and App Zip
![S3 Bucket](./screenshots/04_s3_state_and_zip.png)

### 5. ALB Active
![ALB Active](./screenshots/05_alb_active.png)

### 6. Target Group — Both Instances Healthy
![Target Group Healthy](./screenshots/06_target_group_healthy.png)

### 7. EC2 Instances — Private Subnets, No Public IP
![Private EC2](./screenshots/07_ec2_private_no_public_ip.png)

### 8. SSM Session — Accessing Private EC2
![SSM Access](./screenshots/08_ssm_session.png)

### 9. RDS Available
![RDS Available](./screenshots/09_rds_available.png)

### 10. Auto Scaling Group
![ASG Console](./screenshots/10_asg_console.png)

### 11. Live App — Registration Form
![Live App](./screenshots/11_live_app_form.png)

### 12. Form Submission Saved to RDS
![Form Submission](./screenshots/12_form_submission.png)

### 13. High Availability Test — ASG Self-Healing
![ASG Self Healing](./screenshots/13_asg_self_healing.png)

### 14. Terraform Destroy Complete
![Terraform Destroy](./screenshots/14_terraform_destroy.png)

---

## 🧠 Lessons Learned
- **SSM over SSH:** Eliminating Port 22 removes the primary target for brute-force attacks while providing superior audit logs.
- **S3 as App Delivery:** Automating the zip-and-upload process via `local-exec` ensures the infrastructure and application version are always in sync.
- **Locked-down Egress:** Restricting outbound traffic to only required AWS services (SSM/S3) minimizes the blast radius of a potential compromise.
- **`filemd5` triggers:** Using file hashes as triggers ensures Terraform only performs work when the code actually changes, making deployments efficient.
- **Interactive password prompt:** Keeping sensitive data out of `.tfvars` files by forcing interactive prompts is a simple yet effective way to maintain secret security.