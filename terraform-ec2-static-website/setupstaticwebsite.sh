#!/bin/bash
set -e

apt update -y
apt install -y apache2

systemctl enable apache2
systemctl start apache2

echo "Hello World from Terraform" > /var/www/html/index.html