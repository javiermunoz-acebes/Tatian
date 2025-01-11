library(shiny)
library(readr)
library(DT)

# Interfaz de usuario
ui <- fluidPage(
  titlePanel("Consulta del Corpus Tatian"),
  sidebarLayout(
    sidebarPanel(
      textInput("search_term", "Buscar palabra:", ""),
      selectInput("language", "Seleccionar idioma:", 
                  choices = c("Latín" = "Texto_Latino", "Alto alemán antiguo" = "Texto_alto_aleman_antiguo")),
      actionButton("search", "Buscar")
    ),
    mainPanel(
      DTOutput("results")
    )
  )
)

# Servidor
server <- function(input, output, session) {
  
  # Cargar el archivo CSV
  corpus <- reactive({
    url <- "https://raw.githubusercontent.com/javiermunoz-acebes/Tatian/main/Tatian_CorPar.csv"
    data <- read.csv(url, stringsAsFactors = FALSE, sep = ";", header = TRUE, fill = TRUE, check.names = FALSE)
    return(data)
  })
  
  # Filtrar resultados
  search_results <- eventReactive(input$search, {
    req(input$search_term)  # Asegúrate de que el término no esté vacío
    df <- corpus()  # Llama al corpus cargado
    term <- tolower(input$search_term)  # Convierte el término de búsqueda a minúsculas
    lang <- input$language  # El idioma seleccionado
    
    # Filtra los resultados en el idioma seleccionado
    results <- df[grepl(term, tolower(df[[lang]]), fixed = TRUE), ]
    return(results)
  })
  
  # Mostrar los resultados
  output$results <- renderDT({
    req(search_results())  # Esperar a que los resultados sean generados
    datatable(search_results(), options = list(pageLength = 10), rownames = FALSE)
  })
}

# Ejecutar la aplicación
shinyApp(ui, server)
