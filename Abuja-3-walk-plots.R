# Functional Programming Using purrr
# purrr::walk() for creating plots programmatically

# Idea: Create plots for each clarity

library(tidyverse)

# Reduce dataset for faster plotting
set.seed(42)
diamonds2 <- sample_frac(diamonds, size = 0.1)

diamonds2 %>% 
  filter(clarity == "I1") %>% 
  ggplot(aes(x = carat, y = price, color = depth)) +
  geom_point(alpha = 0.6) +
  labs(title = "Diamonds: Carat vs. Price",
       subtitle = glue::glue("Color: {diamonds$color}; Clarity: {diamonds$clarity}")) +
  theme_bw()

# Plots for other clarities: Filter manually?
levels(diamonds2$clarity)

# More elegant: an automated approach

# Write a custom plotting function

my_plot <- function(my_clarity) {
  diamonds2 %>% 
    filter(clarity == my_clarity) %>% 
    ggplot(aes(x = carat, y = price, color = depth)) +
    geom_point(alpha = 0.6) +
    labs(title = "Diamonds: Carat vs. Price",
         subtitle = glue::glue("Clarity: {my_clarity}")) +
    theme_bw()
}

my_plot("I1")
my_plot("VVS1")

my_clarities <- levels(diamonds$clarity)

lapply(my_clarities, my_plot)
# Notice the list indices in the console

map(my_clarities, my_plot)
# Same result for purrr::map()

# More elegant: Avoid list output in console

purrr::walk(my_clarities, my_plot)
# No output; like in a loop, the plot must be printed

purrr::walk(my_clarities, ~print(my_plot(.)))

# Alternative for anonymous functions
walk(my_clarities, function(x) print(my_plot(x)))

# New since R 4.2.0: Base R shortcut for anonymous function(x)
walk(my_clarities, \(x) print(my_plot(x)))
