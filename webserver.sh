#!/bin/bash
sudo yum -y install httpd
sudo echo "its a webserver" > /var/www/html/index.html
sudo systemctl start httpd
sudo systemctl enable httpd