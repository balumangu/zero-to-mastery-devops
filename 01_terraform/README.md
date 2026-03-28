# 🚀 AWS Terraform Infrastructure Portfolio

![Terraform](https://img.shields.io/badge/IaC-Terraform-623CE4?logo=terraform)
![AWS](https://img.shields.io/badge/Cloud-AWS-FF9900?logo=amazonaws)
![Python](https://img.shields.io/badge/App-Python-3776AB?logo=python)
![Architecture](https://img.shields.io/badge/Architecture-Highly_Available-success)
![Security](https://img.shields.io/badge/Security-Zero_Trust-critical)

---

## 📌 Overview

This repository showcases a **progressive cloud engineering journey using Terraform on AWS**, evolving from a basic infrastructure setup to a **production-grade, highly available, and secure multi-tier architecture**.

It demonstrates real-world best practices in:
- Infrastructure as Code (IaC)
- High availability design
- Secure cloud architecture (zero-trust)
- Modular Terraform development
- Automated application deployment

---

## 🧱 Project Levels

### 🔹 Level 1 — Static Web Infrastructure
Provisioned a complete AWS environment to host a web server using Terraform.

**Key highlights:**
- Custom VPC with public subnet
- Internet Gateway and routing
- EC2 instance with automated Nginx setup
- Bootstrap provisioning using `user_data`
- Fully reproducible infrastructure

---

### 🔹 Level 2 — Highly Available 2-Tier Architecture
Upgraded the architecture to a scalable and resilient system using Terraform modules.

**Key highlights:**
- Multi-AZ deployment for fault tolerance
- Application Load Balancer (ALB)
- Auto Scaling Group (ASG) with Launch Templates
- Private subnets for compute resources
- NAT Gateway for secure outbound access
- Reusable Terraform modules (DRY principle)

---

### 🔹 Level 3 — Production-Grade Multi-Tier Application
Built a real-world production architecture with strict security and automation.

**Key highlights:**
- Fully modular Terraform architecture
- Python-based web application with MySQL (RDS)
- Multi-AZ deployment across all layers
- Zero public access to EC2 and database
- AWS Systems Manager (SSM) replacing SSH
- Remote state management using S3 and DynamoDB
- Automated deployment via S3 artifacts
- Dynamic scaling using CloudWatch + ASG

---

## 🔒 Security Approach

- Zero public access to compute and database layers  
- No SSH access (replaced with SSM Session Manager)  
- Strict security group chaining between layers  
- Private subnet isolation for all sensitive resources  

---

## ⚙️ Key Capabilities Demonstrated

- Designing highly available AWS architectures  
- Writing modular and reusable Terraform code  
- Implementing secure, production-grade infrastructure  
- Automating deployments with immutable artifacts  
- Managing Terraform state for team environments  
- Building self-healing and auto-scaling systems  

---

## 🛠️ Tech Stack

- **Cloud:** AWS (EC2, ALB, RDS, S3, VPC, IAM, SSM, CloudWatch)  
- **Infrastructure as Code:** Terraform  
- **Application:** Python (Flask)  
- **Database:** MySQL (RDS)  

---

## 🧠 Key Takeaways

- Transitioned from single-instance deployments to distributed systems  
- Applied industry best practices for high availability and security  
- Built a zero-trust architecture eliminating direct access to servers  
- Achieved fully automated infrastructure and application deployment