library(readxl)
library(readr)
metrics <- read_excel("~/Desktop/Exam - Analyst.xlsx", 
                      sheet = "METRICS")

hotel_details <- read_excel("~/Desktop/Exam - Analyst.xlsx", 
                      sheet = "HOTEL_DETAILS")

currency <- read_excel("~/Desktop/Exam - Analyst.xlsx", 
                            sheet = "CURRENCY")

calendar <- read_excel("~/Desktop/Exam - Analyst.xlsx", 
                       sheet = "CALENDAR")

write_csv(metrics, "~/hotel_performance_analysis/data/metrics.csv", append = FALSE)
write_csv(hotel_details, "~/hotel_performance_analysis/data/hotel_details.csv", append = FALSE)
write_csv(currency, "~/hotel_performance_analysis/data/currency.csv", append = FALSE)
write_csv(calendar, "~/hotel_performance_analysis/data/calendar.csv", append = FALSE)
