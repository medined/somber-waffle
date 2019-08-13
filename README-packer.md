# Packer

* Install Packer

```
sudo apt install -y packer
```

# Validate Template

```
packer validate baseAMI.json
```

# Build AMI

```
packer build -var-file=vars.json baseAMI.json
packer build baseAMI.json
packer build \
    -var "aws_access_key=$AWS_ACCESS_KEY_ID" \
    -var "aws_secret_key=$AWS_SECRET_ACCESS_KEY" \
    example.json
```
