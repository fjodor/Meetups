# Functional Programming Using purrr

library(tidyverse)

#### What We Want to Achieve ####

seeds <- c(2219868, 110454, 639, 1750, 690, 9487)
word_lengths <- c(5, 4, 2, 3, 2, 4)
choices <- c(rep(list(letters), 5), list(0:9))

magic_message <- function(seed, choices, word_length) {
  set.seed(seed)
  sample(choices, size = word_length, replace = TRUE) |>
    paste(collapse = "") |>
    stringr::str_to_title()
}

purrr::pmap_chr(
  list(seeds, choices, word_lengths),
  magic_message) |>
cat()


#### Let's Go Step By Step ####

# Drawing Random Letters ...

set.seed(1)
sample(letters, size = 5, replace = TRUE) |>
  paste(collapse = "")

set.seed(2)  
sample(letters, size = 5, replace = TRUE) |>
  paste(collapse = "")


# Knowing a Few Magic Seeds ...

set.seed(1982138)  
sample(letters, size = 4, 
       replace = TRUE) |>
  paste(collapse = "") |>
  stringr::str_to_title()

set.seed(942538)  
sample(letters, size = 4, 
       replace = TRUE) |> 
  paste(collapse = "") |>
  stringr::str_to_title()


#### From Copy & Paste to Our Own Function ####

magic_message <- function(seed) {  
  set.seed(seed)
  sample(letters, 
         size = 4, 
         replace = TRUE) |>
  paste(collapse = "") |>
  stringr::str_to_title()
}


# Applying the Function

magic_message(1982138)
magic_message(942538)


#### Applying the Function More Elegantly ####

seeds <- c(1982138, 942538)

lapply(seeds, magic_message)  

sapply(seeds, magic_message)  

lapply(seeds, magic_message) |> unlist()  


#### Enter purrr ####

# Specify Data Type of Return Value

seeds <- c(1982138, 942538)
lapply(seeds, magic_message)

library(purrr)
map_chr(seeds, magic_message) 


#### purrr: Iterating over Two Vectors ####

# Love is just a four-letter word ...

magic_message <- function(seed) {
  set.seed(seed)
  sample(letters,
         size = 4,  
         replace = TRUE) |>
  paste(collapse = "") |>
  stringr::str_to_title()
}


# Flexible word lengths

magic_message <- function(seed,
        word_length) {   
  set.seed(seed)
  sample(letters,
         size = word_length,  
         replace = TRUE) |>
  paste(collapse = "") |>
  stringr::str_to_title()
}


# Let's apply the new function

#### map2 ####

seeds <- c(2219868, 110454)
word_lengths <- c(5, 4)

map2_chr(seeds, word_lengths, 
         magic_message)

#### purrr: Iterating over Multiple Vectors ####

# Adding Flexibility: Choices to Sample From

# Flexible Choices

magic_message <- function(seed, 
        choices, word_length) { 
  set.seed(seed)
  sample(choices, 
         size = word_length, 
         replace = TRUE) |>
    paste(collapse = "") |>
    stringr::str_to_title()
}


#### pmap() ####

seeds <- c(2219868, 110454, 639, 1750, 690, 9487)
word_lengths <- c(5, 4, 2, 3, 2, 4)
choices <- c(rep(list(letters), 5), list(0:9))

purrr::pmap_chr(   
  list(seeds, choices, word_lengths),  
  magic_message) |>
cat()


# With comments

purrr::pmap_chr(
  # .l list of vectors to iterate over
  list(seeds, choices, word_lengths),

  # .f function that takes 3 arguments
  magic_message) |>

# remove quotes around each word
cat()


#### Ideas to play around with ####

# If you, like me, lack in intuition for magic seeds:
# There is a dataset to get you started ...

MagicNumbers <- readRDS("MagicNumbers.rds")

# Maybe it is enough to experiment with just letters, not numbers
# So leave the choices fixed to letters,
# use the second version of the function

magic_message <- function(seed,
                          word_length) {   
  set.seed(seed)
  sample(letters,
         size = word_length,  
         replace = TRUE) |>
    paste(collapse = "") |>
    stringr::str_to_title()
}

# Now try out some seeds, and provide the corresponding word lengths ...
# E. g.:
seeds <- c(17, 1750, 8661721)
word_lengths <- c(1, 3, 5)
map2_chr(seeds, word_lengths, magic_message)
