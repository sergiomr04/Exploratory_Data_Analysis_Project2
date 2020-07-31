library(dplyr)
library(ggplot2)

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

#differet ways to create subset
combustion_coal <- SCC[grep("Fuel Comb.*Coal", SCC$EI.Sector),"SCC"]
#selecciona todas las columnas
coal_SCC <- SCC[grep("[Cc][Oo][Aa][Ll]", SCC$EI.Sector),]
#generate a subset
Coal_NEI<-subset(NEI,NEI$SCC%in%combustion_coal)
#Coal_NEI2<-NEI[NEI$SCC%in%coal_SCC$SCC,]
Total_emision<-Coal_NEI%>%group_by(year)%>%
    summarize(Emissions=sum(Emissions))%>%print
color_range <- colorRampPalette(c("red","yellow"))

#plotting
png(filename='plot4.png')
i<-ggplot(Total_emision,aes(factor(year),Emissions/10^5,label=round(Emissions/10^5,4))) +
    geom_col(fill=color_range(4)) +
    labs(x="year", y=expression("Total PM "[2.5]*" Emission (10"^6*" Tons)")) + 
    labs(title=expression("PM"[2.5]*" Coal Combustion Source Emissions Across US from 1999-2008"))+
    geom_label(colour = "Black", fontface = "bold")
print(i)
dev.off()
