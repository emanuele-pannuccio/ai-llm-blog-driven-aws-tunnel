FROM google/cloud-sdk:519.0.0-slim

RUN apt-get update && apt-get install -y unzip jq curl \
    && rm -rf /var/lib/apt/lists/*

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip  && \
    ./aws/install && \
    rm -r awscliv2.zip ./aws

RUN curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb" && \
    dpkg -i session-manager-plugin.deb

RUN mkdir -p /root/.aws

COPY config /root/.aws

COPY credentials.sh /root/credentials.sh

RUN chmod +x /root/credentials.sh

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh

# Permissions
RUN chmod +x /entrypoint.sh

#

ENTRYPOINT ["/entrypoint.sh"]
