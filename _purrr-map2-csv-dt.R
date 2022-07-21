#### Aufgabe: Schleife ersetzen mit purrr ####

# Datenvorbereitung

artists <- songs2000 %>% 
  count(artist) %>% 
  slice_max(n, n = 15, with_ties = FALSE) %>% 
  pull(artist)

top_artists <- songs2000 %>% 
  filter(artist %in% artists)

filenames <- artists %>% 
  str_replace_all(" ", "_") %>% 
  paste0(".csv")


# Klassische for-Schleife

# Daten und Dateinamen werden innerhalb der Schleife gebildet
# mit jeweils neuer Zuweisung

for (my_artist in artists) {
  
  data <- songs2000 %>% 
    filter(artist %in% my_artist)
  
  filename <- my_artist %>% 
    str_replace_all(" ", "_") %>% 
    paste0(".csv")
  
  readr::write_csv(data, file = filename)
}

unlink(filenames)


# Mit benutzerdefinierter Funktion

my_csv1 <- function(my_artist) {
  
  data <- songs2000 %>% 
    filter(artist %in% my_artist)
  
  filename <- my_artist %>% 
    str_replace_all(" ", "_") %>% 
    paste0(".csv")
  
  readr::write_csv(data, file = filename)
  
}

for (my_artist in artists) {
  my_csv1(my_artist)
}

unlink(filenames)


# purrr-Lösung
# Ziel: Vektor filenames verwenden anstatt filename in jedem Schleifendurchlauf separat zuzuweisen
# Funktion kürzen, filename als Funktionsargument ergänzen
# und mit purrr-Funktion über ZWEI Vektoren artists und filenames iterieren

my_csv2 <- function(my_artist, filename) {
  
  data <- songs2000 %>% 
    filter(artist %in% my_artist)
  
  readr::write_csv(data, file = filename)
  
}

purrr::map2(artists, filenames, my_csv2)

unlink(filenames)
