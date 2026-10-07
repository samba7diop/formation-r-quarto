# Application Shiny pédagogique — Analyse de données avec R
# Lancement : shiny::runApp("shiny-app") depuis formation-r/

library(shiny)
library(ggplot2)
library(dplyr)
library(readr)

# Chemins données (relatifs à shiny-app/ ou au projet)
trouver_data <- function(fichier) {
  candidats <- c(
    file.path("..", "data", fichier),
    file.path("data", fichier),
    file.path("formation-r", "data", fichier)
  )
  for (p in candidats) {
    if (file.exists(p)) return(p)
  }
  stop("Fichier introuvable : ", fichier)
}

ventes <- read_csv(trouver_data("ventes.csv"), show_col_types = FALSE)
demo <- read_csv(trouver_data("demographie.csv"), show_col_types = FALSE) |>
  filter(age <= 100, revenu_mensuel < 20000)
meteo <- read_csv(trouver_data("meteo.csv"), show_col_types = FALSE) |>
  mutate(
    date = as.Date(date),
    mois = format(date, "%Y-%m")
  )

ui <- fluidPage(
  titlePanel("Explorateur de données — Formation R"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        "jeu", "Jeu de données",
        choices = c(
          "Ventes" = "ventes",
          "Démographie" = "demo",
          "Météo" = "meteo"
        )
      ),
      uiOutput("filtre_ui"),
      sliderInput("bins", "Nombre de classes (histogramme)", min = 5, max = 40, value = 20),
      hr(),
      helpText("Application pédagogique du livre « Analyse de données avec R et Quarto ».")
    ),
    mainPanel(
      h3(textOutput("titre")),
      verbatimTextOutput("resume"),
      plotOutput("histo", height = "320px"),
      h4("Aperçu des données filtrées"),
      tableOutput("apercu")
    )
  )
)

server <- function(input, output, session) {

  output$filtre_ui <- renderUI({
    if (input$jeu == "ventes") {
      selectInput(
        "filtre", "Région",
        choices = c("Toutes", sort(unique(na.omit(ventes$region))))
      )
    } else if (input$jeu == "demo") {
      selectInput(
        "filtre", "Ville",
        choices = c("Toutes", sort(unique(demo$ville)))
      )
    } else {
      mois_dispo <- sort(unique(meteo$mois))
      selectInput(
        "filtre", "Mois",
        choices = c("Tous", mois_dispo)
      )
    }
  })

  donnees <- reactive({
    req(input$jeu)
    if (input$jeu == "ventes") {
      df <- ventes
      if (!is.null(input$filtre) && input$filtre != "Toutes") {
        df <- df |> filter(region == input$filtre)
      }
      list(
        data = df,
        var = "montant",
        titre = "Distribution des montants de vente"
      )
    } else if (input$jeu == "demo") {
      df <- demo
      if (!is.null(input$filtre) && input$filtre != "Toutes") {
        df <- df |> filter(ville == input$filtre)
      }
      list(
        data = df,
        var = "revenu_mensuel",
        titre = "Distribution des revenus mensuels"
      )
    } else {
      df <- meteo
      if (!is.null(input$filtre) && input$filtre != "Tous") {
        df <- df |> filter(mois == input$filtre)
      }
      list(
        data = df,
        var = "temperature_c",
        titre = "Distribution des températures"
      )
    }
  })

  output$titre <- renderText({
    donnees()$titre
  })

  output$resume <- renderPrint({
    d <- donnees()$data
    v <- donnees()$var
    cat("Nombre de lignes :", nrow(d), "\n")
    cat("Variable analysée :", v, "\n")
    print(summary(d[[v]]))
  })

  output$histo <- renderPlot({
    d <- donnees()$data
    v <- donnees()$var
    validate(need(nrow(d) > 0, "Aucune donnée pour ce filtre."))
    ggplot(d, aes(.data[[v]])) +
      geom_histogram(bins = input$bins, fill = "#1a5276", color = "white") +
      labs(x = v, y = "Effectif") +
      theme_minimal(base_size = 13)
  })

  output$apercu <- renderTable({
    head(donnees()$data, 10)
  })
}

shinyApp(ui = ui, server = server)
