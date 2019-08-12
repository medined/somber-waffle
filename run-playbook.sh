#!/bin/bash

RANDOMIZER=$1
if [ -z $RANDOMIZER ]; then
  RANDOMIZER=$(uuid | cut -b-8)
fi

AMI_ID=$(./find-amazon2-ami.sh)
AWS_PROFILE="personal"
OWNER="somber-waffle"
HOSTS_FILE="./hosts-$RANDOMIZER"
INSTANCE_PROFILE_NAME="launch-configuration-roll"
PROJECT_NAME="xyz"
SUBNETA_ID="subnet-03adda49"
SUBNETB_ID="subnet-aa0cae84"
VPC_ID="vpc-684da712"

echo "      AMI_ID: $AMI_ID"
echo " AWS_PROFILE: $AWS_PROFILE"
echo "       HOSTS: $HOSTS_FILE"
echo "       OWNER: $OWNER"
echo "PROJECT_NAME: $PROJECT_NAME"
echo "  RANDOMIZER: $RANDOMIZER"
echo "   SUBNET_ID: $SUBNET_ID"
echo "      VPC_ID: $VPC_ID"

export ANSIBLE_VAULT_PASSWORD_FILE=~/.ansible-vault-pass.txt

ALB_BUCKET_NAME="$PROJECT_NAME-$RANDOMIZER-alb-logs"
ALB_BUCKET_POLICY_JSON_FILE="$ALB_BUCKET_NAME.json"
AWS_ACCOUNT="532914043478"
AWS_PRINCIPAL="127311923021"  # us-east-1

cat << EOF > "$ALB_BUCKET_POLICY_JSON_FILE"
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::$ALB_BUCKET_NAME/logs/AWSLogs/$AWS_ACCOUNT/*",
      "Principal": {
        "AWS": [
          "$AWS_PRINCIPAL"
        ]
      }
    }
  ]
}
EOF

CONTROL_RUN_PLAYBOOK="true"

if [ "$CONTROL_RUN_PLAYBOOK" == "true" ]; then
  ansible-playbook \
    -vvv \
    playbook-present.yml \
    --extra-vars "@vault.yml" \
    --extra-vars "alb_bucket_name=$ALB_BUCKET_NAME" \
    --extra-vars "alb_bucket_policy=$ALB_BUCKET_POLICY_JSON_FILE" \
    --extra-vars "ami_id=$AMI_ID" \
    --extra-vars "ansible_ssh_private_key_file=/home/medined/.ssh/odol-sango.pem" \
    --extra-vars "instance_profile_name=$INSTANCE_PROFILE_NAME" \
    --extra-vars "instance_type=t2.nano" \
    --extra-vars "key_name=odol-sango" \
    --extra-vars "owner=$OWNER" \
    --extra-vars "project_name=$PROJECT_NAME" \
    --extra-vars "randomizer=$RANDOMIZER" \
    --extra-vars "region_name=us-east-1" \
    --extra-vars "subnet_a_id=$SUBNETA_ID" \
    --extra-vars "subnet_b_id=$SUBNETB_ID" \
    --extra-vars "vpc_id=$VPC_ID"
fi

##########
# Since we are finding all EC2 instances with the same randomizer,
# we can delete the hosts file.

rm -rf $HOSTS_FILE
echo '[all]' > $HOSTS_FILE
for PUBLIC_ADDRESS in $(\
  aws ec2 describe-instances \
  --filter "Name=tag:owner,Values=$OWNER, Name=tag:randomizer,Values=$RANDOMIZER" \
  --query 'Reservations[].Instances[].PublicIpAddress' \
  --output text\
)
do
   echo "$PUBLIC_ADDRESS" >> "$HOSTS_FILE"
done
