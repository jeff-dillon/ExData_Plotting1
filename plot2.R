# Data Science: Exploratory Data Analysis: Week 1: plot2
# Author: Jeff Dillon
# Description: Reads in household power consumption data and generates a line graph
# of Global active power for Jan 1-2, 2007.
library(readr)
library(lubridate)
library(dplyr)


# load the data from the file in chunks, only taking the rows that match the needed dates
hpc_sample <- read_delim_chunked("household_power_consumption.txt", 
                                 callback = DataFrameCallback$new(
                                     function(x, pos) 
                                         subset(x,Date=="1/2/2007" | Date == "2/2/2007")
                                 ),
                                 col_types ="ccnnnnnnn", 
                                 progress = F, 
                                 chunk_size = 100000, 
                                 col_names = TRUE,
                                 delim=";",
                                 na = c("?"))

# Add the date time column
hpc_sample <- hpc_sample %>% mutate(DateTime = dmy_hms(paste(Date, Time)))

# open the PNG graphics device
png("plot2.png", width=480, height=480)

# create the line chart
plot(hpc_sample$DateTime, 
     hpc_sample$Global_active_power, 
     ylab = "Global Active Power (kilowatts)", 
     xlab = "", 
     type="l")

# close the PNG device
dev.off()

# clean up the data.frame
rm(hpc_sample)
