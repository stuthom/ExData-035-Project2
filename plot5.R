require(lattice)
require(dplyr)

# Data for this project is found at https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip
# Download the data file and unzip it
download.file(url="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile="NEI_data.zip", method="libcurl")
unzip("NEI_data.zip")

# We should now have Source_Classification_Code.rds and summarySCC_PM25.rds in the directory

# Read in the 2 files - the first one will take a while
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Get any SCC data relating to motor vehicles (I'm using a broad definition of On-Road, which covers trucks, motorcycles and cars).
# Also get the NEI data for Baltimore only, then merge
scc_motorvehicles <- SCC[SCC$EI.Sector %in% grep("on-road", SCC_sectors, ignore.case=TRUE, value=TRUE), ]
baltimore_pm25 <- NEI[NEI$fips=="24510", ]

q5_data <- merge(baltimore_pm25, scc_motorvehicles, by="SCC")

# Now summarise all data across years and sectors
q5_years <- q5_data %>% group_by(year) %>% summarise(Total.Emissions = sum(Emissions))

# Now show the plot. I've adjusted the y-axis limits to values which will show the trend less dramatically
png(filename="plot5.png")
with(q5_years, plot(year, Total.Emissions, 
                           main="Total PM2.5 Emissions from Motor Vehicl Sources in Baltimore by Year",
                           type="b", 
                           xlab="Year", 
                           ylab="Total PM2.5 Emissions", 
                           ylim=c(100,450)))

# Calculate the linear trend for this
linear <- lm(Total.Emissions~year, q5_years)

# Now plot the trend line and add a legend for clarity
abline(coef=linear$coefficients, col="blue", lty=2, lwd=2)
legend("topright", c("Meausrements", "Linear trend"), col=c("black", "blue"), pch=c(1,-1), lty=c(-1,2), lwd=2)

# Output to our PNG file
dev.off()