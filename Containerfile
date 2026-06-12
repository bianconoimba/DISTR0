ARG FEDORA_VERSION=44

FROM quay.io/fedora/fedora-bootc:${FEDORA_VERSION}

# Set labels for image metadata
LABEL description="DISTR0: Optimized Immutable Linux Distribution" \
      maintainer="bianconoimba" \
      version="1.0.0"

# Copy build scripts
COPY build_files/ /tmp/build_files/

# Make scripts executable
RUN chmod +x /tmp/build_files/*.sh

# Run the build script
RUN /tmp/build_files/build.sh

# Clean up
RUN rm -rf /tmp/build_files /var/cache/dnf/* /var/cache/yum/* /tmp/*
