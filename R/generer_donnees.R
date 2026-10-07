# =============================================================================
# Script de génération des jeux de données pédagogiques
# Exécution : Rscript R/generer_donnees.R
# (depuis le dossier formation-r/)
# =============================================================================

set.seed(2024)

dir.create("data", showWarnings = FALSE, recursive = TRUE)
dir.create("data/brut", showWarnings = FALSE, recursive = TRUE)

# --- Projet 1 : ventes d'une petite entreprise --------------------------------
n_ventes <- 200
dates <- seq(as.Date("2023-01-01"), as.Date("2023-12-31"), by = "day")
ventes <- data.frame(
  id_vente = sprintf("V%04d", 1:n_ventes),
  date = sample(dates, n_ventes, replace = TRUE),
  region = sample(c("Nord", "Sud", "Est", "Ouest"), n_ventes, replace = TRUE,
                  prob = c(0.3, 0.25, 0.2, 0.25)),
  produit = sample(c("Stylo", "Cahier", "Classeur", "Agenda", "Marqueur"),
                   n_ventes, replace = TRUE),
  quantite = sample(1:20, n_ventes, replace = TRUE),
  prix_unitaire = round(runif(n_ventes, 1.5, 25), 2),
  stringsAsFactors = FALSE
)
ventes$montant <- round(ventes$quantite * ventes$prix_unitaire, 2)
# Introduire quelques valeurs manquantes et un doublon pour les exercices
ventes$region[c(5, 42)] <- NA
ventes$quantite[18] <- NA
ventes <- rbind(ventes, ventes[10, ])
write.csv(ventes, "data/ventes.csv", row.names = FALSE, fileEncoding = "UTF-8")

# Version « brute » avec colonnes mal nommées
ventes_brut <- ventes
names(ventes_brut) <- c("ID", "Date_Vente", "REGION", "Produit ", "Qte",
                        "PrixUnitaire", "TOTAL")
write.csv(ventes_brut, "data/brut/ventes_brutes.csv", row.names = FALSE,
          fileEncoding = "UTF-8")

# --- Projet 2 : données démographiques ----------------------------------------
n_demo <- 150
demo <- data.frame(
  id = 1:n_demo,
  age = sample(18:75, n_demo, replace = TRUE),
  sexe = sample(c("Femme", "Homme"), n_demo, replace = TRUE),
  ville = sample(c("Paris", "Lyon", "Marseille", "Lille", "Toulouse"),
                 n_demo, replace = TRUE),
  revenu_mensuel = round(rnorm(n_demo, mean = 2200, sd = 600), 0),
  niveau_etudes = sample(c("Bac", "Licence", "Master", "Doctorat", "Autre"),
                         n_demo, replace = TRUE, prob = c(0.3, 0.3, 0.25, 0.05, 0.1)),
  stringsAsFactors = FALSE
)
demo$revenu_mensuel[demo$revenu_mensuel < 800] <- 800
# Quelques valeurs aberrantes volontaires
demo$age[3] <- 150
demo$revenu_mensuel[7] <- 50000
write.csv(demo, "data/demographie.csv", row.names = FALSE, fileEncoding = "UTF-8")

# --- Projet 3 : météo ---------------------------------------------------------
n_meteo <- 365
meteo <- data.frame(
  date = seq(as.Date("2023-01-01"), as.Date("2023-12-31"), by = "day"),
  temperature_c = round(12 + 10 * sin(2 * pi * (1:n_meteo) / 365) +
                          rnorm(n_meteo, 0, 2.5), 1),
  precipitations_mm = pmax(0, round(rgamma(n_meteo, shape = 1, scale = 2), 1)),
  humidite_pct = pmin(100, pmax(20, round(rnorm(n_meteo, 65, 12), 0))),
  ville = "Exempleville",
  stringsAsFactors = FALSE
)
write.csv(meteo, "data/meteo.csv", row.names = FALSE, fileEncoding = "UTF-8")

# Fichier texte séparé par tabulations
write.table(meteo[1:30, ], "data/meteo_extrait.txt", sep = "\t",
            row.names = FALSE, quote = FALSE, fileEncoding = "UTF-8")

# --- Projet 4 : données pour régression ---------------------------------------
n_reg <- 100
heures_etude <- round(runif(n_reg, 1, 20), 1)
note <- round(45 + 2.5 * heures_etude + rnorm(n_reg, 0, 8), 1)
note <- pmin(100, pmax(0, note))
etudes <- data.frame(
  etudiant_id = sprintf("E%03d", 1:n_reg),
  heures_etude = heures_etude,
  note_examen = note,
  filiere = sample(c("Sciences", "Lettres", "Économie"), n_reg, replace = TRUE),
  stringsAsFactors = FALSE
)
write.csv(etudes, "data/etudes_notes.csv", row.names = FALSE, fileEncoding = "UTF-8")

# --- Petit fichier Excel simulé via CSV (readxl utilise xlsx) ------------------
# Création d'un fichier xlsx si openxlsx ou writexl est disponible
if (requireNamespace("writexl", quietly = TRUE)) {
  writexl::write_xlsx(list(Ventes = ventes[1:50, ], Resume = aggregate(
    montant ~ region, data = ventes[!is.na(ventes$region), ], FUN = sum
  )), "data/ventes.xlsx")
} else if (requireNamespace("openxlsx", quietly = TRUE)) {
  openxlsx::write.xlsx(ventes[1:50, ], "data/ventes.xlsx")
} else {
  # Fallback : CSV nommé pour les exercices Excel (à convertir manuellement)
  write.csv(ventes[1:50, ], "data/ventes_pour_excel.csv", row.names = FALSE,
            fileEncoding = "UTF-8")
  message("writexl/openxlsx absent : ventes.xlsx non créé (CSV de secours fourni).")
}

# --- Clients (pour jointures) -------------------------------------------------
clients <- data.frame(
  client_id = sprintf("C%03d", 1:30),
  nom = paste0("Client_", 1:30),
  segment = sample(c("Particulier", "Entreprise", "Association"), 30, replace = TRUE),
  stringsAsFactors = FALSE
)
write.csv(clients, "data/clients.csv", row.names = FALSE, fileEncoding = "UTF-8")

commandes <- data.frame(
  commande_id = sprintf("CMD%03d", 1:80),
  client_id = sample(clients$client_id, 80, replace = TRUE),
  montant = round(runif(80, 20, 500), 2),
  date = sample(dates, 80, replace = TRUE),
  stringsAsFactors = FALSE
)
write.csv(commandes, "data/commandes.csv", row.names = FALSE, fileEncoding = "UTF-8")

message("Jeux de données générés dans data/")
message(paste(list.files("data", recursive = TRUE), collapse = "\n"))
