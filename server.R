library(shiny)

dt = read.csv("./sample.csv")
cnt = 10 # min size of selected samples
options(scipen = 2) # scipen, http://stackoverflow.com/questions/25946047/how-to-prevent-scientific-notation-in-r

shinyServer(
  function(input, output){
    output$rangeControl = renderUI({
      sliderInput("range",
                  "Select samples",
                  min = floor(min(dt$total_time)/100)*100,
                  max= ceiling(max(dt$total_time)/100)*100,
                  value=c(5000, 10000),
                  step=100)
    })
    sdt = reactive({dt[dt$total_time >= input$range[1] &
                         dt$total_time <= input$range[2] &
                         ((dt$id == input$acc & !input$exclude) |
                            (dt$id != input$acc & input$exclude) |
                            is.na(input$acc)),]})
    output$tb = renderTable(head(sdt(), cnt))
    output$len = renderText(paste("selected",
                                  length(sdt()$total_time),
                                  "samples"))
    lm0 = reactive({
      if(length(sdt()$total_time) >= cnt)
        with(sdt(),
             lm(total_time ~ layer + sub_sec_cnt + sub_acc_cnt + dep + MERGE))})
    s0 = reactive({if(!is.null(lm0())) summary(lm0()) })
    output$lm = renderPrint({
      if(!is.null(s0())) s0()
      else "not enough samples"
    })
    output$summary_R = renderText({if(!is.null(s0())) s0()$r.squared})
  }
)

# setwd("D:/workspace/dss-devdataprod-20160620/proj"); library(shiny); runApp(display.mode="showcase")
# https://bbbush.shinyapps.io/dss-devdataprod-20160620/

# shiny tutorial http://shiny.rstudio.com/tutorial/
# shiny articles http://shiny.rstudio.com/articles/
# renderUI and uiOutput http://shiny.rstudio.com/gallery/dynamic-ui.html
