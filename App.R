library(shiny)
library(shinythemes)
library(datasets)

# Quellen

# inspiriert durch: https://shiny.rstudio.com/gallery/telephones-by-region.html

WP <- WorldPhones

# Einlesen, Invertierung, neubenennung der Zeilen/ Spalten, Entfernen der Spalte"Berlin"
CSV <- read.csv2("https://www.berlin.de/lageso/_assets/gesundheit/publikationen/corona/bezirkstabelle.csv")
df <- data.frame(CSV)
df <- t(df)
colnames(df) <- df[1,]
df <- df[-1,]
df <- df[,-13]

# Neue tabelle mit einer Zeile für die heutigen Fallzahlen
heutigeFallzahl <- df[1,]
heutigeFallzahl <- t(heutigeFallzahl)
heutigeFallzahl <- cbind( new_col = format(Sys.time(), "%d-%m-%Y"), heutigeFallzahl)
datumFallzahl <- heutigeFallzahl[,1]
rownames(heutigeFallzahl) <- datumFallzahl
heutigeFallzahl <- heutigeFallzahl[,-1]
heutigeFallzahl <-t(heutigeFallzahl)
rownames(heutigeFallzahl) <- datumFallzahl

 # Tabelle mit den Fallzahlen für alle beobachteten Tage
Fallzahlen <- heutigeFallzahl

ui <- # Use a fluid Bootstrap layout
  fluidPage(    
    
    # Give the page a title
    titlePanel("Fallzahlen je Bezirk"),
    
    # Generate a row with a sidebar
    sidebarLayout(      
      
      # Define the sidebar with one input
      sidebarPanel(
        selectInput("bezirk", "Bezirk:", 
                    choices=colnames(Fallzahlen)),
      ),
      
      # Create a spot for the barplot
      mainPanel(
        plotOutput("fallzahlenPlot")  
      )
      
    )
  )


server <- function(input, output) {
  
  # Fill in the spot we created for a plot
  output$fallzahlenPlot <- renderPlot({
    
    # Render a barplot
    barplot(Fallzahlen[,input$bezirk], 
            main=input$bezirk,
            ylab="Fallzahlen",
            xlab="Datum")
  })
}
shinyApp(ui = ui, server = server)