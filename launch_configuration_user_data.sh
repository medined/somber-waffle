#!/bin/bash

amazon-linux-extras install -y nginx1.12
systemctl start nginx
systemctl enable nginx
echo "Complete."
