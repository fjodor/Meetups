# Putting the Fun in Functional Programming
# Code to presentation for Sara Institute
# 2025-07-25

# Load libraries ----

library(knitr)
library(tidyverse)
library(ggrepel)
library(devtools)
library(gtsummary)

# Uncomment and run once to install data package
# devtools::install_github("fjodor/chartmusicdata")
library(chartmusicdata)

data("albums2000")


# A chart ----

albums2000 %>% 
  filter(year == 2020) %>%
  filter(!(artist %in% c(
    "Original Soundtrack", "Various Artists"))) %>%
  count(artist) %>% 
  slice_max(n, n = 7) %>% 
  ggplot(aes(x = n, 
             y = fct_rev(fct_inorder(artist)))) +
  geom_point(size = 5, col = "blue") +
  ggthemes::theme_wsj(base_size = 14) +
  labs(title = "Albums in 2020",
       subtitle = "Most Entries",
       y = "", caption = "Source: chart2000.com") +
  scale_x_continuous(limits = c(0, NA))

# Charts for other years (subgroups)
# Copy and paste, adapt year?
# Better:

## Turn code into a function! ----

my_plot <- function(Year) {
  albums2000 %>% 
    filter(year == Year) %>%
    filter(!(artist %in% c(
      "Original Soundtrack", "Various Artists"))) %>%
    count(artist) %>% 
    slice_max(n, n = 7) %>% 
    ggplot(aes(x = n, 
               y = fct_rev(fct_inorder(artist)))) +
    geom_point(size = 5, col = "blue") +
    ggthemes::theme_wsj(base_size = 14) +
    labs(title = paste("Albums in", Year),
         subtitle = "Most Entries",
         y = "", caption = "Source: chart2000.com") +
    scale_x_continuous(limits = c(0, NA))
}

## Apply function ----

my_plot(2019)
my_plot(2018)


# Still many lines of code for many charts
# Better yet: Many charts from one line of code!

### Base R ----

lapply(2000:2020, my_plot)

# Produces empty list output in console
# [[1]]
# [[2]]
# etc.

#### Tidyverse, purrr package ----

# Like lapply
map(2000:2020, my_plot)

# Suppress output in console - charts only
walk(2000:2020, ~print(my_plot(.)))

# Show progress bar
walk(2000:2020, ~print(my_plot(.)), .progress = TRUE)

# Latest purrr version also supports parallelization using mirai
# See tidyverse blog
# https://www.tidyverse.org/blog/2025/07/purrr-1-1-0-parallel/


# Creating Many Statistical Models ----

## Data preparation ----

data(topalbums)

top_artists <- topalbums %>% 
  filter(!(artist %in% c("Original Soundtrack", "Original Cast"))) %>% 
  count(artist) %>% 
  filter(n > 9) %>% 
  pull(artist)

top_artists <- topalbums %>% 
  filter(artist %in% top_artists)

## Some code for a plot ... ----

top4 <- top_artists %>% 
  count(artist) %>% 
  slice_max(order_by = n, n = 4, with_ties = FALSE) %>% 
  pull(artist)

# Label most successful album of each artist / band

plot_labels <- topalbums %>% 
  filter(artist %in% top4) %>% 
  group_by(artist) %>% 
  filter(final_score == max(final_score)) %>% 
  rename(label = name)

plot_data <- top_artists %>% 
  left_join(plot_labels) %>% 
  mutate(label = str_wrap(label, width = 19))

plot <- plot_data %>% 
  filter(artist %in% top4) %>% 
  ggplot(aes(x = year, y = final_score, label = label)) +
  geom_point() +
  # geom_text(aes(label = label), nudge_y = 60,
  #           nudge_x = 10, check_overlap = TRUE) +
  ggrepel::geom_text_repel(nudge_y = 7, nudge_x = 10,
                           arrow = arrow(), col = "darkblue") +
  facet_wrap(~ artist, nrow = 2) +
  scale_y_continuous(limits = c(0, 70)) +
  labs(x = "Year", y = "Score",
       title = "Top 4 Bands / Artists with most Albums in Top 3000") +
  theme_bw(base_size = 14) 

plot


## Just for lines of code: Model overviews ----

top_artists %>% 
  nest_by(artist) %>% 
  mutate(model = list(lm(raw_eur ~ raw_usa, data = data))) %>% 
  summarise(broom::glance(model), .groups = "drop")

# See https://www.tidyverse.org/blog/2020/06/dplyr-1-0-0/

## Step 1: Create “nested” dataset ----

top_mod <- top_artists %>% 
  nest_by(artist)
head(top_mod)

# Access data using Base R: possible, but not convenient

top_mod$data[[1]] %>%  # AC/DC
  select(1:3) %>%      # Spalten
  slice(1:3)           # Zeilen


## Step 2: One Model per Group ----

top_mod2 <- top_mod %>% 
  mutate(model = list(lm(raw_eur ~ raw_usa, data = data)))
head(top_mod2)

# Access models using Base R: possible, but not convenient

top_mod2$model[[1]]
summary(top_mod2$model[[1]])

# Get a convenient table: gtsummary

top_mod2$model[[1]] %>% 
  tbl_regression()

# Better: Convert to tidy data

## Step 3: Dataset format - Model summaries ----
# Use broom

top_res <- top_mod2 %>% 
  # summarise(broom::glance(model))
  summarise(broom::glance(model), .groups = "drop")  # .groups: avoid message
head(top_res)


## Step 3: Dataset format - Coefficients ----

top_res2 <- top_mod2 %>% 
  reframe(broom::tidy(model))   # seit dplyr 1.0; summarise nicht mehr für >1 Zeilen
head(top_res2)


## Just Four Lines of Code! ----
# Even without assigning to objects

# Model summaries

top_artists %>% 
  nest_by(artist) %>% 
  mutate(model = list(lm(raw_eur ~ raw_usa, data = data))) %>% 
  summarise(broom::glance(model), .groups = "drop")

# Coefficients

top_artists %>% 
  nest_by(artist) %>% 
  mutate(model = list(lm(raw_eur ~ raw_usa, data = data))) %>% 
  reframe(broom::tidy(model))


# What if we wanted just one row per band / artist?

top_res2b <- top_res2 %>% 
  pivot_wider(names_from = term, values_from = c(estimate, std.error, statistic, p.value))

head(top_res2b)

# All in one pipe, including data transformation

top_artists %>% 
  nest_by(artist) %>% 
  mutate(model = list(lm(raw_eur ~ raw_usa, data = data))) %>% 
  reframe(broom::tidy(model)) %>% 
  pivot_wider(names_from = term, values_from = c(estimate, std.error, statistic, p.value)) %>% 
  View()
