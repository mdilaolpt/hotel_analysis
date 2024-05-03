#forecasting package------------
install.packages('prophet')
install.packages('rstan')
install.packages("glue")
library(prophet)
library(rstan)
library(readr)
library(dplyr)
library(glue)
library(ggplot2)

#data----------------------------
exius_df <- read_csv("data/hotel_EXIUS_data.csv")
gcbjn_df <- read_csv("data/hotel_GCBJN_data.csv")
icwas_df <- read_csv("data/hotel_ICWAS_data.csv")
phega_df <- read_csv("data/hotel_PHEGA_data.csv")
ukpil_df <- read_csv("data/hotel_UKPIL_data.csv")



#Create FUNCTION for forecasting-------------------------------------------
hotel_forecast <- function(df,
                           forecast_horizon){
  
names(df)[names(df) == "STY_DT"] <- "ds"
names(df)[names(df) == "CONVERTED_REV"] <- "y"

mean_y <- mean(df$y)

# normalizing y value to avoid outliers affecting the forecast
df <- df %>%
  mutate(y = ifelse(y > 300000, mean_y, y))

#computing for cap value
n = nrow(df)
df <- df %>%
         mutate(cap = round(mean(df$y[round(n * 0.5):n], na.rm = TRUE) + 2 * stats::sd(df$y[round(n * 0.5):n], na.rm =TRUE)))


# fit the Prophet model with logistic growth
model <- prophet(df,
                 growth = "linear",
                 algorithm = "Newton")
#Forecast for 3 month ---------------------
future <- make_future_dataframe(model, periods = forecast_horizon)
future$cap <- round(mean(df$y[round(n * 0.5):n], na.rm = TRUE) + 2 * stats::sd(df$y[round(n * 0.5):n], na.rm =TRUE)) 

forecast <- predict(model, future)
forecast <- forecast %>%
  select(ds, yhat, yhat_upper, yhat_lower)

# Convert ds column in df to Date format
df$ds <- as.Date(df$ds)

# Extract actual values from the original dataframe
actual_values <- df[c("ds", "y")]

# Extract predicted values from the forecast dataframe
predicted_values <- forecast[c("ds", "yhat")]

# Convert ds column in forecast to Date format
predicted_values$ds <- as.Date(predicted_values$ds)

# Combine actual and predicted values
combined_data <- left_join(forecast, df, by = "ds")

hotel_name <-df %>%
              select(HTL_CD) %>%
              distinct() %>%
              as.character()

# Plot actual and predicted values
hotel_plot <- ggplot(combined_data, aes(x = ds)) +
  geom_line(aes(y = y, color = "Actual")) +
  geom_line(aes(y = yhat, color = "Predicted")) +
  labs(x = "Date", y = "Values", color = "Data Type") +
  ggtitle(glue::glue("{hotel_name} Hotel Actual vs Predicted Values for {forecast_horizon} days"))

return(hotel_plot)
}

#Forecasting for ICWAS hotel--------------------------
setwd("~/hotel_performance_analysis/imgs") #to make sure that plots will be saved in /imgs

# 3 months
ICWAS_forecast <-  hotel_forecast(icwas_df,
                                  forecast_horizon = 90)
ggsave("icwas_forecast_3mos.png", plot = ICWAS_forecast)

# 1 year
ICWAS_forecast <-  hotel_forecast(icwas_df,
                                  forecast_horizon = 360)
ggsave("icwas_forecast_1yr.png", plot = ICWAS_forecast)

#Forecasting for EXIUS hotel--------------------------

# 3 months
EXIUS_forecast <-  hotel_forecast(exius_df,
                                  forecast_horizon = 90)
ggsave("exius_forecast_3mos.png", plot = EXIUS_forecast)

# 1 year
EXIUS_forecast <-  hotel_forecast(exius_df,
                                  forecast_horizon = 360)
ggsave("exius_forecast_1yr.png", plot = EXIUS_forecast)

#Forecasting for GCBJN hotel--------------------------

# 3 months
GCBJN_forecast <-  hotel_forecast(gcbjn_df,
                                  forecast_horizon = 90)
ggsave("gcbjn_forecast_3mos.png", plot = GCBJN_forecast)

# 1 year
GCBJN_forecast <-  hotel_forecast(gcbjn_df,
                                  forecast_horizon = 360)
ggsave("gcbjn_forecast_1yr.png", plot = GCBJN_forecast)

#Forecasting for PHEGA hotel--------------------------

# 3 months
PHEGA_forecast <-  hotel_forecast(phega_df,
                                  forecast_horizon = 90)
ggsave("phega_forecast_3mos.png", plot = PHEGA_forecast)

# 1 year
PHEGA_forecast <-  hotel_forecast(phega_df,
                                  forecast_horizon = 360)
ggsave("phega_forecast_1yr.png", plot = PHEGA_forecast)


#Forecasting for UKPIL hotel--------------------------

# 3 months
UKPIL_forecast <-  hotel_forecast(ukpil_df,
                                  forecast_horizon = 90)
ggsave("ukpil_forecast_3mos.png", plot = UKPIL_forecast)


# 1 year
UKPIL_forecast <-  hotel_forecast(ukpil_df,
                                  forecast_horizon = 360)
ggsave("ukpil_forecast_1yr.png", plot = UKPIL_forecast)


