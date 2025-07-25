# Adjust pdf

library(qpdf)

pdf_subset(input = "2025-07-25_Sara-Institute-Functional.pdf",
           output = "2025-07-25_Functional-Programming_Riepl.pdf",
           pages = c(1:5, 7:9, 11:25))
