# Required libraries
library(caret)
library(plyr)
library(e1071)
library(nnet)
library(randomForest)
library(MASS)
library(C50)
library(kernlab)

# In the future, I plan to code some sort of antialiasing.
# So, instead of using just three colors, it's better to
# build a palette based on these colors.
dbv.colors <- function(n) {
  ramp <- colorRamp(c("#66C2A5", "#FC8D62", "#8DA0CB"))
  if (n == 1)
    rgb(ramp(0.5), max=255)
  else {
    col <- seq(0, n-1)/(n-1)
    rgb(ramp(col), max=255)  
  }
}

# Draw decision boundary plot
plotDecisionBoundary <- function(x.vars, model=NULL, ...) {
  
  # check parameters
  if (!all(x.vars %in% names(iris[-5])))
    stop("variables must be from iris dataset.")
  
  # compute axes limits  
  axes.lim <- apply(iris[-5], 2, range)
  axes.lim[1, ] <- floor(axes.lim[1, ] - 0.1)
  axes.lim[2, ] <- ceiling(axes.lim[2, ] + 0.1)
  x.lim <- axes.lim[, x.vars]
  
  # graphical parameters
  opar <- par(mar = c(5.1, 4.1, 4.1, 1))
  on.exit(par(opar))
  
  if (is.null(model)) {
    # if model is not specified, plot points only
    plot(iris[x.vars], type="p", pch=20, cex=3,
         col = c("#1b9e77", "#d95f02", "#7570b3")[iris$Species],
         xlim = x.lim[,1], ylim = x.lim[,2],
         main = "Iris dataset",
         xlab = x.vars[1], ylab = x.vars[2])
    
  } else {
    # set parameters for specific models
    if (names(model) == "rf") {
      trControl <- trainControl(method="oob")
      tuneLength <- 1
    } else {
      trControl <- trainControl(method="cv", number = 3)
      tuneLength <- 5      
    }
    
    # train a model using caret package    
    trModel <- train(Species ~ ., 
                     data = iris[c(x.vars, "Species")], 
                     method = names(model),
                     trControl = trControl,
                     tuneLength = tuneLength,
                     ...)
    
    # create a grid of points where the model will be evaluated
    grid.width <- 200    
    x.vals <- apply(x.lim, 2, function(x) seq(x[1], x[2], length.out=grid.width))    
    db.data <- expand.grid(x.vals[,1], x.vals[,2])
    names(db.data) <- colnames(x.vals)

    # get predictions on every point of the grid 
    y.pred <- matrix(as.numeric(predict(trModel, newdata=db.data)), nrow=nrow(x.vals))      
    
    # plot decision boundaries
    image(x.vals[,1], x.vals[,2],  y.pred, col = dbv.colors(11),
          main = model,
          xlab = x.vars[1], ylab = x.vars[2])
    
    # lay iris data points over the plot  
    points(iris[x.vars], pch=21, cex=2, col="black", 
           bg=c("#1b9e77", "#d95f02", "#7570b3")[iris$Species])
    
    # draw surrounding box
    box()    
  }
  
  # draw legend box
  legend("topright",
         legend=levels(iris$Species), cex=1, y.intersp=0.8, bg="#ffffff77", 
         pch=21, pt.cex=1.2, col="black", pt.bg=c("#1b9e77", "#d95f02", "#7570b3"))
}