


hof_table <- function(marks, low.fail.pc, high.fail.pc, low.mark, high.mark){
  # apply hofstee methodology to set pass mark from exam results

  # help if no arguments
  if(missing(marks)){
    cat("Function to set pass mark using Hofstee methodology\n
useage:\n
hofstee(marks, low.fail.pc, high.fail.pc, low.mark, high.mark)\n
e.g.\n
hofstee(mydata$marks, 2, 10, 45, 55)\n\n")
    return()
  }

  # check some things
  if(!is.numeric(marks)) stop("marks need to be numbers")
  if(length(marks)<2) stop("need to have more than one mark")
  if(low.fail.pc >= high.fail.pc) stop("The highest fail % must be greater than the lowest fail %")
  if(low.mark >= high.mark) stop("The highest mark must be greater than the lowest mark")

  # linear interpolation of marks
  marks <- marks[!is.na(marks)]
  vals <- unique(marks)
  fun <- approxfun(sort(marks), seq(0, 100, length = length(marks)))

  # coordinates of 'hofstee' line across search rectangle
  search.y <- seq(high.fail.pc, low.fail.pc, - 0.01)
  search.x <- seq(low.mark, high.mark, length = length(search.y))

  # pedestrian way to find closest line/interpolated marks match
  error <-((fun(search.x)-search.y)^2)
  error[search.x<min(marks) | search.x>max(marks)] <- 999 # in range only
  error <- error[!is.na(error)]
  ind <- which(error == min(error))
  ind <- min(ind)
  final.error <- error[ind]
  pass.mark <- search.x[ind]
  pass.mark = round(pass.mark,1)
  pc.fail <- round(sum(marks<pass.mark) / length(marks) * 100, 3)
  n.marks <- length(marks)
  n.failed <- sum(marks<(pass.mark-0.5))


 tibble(Category = c("Standard set pass mark",
                   "% Fails",
                   "N Marks",
                   "N Failed"),
         Value = c(pass.mark, pc.fail, n.marks, n.failed))


}












hof_plot <- function(marks, low.fail.pc, high.fail.pc, low.mark, high.mark, plot = TRUE, legend = TRUE){
  # apply hofstee methodology to set pass mark from exam results

  # help if no arguments
  if(missing(marks)){
    cat("Function to set pass mark using Hofstee methodology\n
useage:\n
hofstee(marks, low.fail.pc, high.fail.pc, low.mark, high.mark)\n
e.g.\n
hofstee(mydata$marks, 2, 10, 45, 55)\n\n")
    return()
  }

  # check some things
  if(!is.numeric(marks)) stop("marks need to be numbers")
  if(length(marks)<2) stop("need to have more than one mark")
  if(low.fail.pc >= high.fail.pc) stop("high.fail.pc must be > low.fail.pc")
  if(low.mark >= high.mark) stop("high.mark must be > low.mark")

  # linear interpolation of marks
  marks <- marks[!is.na(marks)]
  vals <- unique(marks)
  fun <- approxfun(sort(marks), seq(0, 100, length = length(marks)))

  # coordinates of 'hofstee' line across search rectangle
  search.y <- seq(high.fail.pc, low.fail.pc, - 0.01)
  search.x <- seq(low.mark, high.mark, length = length(search.y))

  # pedestrian way to find closest line/interpolated marks match
  error <-((fun(search.x)-search.y)^2)
  error[search.x<min(marks) | search.x>max(marks)] <- 999 # in range only
  error <- error[!is.na(error)]
  ind <- which(error == min(error))
  ind <- min(ind)
  final.error <- error[ind]
  pass.mark <- search.x[ind]
  pass.mark = round(pass.mark,1)
  pc.fail <- round(sum(marks<pass.mark) / length(marks) * 100, 3)
  n.marks <- length(marks)
  n.failed <- sum(marks<(pass.mark-0.5))

  # plot everything if you want to
  if(plot){
    plot(sort(marks), fun(sort(marks)),
         type = "l",
         col = "grey60",
         xlim = c(min(low.mark, marks), max(high.mark, marks)),
         ylim = c(0, 100),
         ylab = "Cumulative %",
         xlab = "Mark")
    points(sort(marks), fun(sort(marks)), pch=20, cex= 0.6)
    points(search.x, search.y, type="l", col = "red")
    abline(v = c(low.mark,high.mark), col = "red", lty = 3)
    abline(h = c(low.fail.pc,high.fail.pc), col = "red", lty = 3)
    points(pass.mark, fun(pass.mark), col = "blue", pch = 1)
  }


  # if line and marks don't intersect return NA's
  if (error[ind] > 1){
    pc.fail <- NA
    pass.mark <- NA
    warning("Hofstee line does not intersect with marks")
  }

  # writelegend if you want
  if(legend){
    legend("top",
           col = NA,
           legend = paste(" Pass mark = ", pass.mark, "%", "\n", "Failed = ", pc.fail, "%", "\n N (marks) = ", n.marks, "\n N (failed) = ", n.failed),
           bty = "n")
  }

}




make_ex <- function(){
  d <- tibble(grades = round(rnorm(100, 65, 5),0)) |>
    mutate(grades = case_when(grades > 99 ~ 99,
                              grades < 8 ~ 8,
                              TRUE ~ as.numeric(grades)))
  return(d)
}
