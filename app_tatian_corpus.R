library(shiny)
library(readr)
library(DT)
library(stringr)

# Publish the revised CSV under this name in the GitHub repository.
corpus_url <- "https://raw.githubusercontent.com/javiermunoz-acebes/Tatian/main/Tatian_CorPar.csv"
expected_columns <- c("Chapter", "Latin Text", "Old High German Text",
                      "Biblical References", "Witness", "Scribe", "Codex Pages")

ui <- fluidPage(
  titlePanel("Old High German Tatian Parallel Corpus"),
  p("Sievers (1892): base text; Masser (1994): scribal attribution and codex pagination."),
  sidebarLayout(
    sidebarPanel(
      textInput("search_term", "Search text (optional):", ""),
      selectInput("language", "Select language:",
                  choices = c("Latin" = "Latin Text", "Old High German" = "Old High German Text")),
      checkboxInput("case_sensitive", "Case sensitive", FALSE),
      checkboxInput("use_regex", "Use regular expressions", FALSE),
      selectInput("search_type", "Search type:", choices = c("Contains" = "contains", "Starts with" = "starts_with", "Ends with" = "ends_with")),
      tags$hr(),
      selectInput("witness", "Manuscript witness:", choices = c("All witnesses" = "all", "Cod. Sang. 56", "Paris, BnF, lat. 7641")),
      selectInput("scribe", "Scribe:", choices = c("All scribes / unassigned" = "all", "Alpha (α)" = "α", "Beta (β)" = "β", "Gamma (γ)" = "γ", "Delta (δ)" = "δ", "Epsilon (ε)" = "ε", "Zeta (ζ)" = "ζ", "Mixed sections only" = "mixed", "Not assigned" = "unassigned")),
      checkboxInput("include_mixed", "Include mixed-hand sections when selecting a scribe", TRUE),
      numericInput("codex_page", "Codex page (optional):", value = NA, min = 25, max = 342, step = 1),
      helpText("Page filtering includes ranges containing the selected page. Paris fragments have no St. Gallen page or scribe attribution."),
      actionButton("search", "Search", class = "btn-primary"),
      br(), br(),
      downloadButton("download_csv", "Download Results (CSV)")
    ),
    mainPanel(
      textOutput("result_count"),
      DTOutput("results"),
      helpText("Mixed-hand sections are returned as complete aligned units; individual words are not attributed to a specific hand. Scribal attribution identifies copying hands, not necessarily translators or correctors."),
      helpText("The Latin column follows Sievers’ edition, not a direct transcription of the codex. Later corrections are not separately annotated.")
    )
  )
)

server <- function(input, output, session) {
  corpus <- reactive({
    df <- tryCatch(
      read_delim(corpus_url, delim = ";", locale = locale(encoding = "UTF-8"),
                 col_types = cols(.default = col_character()), na = character(),
                 trim_ws = FALSE, show_col_types = FALSE, name_repair = "minimal"),
      error = function(e) NULL)
    validate(need(!is.null(df), "Unable to load the corpus from GitHub."))
    validate(need(identical(names(df), expected_columns),
                  "The GitHub CSV must contain the seven columns of the revised corpus."))
    validate(need(nrow(problems(df)) == 0, "The CSV contains parsing errors."))
    df
  })

  # Run on initial load and whenever the Search button is pressed.
  search_results <- eventReactive(input$search, {
    df <- corpus()
    keep <- rep(TRUE, nrow(df))
    term <- input$search_term
    if (nzchar(term)) {
      # Literal matching remains literal even when ignoring case.
      pattern <- if (input$use_regex) regex(term, ignore_case = !input$case_sensitive) else fixed(term, ignore_case = !input$case_sensitive)
      # Anchor the entire regular expression, including alternatives.
      if (input$use_regex) {
        expr <- switch(input$search_type, contains = term,
                       starts_with = paste0("\\A(?:", term, ")"),
                       ends_with = paste0("(?:", term, ")\\z"))
        pattern <- regex(expr, ignore_case = !input$case_sensitive)
        matches <- tryCatch(str_detect(df[[input$language]], pattern), error = function(e) NULL)
      } else {
        search_func <- switch(input$search_type, contains = str_detect,
                              starts_with = str_starts, ends_with = str_ends)
        matches <- tryCatch(search_func(df[[input$language]], pattern), error = function(e) NULL)
      }
      validate(need(!is.null(matches), "Invalid search pattern. Please check the regular expression."))
      keep <- keep & !is.na(matches) & matches
    }
    if (input$witness != "all") keep <- keep & df$Witness == input$witness
    hands <- df$Scribe
    hands[is.na(hands)] <- ""
    mixed <- str_detect(hands, fixed("/"))
    if (input$scribe == "mixed") {
      keep <- keep & mixed
    } else if (input$scribe == "unassigned") {
      keep <- keep & hands == ""
    } else if (input$scribe != "all") {
      matches <- if (input$include_mixed) {
        vapply(strsplit(hands, "/", fixed = TRUE), function(x) input$scribe %in% x, logical(1))
      } else hands == input$scribe
      keep <- keep & matches
    }
    page <- input$codex_page
    if (!is.null(page) && !is.na(page)) {
      validate(need(is.finite(page) && page == floor(page) && page >= 25 && page <= 342,
                    "Enter a whole codex page number between 25 and 342."))
      bounds <- str_match(df[["Codex Pages"]], "^\\s*([0-9]+)(?:\\s*[-–]\\s*([0-9]+))?\\s*$")
      first <- as.integer(bounds[, 2]); last <- as.integer(bounds[, 3])
      last[is.na(last)] <- first[is.na(last)]
      keep <- keep & !is.na(first) & page >= first & page <= last
    }
    df[which(keep), , drop = FALSE]
  }, ignoreNULL = FALSE)

  output$results <- renderDT({
    datatable(search_results(), rownames = FALSE, escape = TRUE,
              options = list(pageLength = 10, scrollX = TRUE, ordering = TRUE,
                             order = list(), autoWidth = TRUE))
  })
  output$result_count <- renderText({
    paste("Number of results:", nrow(search_results()))
  })
  output$download_csv <- downloadHandler(
    filename = function() paste0("tatian_results_", Sys.Date(), ".csv"),
    content = function(file) {
      write_delim(search_results(), file, delim = ";", na = "")
    }, contentType = "text/csv"
  )
}

shinyApp(ui, server)
