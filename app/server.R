# Server file


library(shiny)
library(tidyverse)



shinyServer(function(input, output, session){


# ---------------------- Create Reactive Dataset


  dat <- reactive({

    req(input$grade_file)

    infile <- input$grade_file

    req(input$grade_file, file.exists(input$grade_file$datapath))

    withProgress({
      setProgress(message = "Processing data ...")

    readxl::read_excel(infile$datapath)

    })

  })




  hofs <- reactive({
    hofstee(dat()$marks, input$i_low.fail.pc, input$i_high.fail.pc, input$i_low.mark, input$i_high.mark )
  })



  # ------------ Return Plots --------


  output$p_quickcheck <- renderPlot({

    dat() %>%
      ggplot(aes(x = marks)) +
      geom_histogram()+
      theme_classic() +
      labs(title = input$course_name)

  })


  output$p_hofplot <- renderPlot({

    hof_plot(dat()$marks,  input$i_low.fail.pc, input$i_high.fail.pc, input$i_low.mark, input$i_high.mark)
  })


  # ------------- Return Tables


  output$t_hofstable <- renderTable({
    hof_table(dat()$marks,  input$i_low.fail.pc, input$i_high.fail.pc, input$i_low.mark, input$i_high.mark)
  })


 #------------ Close server bracket


})
