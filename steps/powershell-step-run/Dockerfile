FROM relaysh/core:latest

# install the requirements for PowerShell
RUN apk add --no-cache \
    ca-certificates \
    less \
    ncurses-terminfo-base \
    krb5-libs \
    libgcc \
    libintl \
    libssl1.1 \
    libstdc++ \
    tzdata \
    userspace-rcu \
    zlib \
    icu-libs \
    curl
RUN apk -X https://dl-cdn.alpinelinux.org/alpine/edge/main add --no-cache \
    lttng-ust

# Download the PowerShell '.tar.gz' archive
RUN curl -L https://github.com/PowerShell/PowerShell/releases/download/v7.2.0/powershell-7.2.0-linux-alpine-x64.tar.gz -o /tmp/powershell.tar.gz

# Create the target folder where PowerShell will be placed
RUN mkdir -p /opt/microsoft/powershell/7

# Expand PowerShell to the target folder
RUN tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7

# Set execute permissions
RUN chmod +x /opt/microsoft/powershell/7/pwsh

# Create the symbolic link that points to pwsh
RUN ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh

# Setup PowerShell profile
COPY profile.ps1 /opt/microsoft/powershell/7/profile.ps1

SHELL ["pwsh", "-Command"]

# Install commonly-used PowerShell modules
RUN Install-Module -Name Az -RequiredVersion 7.1.0 -Force -Scope AllUsers

# Copy the step file
COPY step.ps1 /scripts/step.ps1

CMD ["pwsh", "-Command", "/scripts/step.ps1"]

LABEL "org.opencontainers.image.title"="PowerShell"
LABEL "org.opencontainers.image.description"="This step container runs a PowerShell script."
LABEL "com.puppet.nebula.sdk.version"="v1"
