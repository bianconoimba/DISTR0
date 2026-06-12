#!/usr/bin/env bash
# DISTR0 Build Script
# Main orchestrator for system customization
# This script sources configuration modules and applies all customizations

set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() { echo -e "${BLUE}[INFO]${NC} $*"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*"; return 1; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Import configuration modules
source "${SCRIPT_DIR}/config/packages.sh"
source "${SCRIPT_DIR}/config/system-settings.sh"
source "${SCRIPT_DIR}/config/gnome-config.sh"
source "${SCRIPT_DIR}/config/performance-tuning.sh"
source "${SCRIPT_DIR}/config/automatic-updates.sh"

log_info "Starting DISTR0 build process..."

# Step 1: Package Management
log_info "Step 1: Configuring package management..."
configure_dnf_settings
remove_bloatware_packages
install_core_packages
log_success "Package management configured"

# Step 2: System Configuration
log_info "Step 2: Applying system configuration..."
configure_system_basics
configure_systemd_services
log_success "System configuration complete"

# Step 3: GNOME Desktop Environment
log_info "Step 3: Configuring GNOME Desktop Environment..."
configure_gnome_base
apply_gnome_defaults
log_success "GNOME configuration complete"

# Step 4: Performance Tuning
log_info "Step 4: Applying performance optimizations..."
optimize_system_performance
optimize_boot_process
log_success "Performance optimization complete"

# Step 5: Automatic Updates
log_info "Step 5: Enforcing automatic updates..."
enable_automatic_updates
lock_update_settings
log_success "Automatic updates enabled and locked"

# Step 6: Additional utilities and tools
log_info "Step 6: Installing additional utilities..."
install_developer_tools
install_cli_utilities
log_success "Additional utilities installed"

log_success "DISTR0 build completed successfully!"
log_info "Image is ready for deployment"
