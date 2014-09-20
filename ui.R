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
                 hr(),
                 radioButtons("optModel", label = h4("Pick your classifier"),
                              choices = m.choices, 
                              selected = 1),
                 br()                 
               ),
               mainPanel(
                 plotOutput('plot1')
               )
             )
    ),
    tabPanel("More information", 
             h5("How to use it"),
             p("Use the sidebar panel list box to select the variables you want to plot.",
               "Then, choose one of the available classification algorithms below and wait a few seconds."),
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
             br(),
             h5("Dataset and models"),
             p("The ", code("iris"), " dataset is perhaps the best known database 
               to be found in the pattern recognition literature. It gives the measurements in 
               centimeters of the variables sepal length and width and petal length and width, 
               respectively, for 50 flowers from each of 3 species of iris. The species are ",
               em("Iris setosa"), ", ", em("versicolor"), " and ", em("virginica"), "."),
             HTML("<table> <thead> <tr> <th align='left'> caret method </th> <th align='left'>", 
                  " name </th> </tr> </thead><tbody>", 
                  "<tr> <td align='left'> multinom </td> <td align='left'> Penalized Multinomial Regression </td> </tr>", 
                  "<tr> <td align='left'> nnet </td> <td align='left'> Neural Network </td> </tr>", 
                  "<tr> <td align='left'> rf </td> <td align='left'> Random Forest </td> </tr>", 
                  "<tr> <td align='left'> nb </td> <td align='left'> Naive Bayes </td> </tr>", 
                  "<tr> <td align='left'> lda </td> <td align='left'> Linear Discriminant Analysis </td> </tr>", 
                  "<tr> <td align='left'> C5.0 </td> <td align='left'> C5.0 </td> </tr>", 
                  "<tr> <td align='left'> knn </td> <td align='left'> k-Nearest Neighbors </td> </tr>", 
                  "</tbody></table>"),
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
                 "https://archive.ics.uci.edu/ml/datasets/Iris"))
    )
  )
))