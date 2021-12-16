library(shiny)
library(shinythemes)
library(datasets)

# Quellen

# inspiriert durch: https://shiny.rstudio.com/gallery/telephones-by-region.html

WP <- WorldPhones


# Einlesen, Invertierung, neubenennung der Zeilen/ Spalten, Entfernen der Spalte"Berlin"

heute <- format(Sys.time(), "%d.%m.%Y")


CSV <- read.csv2("https://www.berlin.de/lageso/_assets/gesundheit/publikationen/corona/bezirkstabelle.csv")
df <- data.frame(CSV)
df <- t(df)

# Neue tabelle mit einer Zeile für die heutigen Fallzahlen

heutigeFallzahl <- data.frame(df[1,], df[2,])
heutigeFallzahl <-t(heutigeFallzahl)
colnames(heutigeFallzahl) <- heutigeFallzahl[1,]
heutigeFallzahl <- heutigeFallzahl[,-13]

columns <- heutigeFallzahl[1,]

heutigeFallzahl <- heutigeFallzahl[-1,]
heutigeFallzahl <-t(heutigeFallzahl)
heutigeFallzahl <- cbind( heute, heutigeFallzahl)
datumFallzahl <- heutigeFallzahl[,1]
heutigeFallzahl <- data.frame(heutigeFallzahl[,-1])

vektor <- as.vector(as.numeric(heutigeFallzahl$heutigeFallzahl....1.))
heutigeFallzahl <- data.frame(heutigeFallzahl, vektor)
heutigeFallzahl <- heutigeFallzahl[,-1]

heutigeFallzahl <-data.frame(t(heutigeFallzahl))
colnames(heutigeFallzahl) <- as.character(columns)
rownames(heutigeFallzahl) <- datumFallzahl

heutigeFallzahlvektor <- c(as.numeric(heutigeFallzahl[1,]))
heutigeFallzahlvektor

 # Tabelle mit den Fallzahlen für alle beobachteten Tage

Fallzahlen <- rbind(heutigeFallzahl, heutigeFallzahlvektor)

Fallzahlen





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