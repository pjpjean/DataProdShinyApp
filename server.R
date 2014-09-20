library(shiny)
source("boundary.R")

shinyServer(function(input, output, session) {

  output$plot1 <- renderPlot({
    x.vars <- unlist(strsplit(input$selVar, " x "))
    models <- c(multinom="Penalized Multinomial Regression",
                lda="Linear Discriminant Analysis",
                nnet="Neural Network",
                C5.0="C5.0",
                rf="Random Forest",
                knn="k-Nearest Neighbors",
                svmRadialCost="Support Vector Machine (RBF Kernel)")
    
    if (is.null(input$optModel))
      plotDecisionBoundary(x.vars)
    else
      plotDecisionBoundary(x.vars, models[input$optModel])
    
  })
  
})
