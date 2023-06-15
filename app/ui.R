library(shiny)
library(DT)




shinyUI(pageWithSidebar(
  headerPanel("Hofstee Standard Setting"),
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


