#!/usr/bin/env bash
# Package management configuration for DISTR0
# Handles DNF optimization, bloatware removal, and core package installation

set -euo pipefail

# Configure DNF for optimal performance
configure_dnf_settings() {
    log_info "Configuring DNF settings..."
    
    # Optimize DNF configuration
    mkdir -p /etc/dnf/vars
    
    cat > /etc/dnf/dnf.conf <<'EOF'
[main]
installonly_limit=3
cleanup_on_remove=True
fastestmirror=True
max_parallel_downloads=10
deltarpm=True
keepcache=False
compression=zstd
compressionlevel=19
EOF
    
    # Update all packages to latest versions
    dnf update -y --refresh
    
    log_success "DNF optimized"
}

# Remove bloatware and unnecessary packages
remove_bloatware_packages() {
    log_info "Removing bloatware packages..."
    
    # List of packages to remove (keeping only GNOME, no KDE)
    BLOATWARE=(
        "evolution" "evolution-data-server"
        "gnome-maps"
        "gnome-weather"
        "gnome-todo"
        "gnome-calendar"
        "solitaire" "five-or-more" "four-in-a-row"
        "gnome-games" "aisleriot"
        "totem"
        "epiphany"
        "rhythmbox"
        "cheese"
        "gedit"
        "tracker" "tracker-miners"
    )
    
    for package in "${BLOATWARE[@]}"; do
        dnf remove -y "$package" 2>/dev/null || true
    done
    
    dnf autoremove -y
    
    log_success "Bloatware removed"
}

# Install core packages and utilities
install_core_packages() {
    log_info "Installing core packages..."
    
    # Core system packages
    CORE_PACKAGES=(
        "gnome-shell" "gnome-shell-extensions" "gnome-control-center"
        "gnome-terminal" "nautilus" "gnome-settings-daemon"
        
        "git" "curl" "wget" "htop" "neofetch"
        "build-essential" "make" "gcc" "g++" "clang"
        "pkgconf" "cmake" "ninja-build"
        
        "nano" "vim" "helix"
        "ripgrep" "fd-find" "bat" "fzf"
        "zsh" "bash-completion" "zsh-completions"
        "tldr" "man-db" "man-pages"
        
        "systemd-devel" "perf" "strace" "ltrace"
        "lsof" "iotop" "nethogs" "vnstat"
        
        "podman" "podman-compose" "buildah" "skopeo"
        "libvirt" "qemu-system-x86"
        
        "mpv" "ffmpeg" "imagemagick"
        "sox"
        
        "rsync" "rclone" "fuse-sshfs"
        "zip" "unzip" "xz" "bzip2"
        "p7zip" "tar" "gzip"
        
        "openssh-clients" "openssh-server"
        "wireguard-tools" "openvpn"
        "iproute2" "iputils" "bind-utils" "whois"
        "iperf" "mtr" "nmap"
        
        "sqlite" "postgresql-client" "mysql-client"
        "redis" "jq" "yq"
        
        "libreoffice" "libreoffice-calc" "libreoffice-writer"
        "calibre"
        
        "pandoc" "ghostscript" "poppler-utils"
        
        "python3" "python3-pip" "python3-venv"
        "python3-devel" "perl" "ruby" "lua"
        
        "lynis" "aide" "openscap-utils"
        "fail2ban" "firewalld"
        
        "fontawesome-fonts" "liberation-fonts"
        "noto-fonts" "noto-fonts-cjk" "noto-fonts-extra"
        "dejavu-fonts" "terminus-fonts"
        
        "adwaita-gtk2-theme" "adwaita-icon-theme"
        "breeze-cursor-theme" "breeze-icon-theme"
        
        "gnome-shell-extension-appindicator"
        "gnome-shell-extension-dash-to-dock"
        "gnome-shell-extension-vitals"
    )
    
    dnf install -y "${CORE_PACKAGES[@]}"
    
    install_developer_tools
    
    log_success "Core packages installed"
}

# Install specialized developer tools
install_developer_tools() {
    log_info "Installing developer tools..."
    
    DEV_TOOLS=(
        "nodejs" "npm" "yarn"
        "golang" "rustup"
        "java-latest-openjdk" "java-latest-openjdk-devel"
        "php" "php-cli" "php-fpm"
        "r-base" "r-devel"
        "docker"
        "git-lfs"
        "gh"
    )
    
    for tool in "${DEV_TOOLS[@]}"; do
        dnf install -y "$tool" 2>/dev/null || log_warn "Failed to install $tool"
    done
    
    log_success "Developer tools installed"
}

# Install CLI utilities from alternative sources
install_cli_utilities() {
    log_info "Installing CLI utilities..."
    
    if command -v cargo &> /dev/null; then
        RUST_TOOLS=(
            "exa"
            "starship"
            "zoxide"
            "bottom"
            "just"
            "dua"
        )
        
        for tool in "${RUST_TOOLS[@]}"; do
            cargo install "$tool" 2>/dev/null || true
        done
    fi
    
    log_success "CLI utilities installed"
}
