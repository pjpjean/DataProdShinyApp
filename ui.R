library(shiny)
library(ggplot2)

varPairs <- apply(combn(names(iris[-5]), 2), 2, collapse=" x ", paste)

models <- c(multinom="Penalized Multinomial Regression",
            nnet="Neural Network",
            rf="Random Forest",
            nb="Naive Bayes",
            lda="Linear Discriminant Analysis",
            C5.0="C5.0",
            knn="k-Nearest Neighbors")

m.choices <- as.list(names(models))
names(m.choices) <- models

shinyUI(pageWithSidebar(
  headerPanel('Visualizing Classifier Decision Boundaries'),
  sidebarPanel(
    selectInput('selVar', h4('Variables'), varPairs),
    hr(),
    radioButtons("optModel", label = h4("Classifier"),
                 choices = m.choices, 
                 selected = 1)    
  ),
  mainPanel(
    plotOutput('plot1')
  )
))