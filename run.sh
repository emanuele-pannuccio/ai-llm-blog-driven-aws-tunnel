docker run -it -p 3307:3307 \
           --rm \
           -v $HOME/.config/gcloud:/root/.config/gcloud \
           -e GOOGLE_APPLICATION_CREDENTIALS=/root/.config/gcloud/application_default_credentials.json \
           -e INSTANCE_NAME=automated-blog-bastion-host \
           -e REMOTE_HOST=automated-blog-db.cdm00oci41gf.eu-west-1.rds.amazonaws.com \
           -e REMOTE_PORT=3306 \
           -e LOCAL_PORT=3306 \
           -e LOCAL_SSH_PORT=3307 \
           -e AWS_REGION=eu-west-1 \
           -e GCP_PROJECT_ID=gcp-automated-blog-test \
           aws-gcp-tunnel

           #