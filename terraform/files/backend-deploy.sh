#!/bin/bash

yum update
yum install docker -y
usermod -aG docker ec2-user
systemctl enable docker
systemctl start docker

yum install git -y

cat << HEREDOC > /root/.ssh/id_rsa
-----BEGIN OPENSSH PRIVATE KEY-----
-----END OPENSSH PRIVATE KEY-----
HEREDOC

chmod 0400 /root/.ssh/id_rsa

mkdir -p /src/my-backend-app

cd /src/my-backend-app

cat << HEREDOC > ./DanitTerraformProject.pem
-----BEGIN RSA PRIVATE KEY-----
-----END RSA PRIVATE KEY-----
HEREDOC

ssh-keyscan github.com >> /root/.ssh/known_hosts
git clone git@github.com:amidshukurov/amid-terraform-stepproject.git

cd amid-terraform-stepproject/backend

docker build -t my-backend-app:v1.0.0 .
docker run -di -e MYSQL_URL=${msql_url} -e MYSQL_USERNAME=${msql_username} -e MYSQL_PASSWORD=${msql_password} --name my-backend-app -p 80:80 my-backend-app:v1.0.0
