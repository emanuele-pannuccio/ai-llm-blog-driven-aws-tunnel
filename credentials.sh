#!/bin/bash

jwt_token=$(curl -sH "Metadata-Flavor: Google" "http://metadata/computeMetadata/v1/instance/service-accounts/default/identity?audience=$GCP_OAUTH_AUD&format=full&licenses=FALSE")
credentials=$(aws sts assume-role-with-web-identity --profile credentials_script --role-arn $AWS_ROLE_ARN --role-session-name $GCP_OAUTH_AUD --web-identity-token $jwt_token | jq '.Credentials' | jq '.Version=1')
echo $credentials