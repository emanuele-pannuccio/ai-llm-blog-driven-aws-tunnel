FROM google/cloud-sdk:519.0.0-slim

# Install AWS CLI and OpenSSH client
RUN apt-get update && apt-get install -y \
    openssh-client unzip socat \
    && rm -rf /var/lib/apt/lists/*

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip  && \
    ./aws/install && \
    rm -r awscliv2.zip ./aws

RUN curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb" && \
    dpkg -i session-manager-plugin.deb

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh

# Permissions
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
