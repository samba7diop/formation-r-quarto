# Tests minimaux de cohérence du projet
# Exécution : Rscript tests/test_imports.R  (depuis formation-r/)

echecs <- 0
ok <- function(cond, msg) {
  if (!isTRUE(cond)) {
    message("ECHEC: ", msg)
    echecs <<- echecs + 1
  } else {
    message("OK: ", msg)
  }
}

fichiers <- c(
  "data/ventes.csv",
  "data/demographie.csv",
  "data/meteo.csv",
  "data/etudes_notes.csv",
  "data/clients.csv",
  "data/commandes.csv",
  "data/ventes.xlsx",
  "data/meteo_extrait.txt",
  "data/brut/ventes_brutes.csv",
  "_quarto.yml",
  "index.qmd",
  "shiny-app/app.R"
)

for (f in fichiers) {
  ok(file.exists(f), paste("existe:", f))
}

pkgs <- c("tidyverse", "readxl", "broom", "knitr")
for (p in pkgs) {
  ok(requireNamespace(p, quietly = TRUE), paste("package:", p))
}

# Import smoke tests
suppressPackageStartupMessages({
  library(readr)
  library(readxl)
})

ventes <- read_csv("data/ventes.csv", show_col_types = FALSE)
ok(nrow(ventes) > 50, "ventes a des lignes")
ok(all(c("montant", "region", "produit") %in% names(ventes)), "colonnes ventes")

xl <- read_excel("data/ventes.xlsx")
ok(nrow(xl) > 0, "excel lisible")

chapitres <- list.files("chapters", pattern = "\\.qmd$", full.names = TRUE)
ok(length(chapitres) >= 9, paste("chapitres .qmd:", length(chapitres)))

if (echecs == 0) {
  message("\nTous les tests sont passés.")
  quit(status = 0)
} else {
  message("\nNombre d'échecs: ", echecs)
  quit(status = 1)
}
