#!/bin/bash
set -e

: "${INSTANCE_NAME?Variabile INSTANCE_NAME mancante}"
: "${REMOTE_HOST?Variabile REMOTE_HOST mancante}"
: "${REMOTE_PORT?Variabile REMOTE_PORT mancante}"
: "${LOCAL_PORT?Variabile LOCAL_PORT mancante}"
: "${AWS_REGION?Variabile AWS_REGION mancante}"
: "${GCP_PROJECT_ID?Variabile GCP_SECRET_NAME mancante}"
: "${AWS_ACCESS_KEY_ID_SECRET?Variabile AWS_ACCESS_KEY_ID_SECRET mancante}"
: "${AWS_SECRET_ACCESS_KEY_SECRET?Variabile AWS_SECRET_ACCESS_KEY_SECRET mancante}"

SSH_USER=${SSH_USER:-ec2-user}

echo "Fetching AWS credentials from Secret Manager..."

export AWS_ACCESS_KEY_ID=$(gcloud secrets versions access latest \
  --secret="$AWS_SECRET_ACCESS_KEY_SECRET" \
  --project="$GCP_PROJECT_ID")
  
export AWS_SECRET_ACCESS_KEY=$(gcloud secrets versions access latest \
  --secret="$AWS_SECRET_ACCESS_KEY_SECRET" \
  --project="$GCP_PROJECT_ID")

# Start AWS EC2 Instance Connect Tunnel
echo "Starting AWS EC2 SSM Session..."

# Ottieni l'ID dell'istanza EC2
export INSTANCE_ID=$(aws ec2 describe-instances \
               --filter "Name=tag:Name,Values=$INSTANCE_NAME" \
               --query "Reservations[].Instances[?State.Name == 'running'].InstanceId[]" \
               --output text)

# Avvia la sessione SSM per il port forwarding
aws ssm start-session \
    --target $INSTANCE_ID \
    --document-name AWS-StartPortForwardingSessionToRemoteHost \
    --region $AWS_REGION \
    --parameters "{\"host\":[\"$REMOTE_HOST\"], \"portNumber\":[\"$REMOTE_PORT\"], \"localPortNumber\":[\"$LOCAL_PORT\"]}"
