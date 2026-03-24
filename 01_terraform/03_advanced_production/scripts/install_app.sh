#!/bin/bash

# 1. Wait for apt lock
while fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do
    echo "Waiting for Ubuntu apt lock..."
    sleep 5
done

# 2. Install Ubuntu 24.04 specific packages & MySQL headers
apt-get update -y
apt-get install -y unzip python3-pip python3-venv python3.12-venv netcat-openbsd libmysqlclient-dev pkg-config

# 3. Install AWS CLI v2 (Direct Download for Ubuntu 24.04)
if ! command -v aws &> /dev/null; then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip -o awscliv2.zip
    sudo ./aws/install
fi

# 4. Deployment Logic
cd /home/ubuntu
aws s3 cp s3://balumangu-terraform-project-v2/artifacts/app.zip .
unzip -o app.zip -d app/
cd app/

# 5. Python Environment Setup
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

# 6. Start Application with Environment Variables
sudo \
DB_HOST="${db_endpoint}" \
DB_USER="${db_username}" \
DB_PASS="${db_password}" \
DB_NAME="${db_name}" \
/home/ubuntu/app/venv/bin/python3 /home/ubuntu/app/app.py > /home/ubuntu/app/app.log 2>&1 &