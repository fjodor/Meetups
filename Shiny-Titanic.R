library(shiny)
library(titanic)
library(tidyverse)
library(rpart)
library(rpart.plot)

titanic <- titanic_train %>% 
  # select(Survived, Pclass, Sex, Age) %>% 
  select(-PassengerId, -Name) %>% 
  rename(Alter = Age, Passagierklasse = Pclass, Geschlecht = Sex) %>% 
  mutate(Survived = factor(Survived),
         Survived = fct_recode(Survived, Ertrunken = "0", Gerettet = "1"),
         Geschlecht = fct_recode(Geschlecht, W = "female", M = "male"),
         Passagierklasse = factor(Passagierklasse),
         Passagierklasse = fct_recode(Passagierklasse, `1. Klasse` = "1", `2. Klasse` = "2", `3. Klasse` = "3"),
         Alter = round(Alter))

ui <- fluidPage(
    
    titlePanel("Data Mining mit R: Titanic"),
    
    sidebarLayout(
        sidebarPanel(
            checkboxInput(inputId = "surrogate", label = "Fehlwerte: Ersatzvariable verwenden"),
            radioButtons(inputId = "firstsplit", label = "Erste Verzweigung:",
                         choices = c("Algorithmus entscheidet", "Alter", "Passagierklasse"))
            ),

        mainPanel(
            plotOutput(outputId = "titanicPlot", width = "100%", height = "750px")
        )
    )
)

server <- function(input, output) {
    
    output$titanicPlot <- renderPlot({
        
        # if (input$firstsplit == "Algorithmus entscheidet")
        #   cost <- c(rep(1, 3), rep(100000, 6))
        # else
        #   if (input$firstsplit == "Alter")
        #     cost <- c(100, 100, 1, rep(100000, 6))
        # else
        #   if (input$firstsplit == "Passagierklasse")
        #     cost <- c(1, 100, 100, rep(100000, 6))

          cost <- switch(input$firstsplit,
                         `Algorithmus entscheidet` = c(rep(1, 3), rep(10000, 6)),
                         `Alter` = c(100, 100, 1, rep(10000, 6)),
                         `Passagierklasse` = c(1, 100, 100, rep(10000, 6)))
          
        tree <- rpart(Survived ~ ., data = titanic, method = "class",
                      usesurrogate = ifelse(isTRUE(input$surrogate), 1, 0),
                      cp = 0.01, maxdepth = 3,
                      cost = cost)
        
        prp(tree, main = "Titanic: Wurden Frauen und Kinder zuerst gerettet?",
            type = 4,                                     # type: 1 = label all nodes
            extra = 1,                                    # extra: 1 = number of obs per node; +100: percentage
            prefix = "Ertrunken / Gerettet\nMehrheit: ",
            xsep = " / ",
            faclen = 0,                                     # do not abbreviate factor levels
            nn = FALSE,                                     # display the node numbers
            ni = TRUE,                                      # display node indices
            yesno = 2,                                      # write yes / no at every split
            roundint = TRUE,
            # ycompress = FALSE,
            yes.text = "ja",
            no.text = "nein",
            facsep = ", ",
            varlen = 0,                                     # don't abbreviate variable names
            shadow.col = "gray",
            split.prefix = " ",
            split.suffix = " ",
            # col = cols, border.col = cols,                # use for categorical outcomes, predefine colours
            box.palette = "BuGn",
            # box.palette = "auto",
            split.box.col = "lightgray",
            split.border.col = "darkgray",
            split.round = .5,
            cex = 1.1)                                        # text size
        
    })
}

shinyApp(ui = ui, server = server)
