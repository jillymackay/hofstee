library(shiny)
library(DT)





shinyUI(
  navbarPage(title = "Hofstee Standard Setting",
             id = "navbar",
             theme = shinythemes::shinytheme("yeti"),

             tabPanel(title = "Explore Standard Setting",
                      sidebarPanel(tags$h2("Criteria"),
                                   tags$p("These are the main criteria used in Hofstee standard setting.
                                          Try changing some of the criteria and look what happens to the
                                          corresponding pass rate of the exam to the right."),
                                   sliderInput(inputId = "ex_lowfails",
                                               label = "What is the minimum % of students that will fail the exam? (In practice we would advise this should be 0%!)",
                                               min = 0,
                                               max = 100,
                                               value = 0),
                                   sliderInput(inputId = "ex_highfails",
                                               label = "What is the maximum % of students that will fail the exam?",
                                               min = 0,
                                               max = 100,
                                               value = 10),
                                   sliderInput(inputId = "ex_lowmark",
                                               label = "What is the lowest % correct score that you would be happy to consider a pass?",
                                               min = 0,
                                               max = 100,
                                               value = 48),
                                   sliderInput(inputId = "ex_highmark",
                                               label = "What is the highest % correct score that you would be happy to consider a pass?",
                                               min = 0,
                                               max = 100,
                                               value = 52)
                                   ),
                      mainPanel(tags$h2("Decide how you would apply Hofstee Standard Setting to this data"),
                                plotOutput(outputId = "p_exdat"),
                                tableOutput(outputId = "t_exhofstable"),
                                plotOutput(outputId = "p_exhofplot"))
                      ),
             tabPanel(title = "Standard set your own marks",
                      sidebarPanel(tags$p("Upload your marks file here. The only data required is the final course mark – this should be in a column headed ‘marks’ and saved as a", tags$em(".xlsx"), "file. There is no need to have a specific name for the file."),
                                   fileInput(inputId = "grade_file",
                                             label = "Upload your xlsx file here"),
                                   textInput(inputId = "course_name",
                                             label = "You can add the course name here",
                                             placeholder = "ICC Farm"),
                                   numericInput(inputId = "i_low.fail.pc",
                                                label = "The lowest acceptable % of students to fail (Default 0%)",
                                                value = 0),
                                   numericInput(inputId = "i_high.fail.pc",
                                                label = "The highest acceptable % of students to fail (Default 10%)",
                                                value = 10),
                                   numericInput(inputId = "i_low.mark",
                                                label = "Lowest acceptable % correct score to allow borderline student to pass (Default 48%)",
                                                value = 48),
                                   numericInput(inputId = "i_high.mark",
                                                label = "Highest acceptable % correct score to allow borderline student to pass (Default 52%)",
                                                value = 52)),
                      mainPanel(tableOutput(outputId = "t_hofstable"),
                                plotOutput(outputId = "p_hofplot"))
                      ),
            tabPanel(title = "About Hofstee Standard Setting",
                     tags$p("In situations where every year group must sit an exam, but the exam questions must be
refreshed to ensure  that students in subsequent years do not have an unfair advantage,
there can be inherent variability in exam questions. One year may be 'easier' and another
'harder'. How can the exam setting body accomodate for this?"),
tags$p("Principally, this should be done through human and critical evaluation of the questions set. In practice, this should reflect the robust Quality Assurance process of assessment in the institution. Exam questions should be reviewed by experts who are involved with teaching and experts who are external to teaching (the External Examiner role)."),
tags$p("That said, there is still variation year on year in exam difficulty.
                                       A group of examiners (the Exam Board) should debate and agree on the expected
                                       performance level of borderline students on each item or component of the test
                                       as part of", tags$em("Criterion Referenced Standard Setting."),
       "For Multiple Choice Question exams, the Hofstee method is well-established as
                                       appropriate (Noricini, 2003). This app describes how the Hofstee method
                                       works and applies criterion to an example dataset. It will also allow
                                       you to standard set your own range of marks."),
                     )
             )
)


