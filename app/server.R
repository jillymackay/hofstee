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


  exdat <- tibble(grades = round(rnorm(100, 55, 20),0))


  hofs <- reactive({
    hofstee(dat()$marks, input$i_low.fail.pc, input$i_high.fail.pc, input$i_low.mark, input$i_high.mark )
  })

  exhofs <- reactive({
    hofstee(exdat$grades, input$ex_lowfails, input$ex_highfails, input$ex_lowmark, input$ex_highmark)
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

  output$p_exdat <- renderPlot({

    exdat |>
      ggplot(aes(x = row_number(grades))) +
      geom_point(aes(y = grades), position = position_jitter(width = .13), size = 0.5, alpha = 0.6) +
      see::geom_violinhalf(aes(y = grades, alpha= 0.3), linetype = "dashed", position = position_nudge(x = .2)) +
      geom_boxplot(aes(y = grades, alpha = 0.3), position = position_nudge(x = -.1), width = 0.1, outlier.shape = NA) +
      theme_classic() +
      labs(x = "Feed Type", y = "Grades") +
      theme(legend.position = "none") +
      coord_flip()
  })


  output$p_exhofplot <- renderPlot({

    hof_plot(exdat$grades, input$ex_lowfails, input$ex_highfails, input$ex_lowmark, input$ex_highmark)
  })

  # ------------- Return Tables


  output$t_hofstable <- renderTable({
    hof_table(dat()$marks,  input$i_low.fail.pc, input$i_high.fail.pc, input$i_low.mark, input$i_high.mark)
  })


  output$t_exhofstable <- renderTable({
    hof_table(exdat$grades, input$ex_lowfails, input$ex_highfails, input$ex_lowmark, input$ex_highmark)
  })



 #------------ Close server bracket


})
