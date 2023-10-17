exdat <- tibble(grades = round(rnorm(100, 55, 20),0)))



exdat |>
  ggplot(aes(x = row_number(grades))) +
  geom_point(aes(y = grades), position = position_jitter(width = .13), size = 0.5, alpha = 0.6) +
  see::geom_violinhalf(aes(y = grades, alpha= 0.3), linetype = "dashed", position = position_nudge(x = .2)) +
  geom_boxplot(aes(y = grades, alpha = 0.3), position = position_nudge(x = -.1), width = 0.1, outlier.shape = NA) +
  theme_classic() +
  labs(x = "Feed Type", y = "Grades") +
  theme(legend.position = "none") +
  coord_flip()



tbl <- hofstee(exdat$grades, 0,10,25,50)



exdat |>
  mutate(class = case_when(grades > as.numeric(tbl$pass_mark) ~ "Pass",
                           TRUE ~ "Fail")) |>
  ggplot(aes(x = row_number(grades))) +
  geom_boxplot(aes(y = grades, alpha = 0.3, x= 100), position = position_nudge(x = -.01), width = 20, outlier.shape = NA, colour = "#004f71", fill = "#487a7b") +
  geom_violinhalf(aes(y = grades, alpha= 0.3, x = 125), linetype = "dashed", position = position_nudge(x = .2), width = 30, fill= "#004f71") +
  geom_point(aes(y = grades, colour = class, shape = class), position = position_jitter(width = .13), size = 1, alpha = 0.6) +
  theme_classic() +
  labs(caption = "Raincloud plot (see Allen et al 2020) of 100 randomly generated grades
       between 0 and 100.",
       y = "Grade achieved on exam") +
  theme(legend.position = "none") +
  scale_y_continuous(limits = c(0,100)) +
  scale_x_continuous(breaks = NULL) +
  scale_colour_manual(values =c("#a50034", "#487a7b"))+
  coord_flip()





hof_plot(exdat$grades, 0,10,33,56)


hof_plot <- function(marks, low.fail.pc, high.fail.pc, low.mark, high.mark, plot = TRUE){
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
  pmarks <- tibble(marks)
  names(pmarks)[1] <- "grades"
  pmarks <- pmarks |>
    mutate(class = case_when(grades > pass.mark ~ "Pass",
                             TRUE ~ "Fail"))


  # plot everything if you want to
  if(plot){

    p<- pmarks |>
      ggplot(aes(x = row_number(grades))) +
      geom_boxplot(aes(y = grades, alpha = 0.3, x= 100), position = position_nudge(x = -.01), width = 20, outlier.shape = NA, colour = "#004f71", fill = "#487a7b") +
      geom_violinhalf(aes(y = grades, alpha= 0.3, x = 125), linetype = "dashed", position = position_nudge(x = .2), width = 30, fill= "#004f71") +
      geom_point(aes(y = grades, colour = class, shape = class), position = position_jitter(width = .13), size = 1, alpha = 0.6) +
      geom_vline(c(low.mark,high.mark))+
      theme_classic() +
      labs(title = "check 3",
           caption = "Raincloud plot (see Allen et al 2020) of your grades. Standards Setting shown",
           y = "Grade achieved on exam",
           x = "Cumulative %") +
      theme(legend.position = "none") +
      scale_y_continuous(limits = c(min(low.mark, marks), max(high.mark, marks))) +
      scale_x_continuous(breaks = NULL) +
      scale_colour_manual(values =c("#a50034", "#487a7b"))+
      coord_flip()

    return(p)

    # points(search.x, search.y, type="l", col = "red")
    # abline(v = c(low.mark,high.mark), col = "red", lty = 3)
    # abline(h = c(low.fail.pc,high.fail.pc), col = "red", lty = 3)
    # points(pass.mark, fun(pass.mark), col = "blue", pch = 1)
  }


  # if line and marks don't intersect return NA's
  if (error[ind] > 1){
    pc.fail <- NA
    pass.mark <- NA
    warning("Hofstee line does not intersect with marks")
  }

  # # writelegend if you want
  # if(legend){
  #   legend("top",
  #          col = NA,
  #          legend = paste(" Pass mark = ", pass.mark, "%", "\n", "Failed = ", pc.fail, "%", "\n N (marks) = ", n.marks, "\n N (failed) = ", n.failed),
  #          bty = "n")
  # }

}






pmarks <- tibble(exdat$grades)
names(pmarks)[1] <- "grades"
pmarks <- pmarks |>
  mutate(class = case_when(grades > 50 ~ "Pass",
                           TRUE ~ "Fail"))


