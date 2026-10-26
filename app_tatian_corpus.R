library(shiny)
library(DT)
library(stringr)

# User Interface
ui <- fluidPage(
  titlePanel("Tatian Corpus Query"),
  sidebarLayout(
    sidebarPanel(
      textInput("search_term", "Search word:", ""),
      selectInput("language", "Select language:", 
                  choices = c("Latin" = "Latin Text", "Old High German" = "Old High German Text")),
      checkboxInput("case_sensitive", "Case sensitive", FALSE),
      checkboxInput("use_regex", "Use regular expressions", FALSE),
      selectInput("search_type", "Search type:",
                  choices = c("Contains" = "contains",
                              "Starts with" = "starts_with",
                              "Ends with" = "ends_with")),
      actionButton("search", "Search", class = "btn-primary"),
      br(), br(),
      downloadButton("download_csv", "Download Results (CSV)")
    ),
    mainPanel(
      DTOutput("results"),
      textOutput("result_count")
    )
  )
)

# Server
server <- function(input, output, session) {
  
  # Load CSV file (tagged release v1.0.0)
  corpus <- reactive({
    url <- "https://raw.githubusercontent.com/javiermunoz-acebes/Tatian/v1.0.0/Tatian_CorPar.csv"
    data <- read.csv(url, stringsAsFactors = FALSE, sep = ";", header = TRUE, fill = TRUE, check.names = FALSE)
    return(data)
  })
  
  # Filter results
  search_results <- eventReactive(input$search, {
    req(input$search_term)  # Ensure the search term is not empty
    df <- corpus()  # Call the loaded corpus
    term <- input$search_term
    lang <- input$language
    
    # Without regular expressions, special characters are taken literally
    if (!input$use_regex) {
      term <- str_replace_all(term, "([.|()\\\\^{}+$*?\\[\\]])", "\\\\\\1")
    }
    
    # Word-level matching: \\b marks a word boundary
    pattern <- switch(input$search_type,
                      "contains"    = term,
                      "starts_with" = paste0("\\b(?:", term, ")"),
                      "ends_with"   = paste0("(?:", term, ")\\b"))
    
    # Apply search
    hits <- str_detect(df[[lang]], regex(pattern, ignore_case = !input$case_sensitive))
    results <- df[hits, ]
    return(results)
  })
  
  # Display results
  output$results <- renderDT({
    req(search_results())  # Wait for results to be generated
    datatable(search_results(), 
              options = list(pageLength = 10, 
                             searchHighlight = TRUE),
              rownames = FALSE,
              filter = 'top')
  })
  
  # Display result count
  output$result_count <- renderText({
    req(search_results())
    paste("Number of results:", nrow(search_results()))
  })
  
  # Download handler
  output$download_csv <- downloadHandler(
    filename = function() {
      paste("search_results_", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(search_results(), file, row.names = FALSE)
    }
  )
}

# Run the application
shinyApp(ui, server)
