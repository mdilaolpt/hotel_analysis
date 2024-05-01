# i am exporting local XLSX file to github project as CSV file for more convenient data prep
# file location is specific to this run
# an alternative option when updating file is to simply upload new/refreshed data on the data folder as needed
# note that if an enterprise datalake/ database connection is available, then there is no need for this step since the data can be refreshed automatically :)
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