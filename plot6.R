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

# Get any SCC data relating to motor vehicles (I'm using a broad definition of On-Road, which covers trucks, motorcycles and cars).
# Also get the NEI data for Baltimore only, then merge
scc_motorvehicles <- SCC[SCC$EI.Sector %in% grep("on-road", SCC_sectors, ignore.case=TRUE, value=TRUE), ]
bla_pm25 <- NEI[NEI$fips=="24510" || NEI$fips=="06037", ]

q6_data <- merge(bla_pm25, scc_motorvehicles, by="SCC")

# Now summarise all data across years and sectors
q6_years <- q6_data %>% group_by(City, year) %>% summarise(Total.Emissions = sum(Emissions))

# Now show the plot. I've adjusted the y-axis limits to values which will show the trend less dramatically
png(filename="plot6.png")
qplot(year, Total.Emissions, data=q6_years, color=City) + 
  geom_line(lwd=2) + 
  facet_grid(~City) + 
  theme(legend.position = "none") + 
  geom_smooth(method="lm", se=FALSE, color="black", lty=2) + 
  labs(title="PM2.5 Emissions from Motor Vehicles")

# Output to our PNG file
dev.off()