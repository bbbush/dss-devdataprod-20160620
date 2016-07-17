library(shiny)

shinyUI(fluidPage(
  titlePanel("Regression on performance counter data"),
  sidebarLayout(
    sidebarPanel(
      numericInput("acc", "(optional) Choose an id", NA),
      checkboxInput("exclude", "exclude this id"),
      uiOutput("rangeControl"),
      p("When people trade stocks, an account is used to bookkeeping",
        "all the securities held. A software can go through all the security",
        "holdings to find a composition for any date. Usually an account is",
        "recursively defined, a \"layer 1\" account can hold a \"layer 2\" account,",
        "because an account is a nice abstraction of any security mixtures."),
      p("The recursive structure has posed some difficulty in calculating",
        "an account. To find the bottleneck in a program, a performance counter",
        "is used to record relevant timing values.",
        "The total_time field is the one to minimize. The dep field is part of the time.",
        "The MERGE field, too, is part of the time."),
      p("When total_time is large, it is more likely caused by dep.",
        "But it could also because of the recursive structure",
        "(i.e. time spent on next layer of things.)"),
      p("This app shows how good a linear model could fit. When",
        "total_time is not as large (less than 5s), the model fit is rather bad.",
        "But it is as much concern as the slow ones."),
      p("For the same id, total_time varied a lot, so there is missing dep,",
        "maybe during some hours of a day there is a long queue."),
      p(a("Source code", href="https://github.com/bbbush/dss-devdataprod-20160620"))
    ),
    mainPanel(
      fluidRow(
        textOutput("len"),
        p(),
        tableOutput('tb'),
        verbatimTextOutput('lm'))
    )
  )
))
