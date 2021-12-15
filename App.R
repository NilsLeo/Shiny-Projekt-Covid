library(shiny)
library(shinythemes)
library(datasets)

# Quelle https://github.com/robert-koch-institut

Verteilung <- read.csv2("C:/Users/Nils/My Drive/Documents/HTW/WiSe 2021 22/Statistik/Shiny/RKI Datensätze/bezirkstabelle.csv")
VerteilungohneBezirke <- data.frame(Verteilung$Fallzahl, Verteilung$Differenz, Verteilung$Inzidenz, Verteilung$Genesen)
ui <- fluidPage(
  navbarPage(
    # theme = "cerulean"
    "Die SARS-CoV-2-Pandemie",
    tabPanel("Fallzahlen",
             sidebarPanel(
               selectInput("region", "Region:", 
                           choices=colnames(WorldPhones)),
             )
             
    ), # sidebarPanel
    mainPanel(
      plotOutput("phonePlot")  
    )
  )
)


server <- function(input, output) {
  output$phonePlot <- renderPlot({
    
    # Render a barplot
    barplot(WorldPhones[,input$region]*1000, 
            main=input$region,
            ylab="Number of Telephones",
            xlab="Year")
  })
}
shinyApp(ui = ui, server = server)