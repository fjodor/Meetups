# Functional Programming Using purrr

# Further purrr functions

library(tidyverse)

# partial #
# pre-fill function arguments

mean_na_rm <- partial(mean, na.rm = TRUE)
mean_na_rm(c(1, 2, 3, NA))


# compact
# discard elements that are NULL or of length 0

list(a = 1:3, b = NULL, c = "text") %>% 
  compact()

# flatten
# Remove a level of hierarchy from a list

rerun(2, sample(4)) %>% flatten_int()
rerun(2, sample(4))


#### safely() and possibly() ####

log("text")
log_safe <- safely(log)
log_safe("text")

log_pos <- possibly(log, otherwise = NA_real_)
log_pos("text")

log_pos <- possibly(log, otherwise = "Doesn't make sense!")
log_pos("text")


#### compose ####

round(mean(10:50))
round(mean(100:500))
round(mean(1000:5000))

# What if we needed the median instead?

round(median(10:50))
round(median(100:500))
round(median(1000:5000))

# 3 changes.
# Better to have to change only in one central place!

stat_round <- compose(round, mean)

stat_round(10:50)
stat_round(100:500)
stat_round(1000:5000)

# Now switch to median:

stat_round <- compose(round, median)
# Change applies only here!

stat_round(10:50)
stat_round(100:500)
stat_round(1000:5000)


#### Working with lists: Star Wars ####

library(repurrrsive)

data(sw_films)

str(sw_films)
head(sw_films)
# Not pretty

str(sw_films, max.level = 1)
# Not helpful

head(sw_films, n = 1)

# How to extract film title?

lapply(sw_films, function(x) x[[1]])
sapply(sw_films, function(x) x[[1]])

map_chr(sw_films, "title")

# Task: Extract director
map_chr(sw_films, "director")

map_dfr(sw_films, magrittr::extract, c("title", "release_date"))


