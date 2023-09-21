library(shiny)
library(DT)





shinyUI(
  navbarPage(title = "Hofstee Standard Setting",
             id = "navbar",
             theme = shinythemes::shinytheme("yeti"),

             tabPanel(title = "Explore Standard Setting",
                      sidebarPanel(
                        sliderInput(inputId = "ex_lowfails",
                                    label = "The lowest acceptable % of students to fail:",
                                    min = 0,
                                    max = 100,
                                    value = 0),
                        sliderInput(inputId = "ex_highfails",
                                    label = "The highest acceptable % of students to fail:",
                                    min = 0,
                                    max = 100,
                                    value = 10),
                        sliderInput(inputId = "ex_lowmark",
                                    label = "The lowest acceptable % correct score to allow borderline student to pass:",
                                    min = 0,
                                    max = 100,
                                    value = 48),
                        sliderInput(inputId = "ex_highmark",
                                    label = "The highest acceptable % correct score to allow borderline student to pass:",
                                    min = 0,
                                    max = 100,
                                    value = 52)
                      ),
                      mainPanel(plotOutput(outputId = "p_exdat"),
                                tableOutput(outputId = "t_exhofstable"),
                                plotOutput(outputId = "p_exhofplot"))),
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
                      )
             )
)


