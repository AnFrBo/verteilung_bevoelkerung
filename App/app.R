#App: Entwicklung der räumlichen Verteilung der Bevölkerung in den deutschen Bundesländern (2000-2016)

#Alle libraries installieren --> install.packages()

#Alle libraries laden
library("rsconnect")
library("shiny")
library("readxl")
library("sf")
library("dplyr")
library("ggplot2")
library("ggthemes")
library("rmapshaper")
library("shinydashboard")
library("wesanderson")
library("reshape2")
library("RColorBrewer")

#Wanderungsdaten:
setwd("/Users/Bisa/Documents/Studium/Masterstudium/3. Semester/VWL Seminar/App")

s_2000 <- read.csv("2000_salden.csv", header = T, sep = ";")
s_2000 <- s_2000[1:17, ]
s_2004 <- read.csv("2004_salden.csv", header = T, sep = ";")
s_2008 <- read.csv("2008_salden.csv", header = T, sep = ";")
s_2012 <- read.csv("2012_salden.csv", header = T, sep = ";")
s_2016 <- read.csv("2016_salden.csv", header = T, sep = ";")

s_all <- rbind(s_2000, s_2004, s_2008, s_2012, s_2016)

colnames(s_all)[3] <- "Baden-Württemberg"
colnames(s_all)[6] <- "Brandenburg"
colnames(s_all)[10] <- "Mecklenburg-Vorpommern"
colnames(s_all)[11] <- "Niedersachsen"
colnames(s_all)[12] <- "Nordrhein-Westfalen"
colnames(s_all)[13] <- "Rheinland-Pfalz"
colnames(s_all)[16] <- "Sachsen-Anhalt"
colnames(s_all)[17] <- "Schleswig-Holstein"
colnames(s_all)[19] <- "Ausland"

s_all$`Mecklenburg-Vorpommern` <- ifelse((s_all$Herkunftsland.Zielland == "Saarland" & s_all$`Mecklenburg-Vorpommern` == 0), 1, s_all$`Mecklenburg-Vorpommern`)
s_all$`Saarland` <- ifelse((s_all$Herkunftsland.Zielland == "Mecklenburg-Vorpommern" & s_all$`Saarland` == 0), 1, s_all$`Saarland`)

s_all[s_all == 0] <- NA

#s_all[,c(3:19)] <- format(s_all[,c(3:19)], big.mark = ".")
rm(s_2000, s_2004, s_2008, s_2012, s_2016)

#Geografische Daten
mymap <- st_read("gadm36_DEU_1.shp", stringsAsFactors = F)

mymap_simplified <- ms_simplify(mymap, keep = 0.10, keep_shapes = T)

map_data <- inner_join(mymap_simplified, s_all, by = c("NAME_1" = "Herkunftsland.Zielland"))
new <- map_data[, c(4,11:29)]

#Daten für Barplot
#Salden ohne Ausland
for(i in 1:nrow(s_all)){
  result <- -1*sum(s_all[i, c(3:18)], na.rm = T)
  s_all[i, 20] <- result
}
colnames(s_all)[20] <- "oA_Insgesamt"

for(i in 1:nrow(s_all)){
  result <- -1*sum(s_all[i, c(19)], na.rm = T)
  s_all[i, 21] <- result
}

colnames(s_all)[21] <- "Salden_Ausland"

#App
ui <- fluidPage(h3("Entwicklung der räumlichen Verteilung der Bevölkerung in den deutschen Bundesländern (2000-2016)"),
  fluidRow(
    column(width = 5, class = "well",
           h4(" "),
           selectInput(inputId = "BL", label = "Wähle ein Zielland (ein Bundesland oder das Ausland)", choices = colnames(s_all[,c(3:19)])), 
           h3(" "),
           #tags$style(HTML(".js-irs-0 .irs-single, .js-irs-0 .irs-bar-edge, .js-irs-0 .irs-bar {background: lightgrey}")),
           #chooseSliderSkin("Flat"),
           sliderInput(inputId = "year", label = "Wähle ein Jahr", value = 2000, animate = animationOptions(interval = 4500, loop = TRUE),
                              min = 2000, max = 2016, step = 4, round = F, sep = ""),
           #checkboxInput(inputId = "AusInland", label = "Analyse mit Ausland"),
           h5(" "),
           h5(strong("Wanderungsalden: In- und Ausland für das ausgewählte Zielland von 2000-2016")),
           plotOutput(outputId = "salden",
                      height = 414)
           ),
    column(width = 7, class = "well",
           h4(strong("Übersicht über die Wanderungsalden (=Zuzüge-Fortzüge) des ausgewählten Ziellandes")),
           h5("Ein positiver Saldo bedeutet, dass das ausgewählte Zielland (ausgewählte Bundesländer = grau) ein Nettogewinner ist; ein negativer Saldo bedeutet, dass es ein 
              Nettoverlierer ist."),
           plotOutput(outputId = "map", height = 561)
           )
    )
)

server <- function(input, output) {
  suppressPackageStartupMessages(library(plotly))
  output$map <- renderPlot({
    new_unique <- new[which(new$Jahr == input$year), ]
    ggplot(new_unique) +
      geom_sf(aes(fill = new_unique[[input$BL]])) +
      #labs(title = paste("Zu- bzw. Abwanderungssaldo von", input$BL, "in", input$year, sep = " ")) +
      scale_fill_gradient2(name = "Absoluter Saldo", low = "red", high = "blue",
                           na.value = "grey", 
                           labels = function(x) format(x, big.mark = ".", scientific = FALSE)) +
      #limits=c(min(new[[input$BL]]), max(new[[input$BL]]))
      theme_map() +
      theme(legend.position = c(0.9, 0.1),
            panel.background = element_rect(fill = "transparent",
                                            colour = "transparent"),
            plot.title = element_text(face = "bold", size = rel(1.7), vjust = 0, hjust=0.5))
  })
  
  output$salden <- renderPlot({
    test <- s_all[which(s_all$Herkunftsland.Zielland == input$BL), c(1:2, 20:21)]
    test1 <- melt(test[2:4], id.vars='Herkunftsland.Zielland')
    test2 <- cbind(test1, test$Jahr)
    colnames(test2)[4] <- "Jahr"
    
    ggplot(data=test2) +
      geom_bar(aes(x= Jahr, y=value, fill=variable, group = variable), stat="identity", position= position_dodge(width = 3.7)) +
      #ggtitle(paste("Salden Insgesamt über den Zeitraum 2000-2016 von", input$BL, sep = " ") +
      guides(fill=guide_legend(title=NULL)) +
      geom_text(aes(x= Jahr, y=value, label= format(value, big.mark = ".", scientific = FALSE), group = variable), position = position_dodge(width = 3.7),
                vjust = -1, size = 3) +
      labs(x="Jahr",y="") +
      scale_x_continuous(breaks=seq(2000,2016,4)) +
      scale_y_continuous(labels = function(x) format(x, big.mark = ".", scientific = FALSE)) +
      #scale_fill_grey() +
      theme(legend.position="bottom") +
      scale_fill_manual(labels = c("Salden Inland", "Salden Ausland"),
                        values=c("darkgrey", "lightgrey")) +
      theme_minimal()
  })
}

shinyApp(ui = ui, server = server)
