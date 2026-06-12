#!/usr/bin/env bash
# System-level configuration for DISTR0
# Handles core system settings, services, and optimizations

set -euo pipefail

# Basic system configuration
configure_system_basics() {
    log_info "Configuring system basics..."
    
    echo "distr0" > /etc/hostname
    
    localectl set-locale LANG=en_US.UTF-8 LC_COLLATE=C
    
    timedatectl set-timezone UTC
    timedatectl set-ntp true
    
    cat > /etc/sysctl.d/99-distr0-optimization.conf <<'EOF'
# DISTR0 Performance Tuning

kernel.sched_migration_cost_ns = 5000000
kernel.sched_autogroup_enabled = 1
kernel.pid_max = 65536

vm.page-cluster = 3
vm.readahead_kb = 256
vm.dirty_ratio = 10
vm.dirty_background_ratio = 5
vm.swappiness = 10
vm.vfs_cache_pressure = 50

net.ipv4.ip_forward = 1
net.ipv4.conf.all.rp_filter = 2
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 30

kernel.kptr_restrict = 2
kernel.dmesg_restrict = 1
EOF
    
    sysctl -p /etc/sysctl.d/99-distr0-optimization.conf
    
    log_success "System basics configured"
}

# Configure systemd services
configure_systemd_services() {
    log_info "Configuring systemd services..."
    
    systemctl enable --now systemd-timesyncd.service
    systemctl enable --now systemd-resolved.service
    systemctl enable --now fstrim.timer
    systemctl enable --now logrotate.timer
    
    mkdir -p /etc/systemd/journald.conf.d
    cat > /etc/systemd/journald.conf.d/distr0.conf <<'EOF'
[Journal]
Storage=persistent
MaxRetentionSec=30day
MaxFileSec=7day
Compress=yes
Seal=yes
EOF
    
    systemctl restart systemd-journald
    
    systemctl disable --now bluetooth.service || true
    systemctl disable --now cups.service || true
    
    log_success "Systemd services configured"
}

# Configure CPU governor for performance
configure_cpu_governor() {
    log_info "Configuring CPU governor..."
    
    cat > /etc/modprobe.d/cpufreq.conf <<'EOF'
options cpufreq default_governor=performance
EOF
    
    log_success "CPU governor configured"
}

# Configure I/O scheduler
configure_io_scheduler() {
    log_info "Configuring I/O scheduler..."
    
    cat > /etc/default/grub.d/distr0-io.cfg <<'EOF'
GRUB_CMDLINE_LINUX="${GRUB_CMDLINE_LINUX} elevator=bfq"
EOF
    
    log_success "I/O scheduler configured"
}

# Set up automatic TRIM for SSDs
enable_ssd_trim() {
    log_info "Enabling SSD TRIM..."
    
    systemctl enable fstrim.timer
    systemctl start fstrim.timer
    
    log_success "SSD TRIM enabled"
}

# Configure power management
configure_power_management() {
    log_info "Configuring power management..."
    
    dnf install -y tlp tlp-rdw
    systemctl enable --now tlp.service
    systemctl disable systemd-rfkill.service || true
    systemctl disable systemd-rfkill.socket || true
    
    log_success "Power management configured"
}
