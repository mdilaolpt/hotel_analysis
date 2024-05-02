# importing packages
import pandas as pd
import sqlite3

# data
# create a dataset from multiple CSV files using a SQL query

# connect to new SQLite database for hotel data
conn = sqlite3.connect('hotel_data.db')

# read CSV files and load them into SQLite as tables
calendar_df = pd.read_csv("data/calendar.csv")
currency_df = pd.read_csv("data/currency.csv")
hotel_details_df = pd.read_csv("data/hotel_details.csv")
metrics_df = pd.read_csv("data/metrics.csv")

calendar_df.to_sql('calendar', conn, index=False, if_exists='replace')
currency_df.to_sql('currency', conn, index=False, if_exists='replace')
hotel_details_df.to_sql('hotel_details', conn, index=False, if_exists='replace')
metrics_df.to_sql('metrics', conn, index=False, if_exists='replace')

# SQL query to join tables
query = """
    SELECT m.*
        , hd.REGION
        , hd.COUNTRY
        , hd.RMS_AVAIL
        , c.EXCH_RATE_AMT
        , cl.CAL_DOW
    FROM metrics m
    LEFT JOIN hotel_details hd ON m.HTL_CD = hd.HTL_CD
    LEFT JOIN currency c ON m.CURR_CD = c.CURR_CD
    LEFT JOIN calendar cl ON m.STY_DT = cl.CAL_DAY_DT
"""
hotel_df = pd.read_sql_query(query, conn)

# additional metrics
hotel_df['CONVERTED_REV'] = hotel_df['RM_REV_AMT_LOC'] / hotel_df['EXCH_RATE_AMT']             #converted revenue to USD (revenue in original curr / exchange rate)
hotel_df['OCCUPANCY'] = hotel_df['RM_NTS'] / hotel_df['RMS_AVAIL'] * 100                      #occupancy rate      (rooms sold / total rooms available)
hotel_df['ADR'] = hotel_df['CONVERTED_REV'] / hotel_df['RM_NTS']                              #average daily rate (revenue / number of room sold) USED CONVERTED_RATE TO STANDARDIZE CURRENCY
hotel_df['REV_PAR'] = hotel_df['CONVERTED_REV'] / hotel_df['RMS_AVAIL']                       #revenue per available room (revenue / total rooms available) USED CONVERTED_RATE TO STANDARDIZE CURRENCY

# end connection
conn.close()

# write the merged hotel_df.csv to the data folder as final table
hotel_df.to_csv('/Users/danielle/hotel_performance_analysis/data/hotel_df.csv', index=False)

# check hotel df
print(hotel_df.head())

# note that in a real project/reporting, this py file should be run whenever data is refreshed/updated so that hotel_df.csv will contain latest datapoints
# for the sake of this project, we'll use this static code :)
