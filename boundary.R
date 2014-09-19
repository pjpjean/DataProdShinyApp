library(caret)
library(e1071)
library(nnet)
library(randomForest)
library(klaR)
library(MASS)
library(C50)

dbv.colors <- function(n) {
  ramp <- colorRamp(c("#66C2A5", "#FC8D62", "#8DA0CB"))
  if (n == 1)
    rgb(ramp(0.5), max=255)
  else {
    col <- seq(0, n-1)/(n-1)
    rgb(ramp(col), max=255)  
  }
}

plotDecisionBoundary <- function(x.vars, model=NULL, smooth=FALSE) {
  
  if (!all(x.vars %in% names(iris[-5])))
    stop("variables must be from iris dataset.")
  
  axes.lim <- apply(iris[-5], 2, range)
  axes.lim[1, ] <- floor(axes.lim[1, ] - 0.1)
  axes.lim[2, ] <- ceiling(axes.lim[2, ] + 0.1)
  x.lim <- axes.lim[, x.vars]
  
  opar <- par(mar = c(5.1, 4.1, 4.1, 1))
  on.exit(par(opar))

  if (is.null(model)) {

    plot(iris[x.vars], type="p", pch=20, cex=3,
         col = c("#1b9e77", "#d95f02", "#7570b3")[iris$Species],
         xlim = x.lim[,1], ylim = x.lim[,2],
         main = "Iris dataset",
         xlab = x.vars[1], ylab = x.vars[2])

  } else {
    grid.width <- 200    
    x.vals <- apply(x.lim, 2, function(x) seq(x[1], x[2], length.out=grid.width))
    
    db.data <- expand.grid(x.vals[,1], x.vals[,2])
    names(db.data) <- colnames(x.vals)
    
    if (names(model) == "rf") {
      trControl <- trainControl(method="oob")
      tuneLength <- 1
    } else {
      trControl <- trainControl(method="cv", number = 3)
      if (names(model) == "nb") {
        tuneLength <- 3
      } else {
        tuneLength <- 5      
      } 
    }
    
    trModel <- train(Species ~ ., 
                     data = iris[c(x.vars, "Species")], 
                     method = names(model),
                     trControl = trControl,
                     tuneLength = tuneLength)
    
    y.pred <- matrix(as.numeric(predict(trModel, newdata=db.data)), nrow=nrow(x.vals))      
    if (smooth)
      y.pred <- maverage(y.pred, 2)
    
    image(x.vals[,1], x.vals[,2],  y.pred, col = dbv.colors(12),
          main = model,
          xlab = x.vars[1], ylab = x.vars[2])
    
    points(iris[x.vars], pch=21, cex=2, col="black", 
           bg=c("#1b9e77", "#d95f02", "#7570b3")[iris$Species])
    box()    
  }

  legend("topright",
         legend=levels(iris$Species), cex=1, y.intersp=0.8, bty="n", 
         pch=21, pt.cex=1.2, col="black", pt.bg=c("#1b9e77", "#d95f02", "#7570b3"))
}