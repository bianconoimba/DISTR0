#!/usr/bin/env bash
# Performance tuning for DISTR0

set -euo pipefail

# Optimize system performance
optimize_system_performance() {
    log_info "Optimizing system performance..."
    
    configure_cpu_governor
    configure_io_scheduler
    enable_ssd_trim
    
    cat > /etc/sysctl.d/99-memory.conf <<'EOF'
vm.page-cluster=3
vm.readahead_kb=256
vm.swappiness=10
vm.overcommit_memory=1
EOF
    
    sysctl -p /etc/sysctl.d/99-memory.conf
    
    log_success "System performance optimized"
}

# Optimize boot process
optimize_boot_process() {
    log_info "Optimizing boot process..."
    
    mkdir -p /etc/systemd/system.conf.d
    cat > /etc/systemd/system.conf.d/distr0-boot.conf <<'EOF'
[Manager]
DefaultTimeoutStartSec=10s
DefaultTimeoutStopSec=10s
EOF
    
    for service in avahi-daemon cups bluetooth; do
        systemctl disable --now "$service.service" 2>/dev/null || true
    done
    
    log_success "Boot process optimized"
}

# Configure CPU frequency scaling
configure_cpu_governor() {
    log_info "Configuring CPU frequency scaling..."
    
    dnf install -y kernel-tools
    
    cat > /etc/default/grub.d/cpu-governor.cfg <<'EOF'
GRUB_CMDLINE_LINUX="${GRUB_CMDLINE_LINUX} intel_pstate=active amd_pstate=active"
EOF
    
    log_success "CPU frequency scaling configured"
}

# Configure I/O scheduler for responsiveness
configure_io_scheduler() {
    log_info "Configuring I/O scheduler..."
    
    cat > /etc/default/grub.d/io-scheduler.cfg <<'EOF'
GRUB_CMDLINE_LINUX="${GRUB_CMDLINE_LINUX} elevator=bfq"
EOF
    
    log_success "I/O scheduler configured"
}

# Enable SSD TRIM for NVMe and SATA SSDs
enable_ssd_trim() {
    log_info "Enabling SSD TRIM..."
    
    systemctl enable fstrim.timer
    systemctl start fstrim.timer || true
    
    log_success "SSD TRIM enabled"
}

# Optimize DNS for faster resolution
optimize_dns() {
    log_info "Optimizing DNS configuration..."
    
    mkdir -p /etc/systemd/resolved.conf.d
    cat > /etc/systemd/resolved.conf.d/distr0.conf <<'EOF'
[Resolve]
DNS=1.1.1.1 1.0.0.1 2606:4700:4700::1111 2606:4700:4700::1001
FallbackDNS=8.8.8.8 8.8.4.4
DNSSEC=yes
EOF
    
    systemctl restart systemd-resolved
    log_success "DNS optimized"
}
