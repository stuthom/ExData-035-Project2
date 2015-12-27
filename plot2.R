# Data for this project is found at https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip
# Download the data file and unzip it
download.file(url="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile="NEI_data.zip", method="libcurl")
unzip("NEI_data.zip")

# We should now have Source_Classification_Code.rds and summarySCC_PM25.rds in the directory

# Read in the 2 files - the first one will take a while
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Load dplyr package to simplify the sum
require(dplyr)

# Sum the pm2.5 emissions by year. Note that I could specify this more
# precisely with a select or similar, but I know from looking at the data
# that all of the Emissions types are PM2.5, so I won't bother as this 
# is intended to be quick & dirty
baltimore_pm25 <- NEI[NEI$fips=="24510", ]
baltimore_years <- baltimore_pm25 %>% group_by(year) %>% summarise(Total = sum(Emissions))

# Now show the plot. I've adjusted the y-axis limits to values which will show the trend less dramatically
png(filename="plot2.png")
with(baltimore_years, plot(year, Total, 
                           main="Total PM2.5 Emissions in Baltimore by Year",
                           type="b", 
                           xlab="Year", 
                           ylab="Total PM2.5 Emissions", 
                           ylim=c(1000,3600)))

# Calculate the linear trend for this
linear <- lm(Total~year, baltimore_years)

# Now plot the trend line and add a legend for clarity
abline(coef=linear$coefficients, col="blue", lty=2, lwd=2)
legend("topright", c("Meausrements", "Linear trend"), col=c("black", "blue"), pch=c(1,-1), lty=c(-1,2), lwd=2)

# Output to our PNG file
dev.off()