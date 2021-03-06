# Data Science: Exploratory Data Analysis: Week 1: plot3
# Author: Jeff Dillon
# Description: Reads in household power consumption data and generates a line graph
# of energy sub metering for Feb 1-2, 2007.

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
png("plot3.png", width=480, height=480)

# create the line chart
plot(hpc_sample$DateTime, 
     hpc_sample$Sub_metering_1, 
     ylab = "Energy Sub Metering", 
     xlab = "", 
     type="l")
lines(hpc_sample$DateTime, hpc_sample$Sub_metering_2, col="red", type="l", lty=1, lwd=1)
lines(hpc_sample$DateTime, hpc_sample$Sub_metering_3, col="blue", type="l", lty=1, lwd=1)
legend("topright",legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col=c("black","red","blue"),lty=c(1,1,1))

# close the PNG device
dev.off()

# clean up the data.frame
rm(hpc_sample)