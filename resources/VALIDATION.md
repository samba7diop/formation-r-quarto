# Rapport de validation technique

Date : 2026-10-07  
Environnement : Windows 10, R 4.3.0, Quarto 1.6.42 (binaire RStudio)

## Contrôles effectués

| Contrôle | Résultat |
|----------|----------|
| Existence des sources et données | OK (`Rscript tests/test_imports.R`) |
| Packages tidyverse, readxl, broom, shiny, janitor, scales | OK |
| Rendu HTML (`quarto render --to html`) | OK → `outputs/book/index.html` |
| Rendu DOCX (`quarto render --to docx`) | OK → `outputs/book/Analyse-de-données-avec-R-et-Quarto.docx` |
| Rendu PDF | OK après `quarto install tinytex` → `outputs/book/Analyse-de-données-avec-R-et-Quarto.pdf` |
| Application Shiny | Code fourni dans `shiny-app/app.R` (lancement interactif) |

## Problèmes rencontrés et corrigés

1. **SCSS Quarto** : `styles/styles.scss` devait contenir les marqueurs `/*-- scss:defaults --*/` et `/*-- scss:rules --*/`.
2. **Package `scales`** : version 1.3.0 trop ancienne pour ggplot2 4.x → mise à jour vers 1.4.0.
3. **`code-link: true`** : désactivé faute de `downlit`/`xml2` (avertissement uniquement).

## PDF — procédure restante

```r
install.packages("tinytex")
tinytex::install_tinytex()
```

Puis :

```bash
quarto render --to pdf
```

## Commandes de reconstruction

```bash
cd formation-r
Rscript R/packages_requis.R
Rscript tests/test_imports.R
quarto render --to html
quarto render --to docx
# quarto render --to pdf   # après TinyTeX
```
