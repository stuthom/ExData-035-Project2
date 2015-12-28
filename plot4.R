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

# Get any SCC data relating to coal (where EI.Sector contains "coal" in the value) before merging the data sets
scc_coal <- SCC[SCC$EI.Sector %in% grep("coal", SCC_sectors, ignore.case=TRUE, value=TRUE), ]
q4_data <- merge(NEI, scc_coal, by="SCC")

# Now summarise all data across years and sectors
q4_years <- q4_data %>% group_by(year, EI.Sector) %>% summarise(Total.Emissions = sum(Emissions))

# Now plot it
png(filename="plot4.png")
xyplot(Total.Emissions ~ year | EI.Sector, data=q4_years, layout=c(3,1), type=c("p", "r"))
dev.off()

