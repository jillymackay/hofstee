# Server file


library(shiny)
library(tidyverse)
library(see)



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


  exdat <- tibble(grades = round(rnorm(100, 65, 5),0)) |>
    mutate(grades = case_when(grades > 99 ~ 99,
                              grades < 8 ~ 8,
                              TRUE ~ as.numeric(grades)))


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
      mutate(class = case_when(grades > as.numeric(exhofs()$pass_mark) ~ "Pass",
                               TRUE ~ "Fail")) |>
      ggplot(aes(x = row_number(grades))) +
      geom_boxplot(aes(y = grades, alpha = 0.3, x= 100), position = position_nudge(x = -.01), width = 20, outlier.shape = NA, colour = "#004f71", fill = "#487a7b") +
      geom_violinhalf(aes(y = grades, alpha= 0.3, x = 125), linetype = "dashed", position = position_nudge(x = .2), width = 30, fill= "#004f71") +
      geom_point(aes(y = grades, colour = class, shape = class), position = position_jitter(width = .13), size = 1, alpha = 0.6) +
      theme_classic() +
      labs(caption = "Raincloud plot (see Allen et al 2020) of 100 randomly generated grades
       between 0 and 100.",
       y = "Grade achieved on exam",
       x = NULL) +
      theme(legend.position = "none") +
      scale_y_continuous(limits = c(0,100)) +
      scale_x_continuous(breaks = NULL) +
      scale_colour_manual(values =c("#a50034", "#487a7b"))+
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


  # ---------------------- Flat Images -------------------


  output$logo <- renderImage({
    # Return a list containing the filename
    list(src = file.path("assets/logo.png"),
         contentType = 'image/png',
         width = 221,
         height = 52,
         alt = "R(D)SVS Logo")
  }, deleteFile = FALSE)



 #------------ Close server bracket


})
