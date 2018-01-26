# Data Science: Exploratory Data Analysis: Week 1: plot1
# Author: Jeff Dillon
# Description: Reads in household power consumption data and generates a histogram
# of Global active power for Jan 1-2, 2007.
library(readr)

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

# open the PNG graphics device
png("plot1.png", width=480, height=480)

# create the histogram
hist(hpc_sample$Global_active_power,
     breaks = 18, 
     main="Global Active Power", 
     xlab="Global Active Power (kilowatts)", 
     ylab="Frequency",
     col="red")

# close the PNG device
dev.off()

# clean up the data.frame
rm(hpc_sample)