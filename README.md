# Analyse de données avec R et Quarto

Livre de formation progressif en français pour apprendre l'analyse de données avec **R**, du premier script jusqu'au rapport Quarto et à l'application **Shiny**.

## Description et objectifs

Ce projet fournit un ouvrage pédagogique complet, reproductible et générable en **HTML**, **PDF** et **DOCX**. À l'issue du parcours, l'apprenant peut importer des données brutes, les préparer, les analyser, les visualiser et communiquer ses conclusions.

## Public cible

- Débutants en programmation
- Étudiants et universitaires
- Professionnels en montée en compétences data
- Personnes découvrant la statistique appliquée

Aucune connaissance préalable de R n'est requise.

## Prérequis

| Outil | Obligatoire | Notes |
|-------|-------------|-------|
| R (≥ 4.1 recommandé) | Oui | Testé avec R 4.3 |
| Quarto CLI | Oui | Ou Quarto fourni avec RStudio |
| RStudio Desktop | Recommandé | Facultatif |
| Packages R | Oui | Voir ci-dessous |
| LaTeX / TinyTeX | Pour le PDF seulement | |

## Technologies

R, Quarto, tidyverse (dplyr, tidyr, ggplot2, readr, stringr), readxl, lubridate, broom, Shiny, knitr, R Markdown.

## Installation de l'environnement

### 1. Vérifier R

```bash
Rscript --version
```

Sous Windows (exemple) :

```text
C:\Program Files\R\R-4.3.0\bin\x64\Rscript.exe --version
```

### 2. Vérifier Quarto

```bash
quarto --version
```

Si `quarto` n'est **pas reconnu** (erreur « terme non reconnu »), Quarto est souvent fourni avec RStudio mais absent du PATH. Dans PowerShell :

```powershell
$env:Path = "C:\Program Files\RStudio\resources\app\bin\quarto\bin;" + $env:Path
quarto --version
```

Ou appelez le chemin complet :

```powershell
& "C:\Program Files\RStudio\resources\app\bin\quarto\bin\quarto.exe" --version
```

Puis placez-vous dans le dossier du livre :

```powershell
cd "C:\Users\Alhamdoulilah\Desktop\LIVRE R\formation-r"
```

### 3. Installer les packages R

Dans un terminal, depuis le dossier `formation-r/` :

```bash
Rscript R/packages_requis.R
```

### 4. (Optionnel) TinyTeX pour le PDF

```r
install.packages("tinytex")
tinytex::install_tinytex()
```

### 5. Générer les données (si besoin)

```bash
Rscript R/generer_donnees.R
```

Les CSV / Excel pédagogiques sont déjà fournis dans `data/`.

## Prévisualisation et génération

Placez-vous dans `formation-r/` :

```bash
# Prévisualisation HTML
quarto preview

# Livre HTML
quarto render --to html

# Document Word
quarto render --to docx

# PDF (si LaTeX disponible)
quarto render --to pdf
```

Les sorties sont écrites dans `outputs/book/`.

## Structure des fichiers

```text
formation-r/
├── _quarto.yml          # Configuration du livre
├── index.qmd            # Page d'accueil
├── README.md
├── LICENSE
├── references.qmd
├── chapters/            # Chapitres I–XI + annexes
├── exercices/           # Synthèses et corrections
├── data/                # Jeux de données
├── R/                   # Scripts utilitaires
├── shiny-app/           # Application interactive
├── styles/              # CSS / SCSS
├── tests/               # Contrôles automatiques
├── resources/           # Bibliographie
└── outputs/             # Rendus générés
```

## Contenu des chapitres

| Fichier | Contenu |
|---------|---------|
| `01-introduction` | Analyse de données, installation, premier programme |
| `02-fondements-r` | Types, structures, conditions, fonctions, packages |
| `03-acquisition-donnees` | CSV, Excel, texte, chemins, qualité d'import |
| `04-preparation-donnees` | dplyr, tidyr, NA, jointures, dates, textes |
| `05-statistiques-descriptives` | EDA, résumés, corrélation, interprétation |
| `06-visualisation` | ggplot2, export, bonnes pratiques |
| `07-modelisation` | Inférence, tests, régression, limites |
| `08-rapports` | Quarto, HTML/PDF/DOCX, bibliographie |
| `09-shiny` | Applications interactives |
| `10-projets` | Cinq projets + projet final |
| `11-annexes` | Erreurs, navigation, publication |
| Annexes A–B | Glossaire et aide-mémoires |

## Application Shiny

```bash
Rscript -e "shiny::runApp('shiny-app', launch.browser=TRUE)"
```

## Exécution des tests

```bash
Rscript tests/test_imports.R
```

## Procédure de mise à jour

1. Modifier les sources `.qmd` ou les scripts `R/`
2. Régénérer les données si le simulateur change
3. Relancer `quarto render --to html`
4. Relancer les tests

## Problèmes fréquents

| Problème | Solution |
|----------|----------|
| `quarto` introuvable | Ajouter Quarto au PATH ou utiliser le binaire RStudio |
| Package manquant au render | `Rscript R/packages_requis.R` |
| Fichier data introuvable | Lancer les commandes depuis `formation-r/` |
| Échec PDF | Installer TinyTeX ; le HTML/DOCX restent disponibles |
| Accents cassés | Fichiers en UTF-8 ; `read_csv` / `fileEncoding` |

## Contribution

Les améliorations pédagogiques (clarifications, exercices, corrections d'errata) sont les bienvenues via pull request ou patch. Conservez le français, la reproductibilité et le style des chapitres existants.

## Licence

Creative Commons Attribution 4.0 International (CC BY 4.0) — voir `LICENSE`.  
Auteur et titulaire des droits : Samba Diop.

## Références officielles

- <https://www.r-project.org/>
- <https://quarto.org/>
- <https://www.tidyverse.org/>
- <https://ggplot2.tidyverse.org/>
- <https://shiny.posit.co/>
- <https://r4ds.hadley.nz/>
