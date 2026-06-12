#!/usr/bin/env bash
# Automatic update configuration for DISTR0

set -euo pipefail

# Enable automatic updates via dnf-automatic
enable_automatic_updates() {
    log_info "Enabling automatic updates..."
    
    dnf install -y dnf-automatic
    
    cat > /etc/dnf/automatic.conf <<'EOF'
[commands]
upgrade_type = security
update_messages = yes
download_updates = yes
apply_updates = yes

[emitters]
system_name = DISTR0
message_type = stdio

[base]
installonly_limit = 3
EOF
    
    log_success "Automatic updates enabled"
}

# Lock automatic update settings to prevent user disabling
lock_update_settings() {
    log_info "Locking automatic update settings..."
    
    mkdir -p /etc/polkit-1/rules.d
    cat > /etc/polkit-1/rules.d/50-distr0-updates.rules <<'EOF'
polkit.addRule(function(action, subject) {
    if (action.id == "org.freedesktop.packagekit.system-update") {
        return polkit.Result.YES;
    }
});
EOF
    
    systemctl enable --now dnf-automatic.timer
    systemctl enable --now dnf-automatic-install.timer
    
    log_success "Update settings locked"
}