pmarks |>
  ggplot(aes(x = row_number(grades))) +
  geom_boxplot(aes(y = grades, alpha = 0.3, x= 100), position = position_nudge(x = -.01), width = 20, outlier.shape = NA, colour = "#004f71", fill = "#487a7b") +
  geom_violinhalf(aes(y = grades, alpha= 0.3, x = 125), linetype = "dashed", position = position_nudge(x = .2), width = 30, fill= "#004f71") +
  geom_point(aes(y = grades, colour = class, shape = class), position = position_jitter(width = .13), size = 1, alpha = 0.6) +
  theme_classic() +
  labs(caption = "Raincloud plot (see Allen et al 2020) your grades. Standards Setting shown",
       y = "Grade achieved on exam",
       x = "Cumulative %") +
  theme(legend.position = "none") +
  scale_y_continuous(limits = c(0,100)) +
  scale_x_continuous(breaks = NULL) +
  scale_colour_manual(values =c("#a50034", "#487a7b"))+
  coord_flip()




marks <- exdat$grades
low.fail.pc <- 0
high.fail.pc <- 10
low.mark <- 33
high.mark <- 56

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
pmarks <- tibble(marks)
names(pmarks)[1] <- "grades"
pmarks <- pmarks |>
  mutate(class = case_when(grades > pass.mark ~ "Pass",
                           TRUE ~ "Fail"))


# plot everything if you want to
if(plot){

  pmarks |>
    ggplot(aes(x = row_number(grades))) +
    geom_boxplot(aes(y = grades, alpha = 0.3, x= 100), position = position_nudge(x = -.01), width = 20, outlier.shape = NA, colour = "#004f71", fill = "#487a7b") +
    geom_violinhalf(aes(y = grades, alpha= 0.3, x = 125), linetype = "dashed", position = position_nudge(x = .2), width = 30, fill= "#004f71") +
    geom_point(aes(y = grades, colour = class, shape = class), position = position_jitter(width = .13), size = 1, alpha = 0.6) +
    theme_classic() +
    labs(caption = "Raincloud plot (see Allen et al 2020) your grades. Standards Setting shown",
         y = "Grade achieved on exam",
         x = "Cumulative %") +
    theme(legend.position = "none") +
    scale_y_continuous(limits = c(0,100)) +
    scale_x_continuous(breaks = NULL) +
    scale_colour_manual(values =c("#a50034", "#487a7b"))+
    coord_flip()

  # plot(sort(marks), fun(sort(marks)),
  #      type = "l",
  #      col = "grey60",
  #      xlim = c(min(low.mark, marks), max(high.mark, marks)),
  #      ylim = c(0, 100),
  #      ylab = "Cumulative %",
  #      xlab = "Mark")
  # points(sort(marks), fun(sort(marks)), pch=20, cex= 0.6)
  # points(search.x, search.y, type="l", col = "red")
  # abline(v = c(low.mark,high.mark), col = "red", lty = 3)
  # abline(h = c(low.fail.pc,high.fail.pc), col = "red", lty = 3)
  # points(pass.mark, fun(pass.mark), col = "blue", pch = 1)
}


# if line and marks don't intersect return NA's
if (error[ind] > 1){
  pc.fail <- NA
  pass.mark <- NA
  warning("Hofstee line does not intersect with marks")
}

# writelegend if you want
# if(legend){
#   legend("top",
#          col = NA,
#          legend = paste(" Pass mark = ", pass.mark, "%", "\n", "Failed = ", pc.fail, "%", "\n N (marks) = ", n.marks, "\n N (failed) = ", n.failed),
#          bty = "n")
# }



















pmarks |>
  ggplot(aes(x = row_number(grades))) +
  geom_boxplot(aes(y = grades, alpha = 0.3, x= 100), position = position_nudge(x = -.01), width = 20, outlier.shape = NA, colour = "#004f71", fill = "#487a7b") +
  geom_violinhalf(aes(y = grades, alpha= 0.3, x = 125), linetype = "dashed", position = position_nudge(x = .2), width = 30, fill= "#004f71") +
  geom_point(aes(y = grades, colour = class, shape = class), position = position_jitter(width = .13), size = 1, alpha = 0.6) +
  # geom_hline(yintercept = low.mark, colour ="red")+
  # geom_hline(yintercept = high.mark, colour ="red")+
  # geom_vline(xintercept = low.fail.pc, colour = "red") +
  # geom_vline(xintercept = high.fail.pc, colour = "red") +
  geom_linerange(eyintercept = low.mark, colour ="red")+
  geom_hline(yintercept = high.mark, colour ="red")+
  geom_vline(xintercept = low.fail.pc, colour = "red") +
  geom_vline(xintercept = high.fail.pc, colour = "red") +
  theme_classic() +
  labs(title = "check 3",
       caption = "Raincloud plot (see Allen et al 2020) of your grades. Standards Setting shown",
       y = "Grade achieved on exam",
       x = "Cumulative %") +
  theme(legend.position = "none") +
  scale_y_continuous(limits = c(min(low.mark, marks), max(high.mark, marks))) +
  scale_x_continuous(breaks = c(0, 100), limits =c(0,150)) +
  scale_colour_manual(values =c("#a50034", "#487a7b"))+
  coord_flip()
