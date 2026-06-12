# Contribuire a DISTR0

Grazie per il tuo interesse nel contribuire a DISTR0! Questo documento fornisce linee guida e istruzioni per il contributo.

## Codice di Condotta

Sii rispettoso, inclusivo e professionale in tutte le interazioni.

## Come Contribuire

### Segnalare Bug

1. Controlla i problemi esistenti per evitare duplicati
2. Crea un nuovo issue con:
   - Titolo chiaro e descrittivo
   - Descrizione dettagliata del problema
   - Passaggi per riprodurre
   - Comportamento atteso vs reale
   - Versione di DISTR0 e informazioni di sistema

### Suggerire Miglioramenti

1. Controlla gli issue/discussioni esistenti
2. Crea un issue descrivendo:
   - L'idea di miglioramento
   - Casi d'uso e vantaggi
   - Approccio di implementazione potenziale

### Inviare Modifiche

1. Fork il repository
2. Crea un branch di feature: `git checkout -b feature/your-feature`
3. Fai le tue modifiche seguendo la guida di stile
4. Testa le tue modifiche: `just check lint`
5. Commit con messaggi chiari: `git commit -m "Add feature X"`
6. Push al tuo fork
7. Crea un Pull Request con:
   - Descrizione chiara delle modifiche
   - Riferimento ai problemi correlati
   - Screenshot se applicabile

## Setup di Sviluppo

```bash
# Clonare il repository
git clone https://github.com/bianconoimba/DISTR0
cd DISTR0

# Installare le dipendenze
sudo dnf install -y podman buildah podman-compose

# Installare just
curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash

# Compilare localmente
just build
```

## Guida di Stile

### Script Shell

- Usa lo shebang `#!/usr/bin/env bash`
- Imposta `set -euo pipefail` all'inizio
- Usa 4 spazi di indentazione
- Aggiungi commenti per la logica complessa
- Esegui `just format` prima di eseguire il commit

### Organizzazione File

- Mantieni la funzionalità correlata in moduli di configurazione dedicati
- Usa nomi chiari e descrittivi
- Documenta le funzioni con commenti

### Git Commits

- Scrivi messaggi di commit chiari
- Fai riferimento ai problemi: "Fixes #123"
- Mantieni i commit focalizzati e atomici
- Usa conventional commits quando possibile: `feat:`, `fix:`, `docs:`, ecc.

## Testing

Prima di inviare:

```bash
# Controlla la sintassi
just check

# Lint script
just lint

# Formato codice
just format

# Compilare immagine di test
just build
```

## Aree di Contributo

- Applicazioni e strumenti aggiuntivi
- Ottimizzazioni di prestazioni
- Personalizzazioni di GNOME
- Miglioramenti della documentazione
- Correzioni di bug
- Ottimizzazioni specifiche dell'hardware
- Localizzazione/traduzioni

## Processo di Pull Request

1. Aggiorna la documentazione come necessario
2. Aggiungi commenti spiegando i cambiamenti complessi
3. Assicurati che tutti i controlli passino
4. Richiedi revisione dai manutentori
5. Affronta il feedback prontamente

## Riconoscimento

I contributori saranno riconosciuti in:
- Voci di CHANGELOG
- Pagina dei contributori di GitHub
- Note di rilascio

## Domande?

Sentiti libero di:
- Aprire un issue per domande
- Avviare una discussione
- Contattare i manutentori

Grazie per aver reso DISTR0 migliore!
