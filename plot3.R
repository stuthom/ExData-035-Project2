require(png)
require(dplyr)
require(ggplot2)

# Data for this project is found at https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip
# Download the data file and unzip it
download.file(url="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile="NEI_data.zip", method="libcurl")
unzip("NEI_data.zip")

# We should now have Source_Classification_Code.rds and summarySCC_PM25.rds in the directory

# Read in the 2 files - the first one will take a while
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Get the pm2.5 emissions for Baltimore.
baltimore_pm25 <- NEI[NEI$fips=="24510", ]

# Merge with the SCC dataset so we can get the different types in this analysis
baltimore_SCC <- merge(baltimore_pm25, SCC, by="SCC")

# When I ran table(baltimore_SCC$Data.Category) I got the results below
# Results:
#####
# Biogenic Event Nonpoint Nonroad Onroad    Point 
# 0        1     161      396     1119      419
###
# The question explicitly names the 4 types (point, nonpoint, onroad, nonroad) so I am explictly pulling only those values relating 
# to the question, noting that the Event reading relates to a Bushfire event, and would also not be indicative of a trend as a once-off event
points_of_interest <- c("Nonpoint", "Nonroad", "Onroad", "Point")
q3_data <- baltimore_SCC[baltimore_SCC$Data.Category %in% points_of_interest, ]

# Sum across the years & types
q3_years <- q3_data %>% group_by(year, Data.Category) %>% summarise(Total = sum(Emissions))

# Now draw the plot. I'll show the 4 types separately as it will make it much easier to see
png(filename="plot3.png", width=760, height=480, units="px")
qplot(year, Total, data=q3_years, color=Data.Category, facets = .~Data.Category) + geom_smooth(method="lm")
dev.off()
