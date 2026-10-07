# =============================================================================
# Installation et vérification des packages du livre
# Exécution : Rscript R/packages_requis.R
# =============================================================================

packages <- c(
  "tidyverse",   # dplyr, ggplot2, tidyr, readr, stringr, purrr, tibble, forcats
  "readxl",      # lecture Excel
  "lubridate",   # dates (inclus dans tidyverse récent, explicitement listé)
  "broom",       # résultats de modèles en data frames
  "shiny",       # applications interactives
  "knitr",       # exécution de code dans documents
  "rmarkdown",   # R Markdown
  "gt",          # tableaux soignés (optionnel mais utile)
  "janitor",     # nettoyage rapide des noms de colonnes
  "scales",      # formatage des axes ggplot2
  "writexl"      # écriture Excel pour les données d'exemple
)

installer_si_manquant <- function(pkgs) {
  inst <- rownames(installed.packages())
  manquants <- setdiff(pkgs, inst)
  if (length(manquants) > 0) {
    message("Installation de : ", paste(manquants, collapse = ", "))
    install.packages(manquants, repos = "https://cloud.r-project.org")
  } else {
    message("Tous les packages requis sont déjà installés.")
  }
}

verifier <- function(pkgs) {
  ok <- vapply(pkgs, requireNamespace, quietly = TRUE, FUN.VALUE = logical(1))
  statut <- data.frame(
    package = pkgs,
    disponible = ok,
    stringsAsFactors = FALSE
  )
  print(statut)
  invisible(all(ok), "Certains packages manquent. Relancez ce script.")
  invisible(TRUE)
}

installer_si_manquant(packages)
verifier(packages)

message("Version de R : ", R.version.string)
