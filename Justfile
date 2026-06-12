# DISTR0 Justfile
# Task automation for building and managing DISTR0 images

set shell := ["bash", "-uc"]

# Configuration
image_name := "distr0"
default_tag := "latest"
image_registry := "ghcr.io"
image_owner := "bianconoimba"
full_image_name := image_registry / image_owner / image_name
bib_image := "quay.io/centos-bootc/bootc-image-builder:latest"

# Default recipe
default: help

# Display help
@help:
    echo "DISTR0 Build System"
    echo "Available commands:"
    just --list --unsorted

# Build container image
build target_image=full_image_name tag=default_tag:
    @echo "Building {{ target_image }}:{{ tag }}..."
    podman build -f Containerfile -t {{ target_image }}:{{ tag }} -t {{ target_image }}:latest .
    @echo "Build complete: {{ target_image }}:{{ tag }}"

# Push image to registry
push target_image=full_image_name tag=default_tag:
    @echo "Pushing {{ target_image }}:{{ tag }} to registry..."
    podman push {{ target_image }}:{{ tag }}
    podman push {{ target_image }}:latest
    @echo "Push complete"

# Build and push in one step
publish target_image=full_image_name tag=default_tag: (build target_image tag) (push target_image tag)

# Build QCOW2 virtual machine image
build-qcow2 target_image=full_image_name tag=default_tag:
    @echo "Building QCOW2 image from {{ target_image }}:{{ tag }}..."
    podman run --rm --privileged \
        -v {{ invocation_directory() }}:/output \
        {{ bib_image }} \
        --disk-type qcow2 \
        --output-format qcow2 \
        {{ target_image }}:{{ tag }}
    @echo "QCOW2 image ready: output/qcow2/disk.qcow2"

# Build ISO image
build-iso target_image=full_image_name tag=default_tag:
    @echo "Building ISO image from {{ target_image }}:{{ tag }}..."
    podman run --rm --privileged \
        -v {{ invocation_directory() }}:/output \
        {{ bib_image }} \
        --disk-type iso \
        --output-format iso \
        {{ target_image }}:{{ tag }}
    @echo "ISO image ready: output/iso/disk.iso"

# Build raw disk image
build-raw target_image=full_image_name tag=default_tag:
    @echo "Building raw disk image from {{ target_image }}:{{ tag }}..."
    podman run --rm --privileged \
        -v {{ invocation_directory() }}:/output \
        {{ bib_image }} \
        --disk-type raw \
        --output-format raw \
        {{ target_image }}:{{ tag }}
    @echo "Raw image ready: output/raw/disk.raw"

# Run QCOW2 image in QEMU
run-vm-qcow2 image="output/qcow2/disk.qcow2" ram="4G" cpu="4":
    @echo "Starting VM with {{ ram }} RAM and {{ cpu }} CPUs..."
    qemu-system-x86_64 \
        -m {{ ram }} \
        -smp {{ cpu }} \
        -hda {{ image }} \
        -enable-kvm \
        -vga virtio \
        -serial stdio \
        -net nic,model=virtio \
        -net user,hostfwd=tcp::2222-:22

# Rebuild QCOW2 image
rebuild-qcow2: clean (build-qcow2)

# Clean build artifacts
clean:
    @echo "Cleaning build artifacts..."
    rm -rf output/
    podman image prune -f
    @echo "Clean complete"

# Check Justfile and build scripts syntax
check:
    @echo "Checking Justfile syntax..."
    just --check
    @echo "Checking shell scripts..."
    bash -n build_files/build.sh
    for script in build_files/config/*.sh; do \
        bash -n "$$script"; \
    done
    @echo "All syntax checks passed"

# Format shell scripts
format:
    @echo "Formatting shell scripts..."
    shfmt -i 4 -w build_files/build.sh
    for script in build_files/config/*.sh; do \
        shfmt -i 4 -w "$$script"; \
    done
    @echo "Formatting complete"

# Lint shell scripts
lint:
    @echo "Linting shell scripts..."
    shellcheck build_files/build.sh
    for script in build_files/config/*.sh; do \
        shellcheck "$$script"; \
    done
    @echo "Linting complete"

# View system information
info:
    @echo "DISTR0 Build Configuration"
    @echo "Image Name: {{ image_name }}"
    @echo "Registry: {{ image_registry }}"
    @echo "Owner: {{ image_owner }}"
    @echo "Full Image: {{ full_image_name }}"
    @echo "Default Tag: {{ default_tag }}"

# Show image build history
history:
    @echo "Recent builds:"
    podman image ls | grep {{ image_name }} || echo "No images found"

# Remove all DISTR0 images
rm-images:
    @echo "Removing all DISTR0 images..."
    podman image rm -f $(podman image ls | grep {{ image_name }} | awk '{print $3}') || true
    @echo "Images removed"

# Full workflow: build, check, and list
all: check build
    @echo "Build workflow complete"
    just history
