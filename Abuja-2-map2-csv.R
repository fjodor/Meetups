# Functional Programming Using purrr

#### Replacing Loops Using purrr ####

library(tidyverse)

# Data Preparation

cuts <- levels(diamonds$cut)

filenames <- diamonds %>% 
  pull(cut) %>% 
  levels() %>% 
  str_replace_all(" ", "_") %>% 
  str_c("Diamonds_Cut_", ., ".csv")

filenames

# Classic for loop

# Data and files names are constructed inside the loop

for (my_cut in cuts) {
  
  data <- diamonds %>% 
    filter(cut %in% my_cut)
  
  filename <- my_cut %>% 
    str_replace_all(" ", "_") %>% 
    str_c("Diamonds_Cut_", ., ".csv")
  
  readr::write_csv(data, file = filename)
}

unlink(filenames)


# User defined function

my_csv1 <- function(my_cut) {
  
  data <- diamonds %>% 
    filter(cut %in% my_cut)
  
  filename <- my_cut %>% 
    str_replace_all(" ", "_") %>% 
    str_c("Diamonds_Cut_", ., ".csv")
  
  readr::write_csv(data, file = filename)
  
}

for (my_cut in cuts) {
  my_csv1(my_cut)
}

unlink(filenames)


# purrr solution
# Approach: Use vector of filenames instead of assigning file name inside the loop
# Adapt function, provide filename as function argument
# Iterate over cuts and filenames

my_csv2 <- function(my_cut, filename) {
  
  data <- diamonds %>% 
    filter(cut %in% my_cut)
  
  readr::write_csv(data, file = filename)
  
}

purrr::map2(cuts, filenames, my_csv2)

# Avoiding the output: walk instead of map
# walk calls functions purely for their side effects (like saving files, drawing plots)

unlink(filenames)

purrr::walk2(cuts, filenames, my_csv2)

unlink(filenames)

# Speed comparison
# For such a low number of files, map2 and walk2 are slower than the loop

# library(bench)
# 
# bench::mark(
#  loop = for (my_cut in cuts) function(x) my_csv1(x),
#  map2 = map2(cuts, filenames, my_csv2),
#  walk2 = walk2(cuts, filenames, my_csv2),
#  check = FALSE   # results = return objects are not equal
# )
# 
# unlink(filenames)
