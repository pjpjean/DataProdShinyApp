library(shiny)
source("boundary.R")

shinyServer(function(input, output, session) {

  output$plot1 <- renderPlot({
    #x.vars <- combn(names(iris[-5]), 2)[as.numeric(input$selVar)]
    x.vars <- unlist(strsplit(input$selVar, " x "))
    models <- c(multinom="Penalized Multinomial Regression",
                nnet="Neural Network",
                rf="Random Forest",
                nb="Naive Bayes",
                lda="Linear Discriminant Analysis",
                C5.0="C5.0",
                knn="k-Nearest Neighbors")
    
    if (is.null(input$optModel))
      plotDecisionBoundary(x.vars)
    else
      plotDecisionBoundary(x.vars, models[input$optModel])
    
#     par(mar = c(5.1, 4.1, 0, 1))
#     plot(selectedData(),
#          col = clusters()$cluster,
#          pch = 20, cex = 3)
#     points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
  })
  
})
