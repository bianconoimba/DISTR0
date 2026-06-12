#!/usr/bin/env bash
# GNOME Desktop Environment configuration for DISTR0

set -euo pipefail

# Configure GNOME as the default (and only) desktop environment
configure_gnome_base() {
    log_info "Configuring GNOME base..."
    
    dnf remove -y plasma* kde* xfce* budgie* cinnamon* mate* lxde* deepin* 2>/dev/null || true
    
    dnf install -y \
        gnome-shell \
        gnome-shell-extensions \
        gnome-shell-extension-appindicator \
        gnome-shell-extension-dash-to-dock \
        gnome-shell-extension-vitals \
        gnome-control-center \
        gnome-settings-daemon \
        gnome-tweaks \
        dconf-editor
    
    update-alternatives --install /usr/bin/x-session-manager x-session-manager /usr/bin/gnome-session 100
    
    log_success "GNOME base configured"
}

# Apply GNOME default settings and optimizations
apply_gnome_defaults() {
    log_info "Applying GNOME defaults..."
    
    mkdir -p /etc/dconf/profile
    mkdir -p /etc/dconf/db/local.d
    
    cat > /etc/dconf/profile/user <<'EOF'
user-db:user
system-db:local
EOF
    
    cat > /etc/dconf/db/local.d/00-distr0 <<'EOF'
[org/gnome/desktop/interface]
gtk-theme='Adwaita-dark'
icon-theme='Adwaita'
cursor-theme='Breeze'
font-name='Noto Sans 11'
monospace-font-name='Monospace 11'
show-battery-percentage=true
enable-hot-corners=false

[org/gnome/desktop/privacy]
remember-recent-files=false
remove-old-temp-files=true
remove-old-trash-files=true
old-files-age=uint32 30

[org/gnome/desktop/peripherals/touchpad]
tap-to-click=true
two-finger-scrolling-enabled=true
speed=0.5

[org/gnome/settings-daemon/plugins/power]
power-button-action='suspend'
sleep-inactive-ac-timeout=900
sleep-inactive-battery-timeout=600

[org/gnome/desktop/wm/preferences]
button-layout='appmenu:minimize,maximize,close'

[org/gnome/shell]
favorite-apps=['org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.Software.desktop']
enable-hot-corners=false

[org/gnome/shell/extensions/dash-to-dock]
dock-position='BOTTOM'
show-trash=true
show-mounts=true

[org/gnome/nautilus/preferences]
default-sort-order='type'
show-hidden-files=false

[org/gnome/terminal/legacy]
menus-visible=false
scrollbar-policy='never'
EOF
    
    dconf update || true
    
    log_success "GNOME defaults applied"
}

# Optimize GNOME for performance
optimize_gnome_performance() {
    log_info "Optimizing GNOME for performance..."
    
    cat >> /etc/dconf/db/local.d/00-distr0 <<'EOF'

[org/gnome/desktop/interface]
enable-animations=false

[org/gnome/settings-daemon/plugins/power]
sleep-inactive-ac-timeout=1800
sleep-inactive-battery-timeout=900
EOF
    
    dconf update || true
    
    log_success "GNOME performance optimized"
}

# Configure GNOME online accounts and sync
configure_gnome_accounts() {
    log_info "Configuring GNOME online accounts..."
    
    dnf install -y gnome-online-accounts
    
    log_success "GNOME online accounts configured"
}
