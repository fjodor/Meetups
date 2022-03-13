# R-Pakete

library(tidyverse)                        # Paket-Sammlung mit intuitiver Syntax zur Datenbearbeitung
library(ggstatsplot)                      # Diagramme mit statistischen Zusatz-Informationen
library(ggside)                           # Ergänzung zu ggstatsplot
library(DT)                               # Interaktive Tabellen in Markdown
library(plotly)                           # Interaktive Diagramme
library(gganimate)                        # Animationen
library(gt)                               # flexible Tabellen
library(gtsummary)                        # Statistische Tests, tabellarisch
library(texreg)                           # Regressionstabellen darstellen
library(knitr)                            # Für Markdown
library(gapminder)                        # Daten für Animation
library(rattle)                           # Darstellung von Entscheidungsbäumen: fancyRpartPlot
# library(ggthemes)                         # Zusätzliche Diagramm-Stile, z. B. Wall Street Journal

# Paket-Sammlung zu einfachen Bearbeitung statistischer Analysen
install.packages("easystats", repos = "https://easystats.r-universe.dev")

# Wer alle Abhängigkeiten mit installieren möchte, kann das so tun:
# easystats::install_suggested()
# Achtung, das sind ziemlich viele Pakete!

# Daten: Charterfolg von Songs und Alben

library(devtools)
install_github("fjodor/chartmusicdata")

# Wer den R Commander ausprobieren möchte ...
# Rauten löschen, um Code zu aktivieren
# library(Rcmdr)                            # Grafische Oberfläche für statistische Tests
# library(sem)                              # Wird von R Commander benötigt
# library(rgl)                              # Wird von R Commander benötigt
# library(multcomp)                         # Wird von R Commander benötigt
# library(lmtest)                           # Wird von R Commander benötigt
# library(aplpack)                          # Wird von R Commander benötigt
# library(leaps)                            # Wird von R Commander benötigt

# Wer esquisse ausprobieren möchte, die grafische Oberfläche für ggplot2 (Grafiken mit R)
# library(esquisse)
