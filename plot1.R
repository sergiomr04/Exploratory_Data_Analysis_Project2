library(dplyr)

filename <- "exdata_NEI_PM2.5.zip"
# Checking if archieve already exists.
if (!file.exists(filename)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
    download.file(fileURL, filename, method="curl")
}

# Checking if folder exists
if (!file.exists("summarySCC_PM25.rds")) { 
    unzip(filename) 
}
#read data
NEI<-readRDS("summarySCC_PM25.rds")
SCC<-readRDS("Source_Classification_Code.rds")
#differet ways to create the subset
Total<-with(NEI,tapply(NEI$Emissions, as.factor(NEI$year), sum))
total_annual_emissions <- aggregate(Emissions ~ year, NEI, FUN = sum)
Total_emision<-NEI%>%group_by(year)%>%summarize(Emissions=sum(Emissions))%>%print
#plotting
png(filename='plot1.png',width = 640,height = 480)
color_range <- colorRampPalette(c("blue","green"))
par(mar = c(4, 5.5, 2, 1), oma = c(0, 0, 2,0))
x<-barplot(height = Total/10^6
        , names.arg = names(Total)
        , xlab = "Years", ylab = expression("Emissions (10"^6*" Tons)")
        , col = color_range(4), ylim=c(0,8.5)
        , main = expression('Annual Emission PM'[2.5]*' from 1999 to 2008'))
text(x =x , y = round(Total/10^6,4)
     , label = round(Total/10^6,4)
     , pos = 3, cex = 0.8, col = "black")
dev.off()

