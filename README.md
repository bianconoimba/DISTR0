# DISTR0 - Optimized Immutable Linux Distribution

DISTR0 è una distribuzione Linux altamente ottimizzata e immutabile, basata su Fedora 44 con GNOME Desktop Environment. Costruita usando [bootc](https://github.com/bootc-dev/bootc) e il [template di Universal Blue](https://github.com/ublue-os/image-template), DISTR0 fornisce un sistema sicuro, veloce e potente progettato per la massima produttività.

## Caratteristiche Principali

### 🚀 Prestazioni
- **Ottimizzato per la velocità**: Configurazione del sistema sintonizzata per prestazioni reattive
- **Niente bloatware**: Solo applicazioni essenziali incluse di default
- **Strumenti moderni**: Ultimi strumenti di sviluppo e utilità
- **Ottimizzazione automatica**: CPU governor, I/O scheduler e tuning della memoria

### 🔒 Sicurezza
- **Filesystem immutabile**: Integrità del sistema protetta per design
- **Aggiornamenti di sicurezza automatici**: Patch obbligatorie e inmodificabili
- **Firewall integrato**: Regole firewall preconfigurate
- **Pronto per SELinux**: Compatibile con politiche di sicurezza avanzate

### 🎨 GNOME Esclusivo
- **Esperienza coerente**: GNOME Shell come unico desktop environment
- **Interfaccia moderna**: Ultimi feature GNOME e estensioni
- **Impostazioni ottimizzate**: Preconfigurato per prestazioni ottimali e usabilità
- **Estensioni incluse**: Dash-to-Dock, AppIndicator, Vitals

### 📦 Strumenti Completi
- **Sviluppo**: Git, Make, GCC, Clang, Node.js, Rust, Python3 e altro
- **DevOps**: Podman, Docker, Buildah, systemd-nspawn
- **CLI moderni**: ripgrep, fd, bat, fzf, exa, starship, zoxide
- **Amministrazione di sistema**: Strumenti avanzati di monitoraggio, debugging e networking

### 🔄 Design Immutabile
- **Aggiornamenti atomici**: Cambio di versione al boot senza tempi morti
- **Rollback capability**: Recupero sicuro se gli aggiornamenti causano problemi
- **Integrazione bootc**: Cambio facile da altri sistemi immutabili

## Quick Start

### Passare a DISTR0

Se sei su un altro sistema immutabile (Fedora Atomic, Bluefin, Bazzite, ecc.):

```bash
sudo bootc switch ghcr.io/bianconoimba/distr0:latest
sudo systemctl reboot
```

Dopo il reboot, stai eseguendo DISTR0!

### Costruire l'immagine localmente

```bash
# Clonare il repository
git clone https://github.com/bianconoimba/DISTR0
cd DISTR0

# Installare cosign per la firma
curl -fsSLo /usr/local/bin/cosign https://github.com/sigstore/cosign/releases/latest/download/cosign-linux-amd64
chmod +x /usr/local/bin/cosign

# Generare chiavi di firma
COSIGN_PASSWORD="" cosign generate-key-pair

# Aggiungere il segreto di firma a GitHub
gh secret set SIGNING_SECRET < cosign.key

# Il flusso di lavoro GitHub Actions costruirà e farà push su push a main
```

## Architettura

DISTR0 usa un sistema di configurazione modulare per la facile personalizzazione:

```
build_files/
├── build.sh                 # Script di orchestrazione principale
└── config/
    ├── packages.sh          # Gestione e installazione pacchetti
    ├── system-settings.sh   # Configurazione del sistema core
    ├── gnome-config.sh      # Setup del GNOME Desktop Environment
    ├── performance-tuning.sh # Ottimizzazioni di prestazioni
    └── automatic-updates.sh # Applicazione forzata degli aggiornamenti automatici
```

## Personalizzazione

DISTR0 è progettato per essere facilmente modificato:

### Aggiungere pacchetti

Modifica `build_files/config/packages.sh` e aggiungi agli array appropriati:

```bash
CORE_PACKAGES=(
    # Aggiungi i tuoi pacchetti qui
    "your-package"
)
```

### Modificare le impostazioni GNOME

Modifica `build_files/config/gnome-config.sh` per regolare le impostazioni dconf:

```bash
cat > /etc/dconf/db/local.d/00-distr0 <<'EOF'
[org/gnome/desktop/interface]
# Le tue impostazioni qui
EOF
```

### Performance Tuning

Modifica `build_files/config/performance-tuning.sh` per regolare i parametri di tuning del sistema.

## Informazioni di Sistema

- **OS Base**: Fedora 44 Bootc
- **Desktop**: GNOME Shell (Esclusivo)
- **Init System**: systemd
- **Package Manager**: DNF con ottimizzazioni
- **Tecnologia Container**: Podman (primario), Docker (opzionale)
- **Modello di Aggiornamento**: Immutabile con bootc

## Applicazioni Incluse

### Sistema
- GNOME Shell, Settings, Terminal, Files
- System Monitor (estensione Vitals)
- Firewall (firewalld)
- Power Management (TLP)

### Sviluppo
- Git, GitHub CLI
- Python 3, Pip, venv
- Node.js, npm, yarn
- Rust (rustup)
- Go, Ruby, Perl, Lua
- Build tools (Make, CMake, Ninja, GCC, Clang)

### Utilità
- CLI moderni: ripgrep, fd, bat, fzf, exa, starship, zoxide
- Editor di testo: nano, vim, helix
- Strumenti di archivio: zip, unzip, 7zip, xz, bzip2
- Strumenti di rete: openssh, wireguard, openvpn, nmap, mtr

### Multimedia
- MPV (video player)
- FFmpeg
- ImageMagick
- Calibre (ebook management)

## Requisiti di Sistema

- **CPU**: x86-64 moderno (Intel Core i5+ o equivalente)
- **RAM**: 4GB minimo, 8GB+ consigliato
- **Archiviazione**: 20GB di spazio libero minimo
- **BIOS/UEFI**: UEFI consigliato, BIOS supportato

## Aggiornamenti Automatici

DISTR0 forza gli aggiornamenti automatici che **non possono essere disabilitati dagli utenti**:

- **Aggiornamenti di sicurezza**: Applicati automaticamente e immediatamente
- **Aggiornamenti di sistema**: Applicati di notte (2 AM di default)
- **Aggiornamenti immagine**: Via bootc (staged, applicati al prossimo boot)
- **Configurazione**: Non può essere scavalcata da utenti normali

Questo assicura che il tuo sistema abbia sempre le ultime patch di sicurezza e miglioramenti.

## Troubleshooting

### Problemi di Boot

Se incontri problemi di boot dopo un aggiornamento:

```bash
# Controlla lo stato di boot
sudo bootc status

# Rollback alla versione precedente
sudo bootc rollback
sudo systemctl reboot
```

### Controlla i Log

```bash
# Visualizza i log di sistema
journalctl -xe

# Visualizza i log degli aggiornamenti
journalctl -u dnf-automatic-install.timer
journalctl -u distr0-updates.service
```

## Contribuire

I contributi sono benvenuti! Aree di miglioramento:

1. Applicazioni e strumenti aggiuntivi
2. Ottimizzazioni di prestazioni per hardware specifico
3. Estensioni GNOME aggiuntive
4. Miglioramenti della documentazione
5. Test e segnalazione di bug

## Licenza

DISTR0 è autorizzato sotto GNU General Public License v3.0 (GPLv3).

## Link

- [Documentazione bootc](https://github.com/bootc-dev/bootc)
- [Universal Blue](https://universal-blue.org/)
- [Progetto Fedora](https://fedoraproject.org/)
- [Progetto GNOME](https://www.gnome.org/)
- [Repository GitHub](https://github.com/bianconoimba/DISTR0)

## Supporto & Comunità

- **Issues & Discussions**: [GitHub Issues](https://github.com/bianconoimba/DISTR0/issues)
- **Comunità Fedora**: [Fedora Discourse](https://discussion.fedoraproject.org/)
- **Universal Blue**: [Universal Blue Discourse](https://universal-blue.discourse.group/)
- **Discussione bootc**: [bootc Discussions](https://github.com/bootc-dev/bootc/discussions)

---

**DISTR0** - Ottimizzata. Sicura. Potente.

Passa oggi: `sudo bootc switch ghcr.io/bianconoimba/distr0:latest`
