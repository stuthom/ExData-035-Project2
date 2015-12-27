require(png)
require(dplyr)
# Data for this project is found at https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip
# Download the data file and unzip it
download.file(url="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile="NEI_data.zip", method="libcurl")
unzip("NEI_data.zip")

# We should now have Source_Classification_Code.rds and summarySCC_PM25.rds in the directory

# Read in the 2 files - the first one will take a while
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Sum the pm2.5 emissions by year. Note that I could specify this more
# precisely with a select or similar, but I know from looking at the data
# that all of the Emissions types are PM2.5, so I won't bother as this 
# is intended to be quick & dirty
total_pm25 <- NEI %>% group_by(year) %>% summarise(Total = sum(Emissions))

# Now show the plot. I've scaled the Totals to millions to make it clearer
png(filename="plot1.png")
with(total_pm25, plot(year, Total / 1000000, main="Total PM2.5 Emissions in the United States by Year", 
                      type="b", xlab="Year", ylab="Total PM2.5 Emissions (millions)"))
dev.off()