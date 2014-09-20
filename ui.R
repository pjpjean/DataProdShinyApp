library(shiny)
library(ggplot2)

varPairs <- apply(combn(names(iris[-5]), 2), 2, collapse=" x ", paste)

models <- c(multinom="Penalized Multinomial Regression",
            lda="Linear Discriminant Analysis",
            nnet="Neural Network",
            C5.0="C5.0",
            rf="Random Forest",
            knn="k-Nearest Neighbors",
            svmRadialCost="Support Vector Machine (RBF Kernel)")

m.choices <- as.list(names(models))
names(m.choices) <- models

shinyUI(fluidPage(
  titlePanel('Visualizing decision boundaries'),
  fluidRow(
    p("Each classification algorithm generates different decision making rules.", 
      "These rules can be visualized in the form of a decision boundary or decision surface.",
      "In this application, you can visualize the decision boundaries for different classification ", 
      "algorithms on the ", code("iris"), "dataset. It's easy! ", 
      strong("Just select the pair of variables you want to plot and one classification algorithm in the sidebar below"), 
      ".")
  ),
  tabsetPanel(
    tabPanel("Viewer",  
             sidebarLayout(
               sidebarPanel(
                 selectInput('selVar', h4('Select variables to plot'), varPairs),
                 br(),
                 radioButtons("optModel", label = h4("Pick your classifier"),
                              choices = m.choices, 
                              selected = 1),
                 hr(),
                 p("Get the source code on ", 
                   a(href="https://github.com/pjpjean/DataProdShinyApp", "Github"))
               ),
               mainPanel(
                 plotOutput('plot1')
               )
             )
    ),
    tabPanel("More information", 
             h5("How to use it"),
             p("Use the sidebar panel list box to select the variables you want to plot.",
               "Then, choose one of the available classification algorithms below and wait a few seconds. ",
               "That's it!"),
             br(),
             h5("How it works"),
             p("This application uses the", strong("caret"), "package to train a classification algorithm
               on a subset of the ", code("iris"), " dataset, with the two selected
               variables and ", code("Species"), "as the class variable. The
               training is intended to be fast, so just one step of a 3-fold cross-validation is used."),
             p("After that, ", code("expand.grid"), " is used to create a grid of
               points spanning the entire space within the plot limits.", "Then, ", 
               code("image"), " is used to create a bitmap plot, each pixel color based on the
               predicted class for that point and finally, the ", code("iris"),
               " dataset points are laid over the plot."),
             p("Notice that models with random parameters might generate different boundaries in each run."),
             br(),
             h5("Dataset and models"),
             p("The ", code("iris"), " dataset is perhaps the best known database 
               to be found in the pattern recognition literature. It gives the measurements in 
               centimeters of the variables sepal length and width and petal length and width, 
               respectively, for 50 flowers from each of 3 species of iris. The species are ",
               em("Iris setosa"), ", ", em("versicolor"), " and ", em("virginica"), "."),
             p("These are the available algorithms with their", code("caret"), "identifiers."),
             tagList(tags$ul(
               tags$li(code("multinom")," - Penalized Multinomial Regression"),
               tags$li(code("lda")," - Linear Discriminant Analysis"),
               tags$li(code("nnet")," - Neural Network"),
               tags$li(code("C5.0")," - C5.0"),
               tags$li(code("rf")," - Random Forest"),
               tags$li(code("knn")," - k-Nearest Neighbors"),
               tags$li(code("svmRadialCost")," - Support Vector Machine (RBF Kernel)")
             )),
             br(),
             h5("References"),
             p("SHINY by RStudio. ", strong("The 'Iris k-means clustering' example."),
               a(href="http://shiny.rstudio.com/gallery/kmeans-example.html",
                 "http://shiny.rstudio.com/gallery/kmeans-example.html")),
             p("KUHN, M.", strong("Building predictive models in R using the caret package."), 
               "Journal of Statistical Software Vol. 28, Issue 5, 1-26. Nov 2008.", 
               a(href="http://www.jstatsoft.org/v28/i05", "http://www.jstatsoft.org/v28/i05")),
             p("MATLAB. ", strong("Visualize Decision Surfaces for Different Classifiers."),
               a(href="http://www.mathworks.com/machine-learning/examples.html?file=/products/demos/machine-learning/decision_surface/decision_surface.html",
                 "http://www.mathworks.com/machine-learning/examples.html?file=/products/demos/machine-learning/decision_surface/decision_surface.html")),
             p("UCI Machine Learning repository. ", strong("Iris Data Set."),
               a(href="https://archive.ics.uci.edu/ml/datasets/Iris",
                 "https://archive.ics.uci.edu/ml/datasets/Iris")),
             p("© 2014, ", 
               a(href="https://github.com/pjpjean", "Paulo Jean"))             
    )
  )
))