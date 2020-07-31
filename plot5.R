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


#only Highway Vehicles
motor_vehicles <- SCC[grep("Vehicle", SCC$EI.Sector,ignore.case = TRUE),"SCC"]
motor_vehicles <- SCC[grep("[Vv]ehicle", SCC$EI.Sector),"SCC"]
motor_vehicles <- SCC[grep("Mobile.*Vehicles", SCC$EI.Sector),"SCC"]

#include Off-highway Vehicle
motor_vehicles <- SCC[grep("Vehicle", SCC$SCC.Level.Two,ignore.case = TRUE),"SCC"]
vehicles_NEI<-subset(NEI,NEI$SCC%in%motor_vehicles)

Vehicles_emision_baltimore<-vehicles_NEI%>%filter(fips=="24510")%>%
    group_by(year)%>%
    summarize(Emissions=sum(Emissions))%>%print

color_range <- colorRampPalette(c("blue","gray"))


#plotting
png(filename='plot5.png',width = 640,height = 480)
i<-ggplot(Vehicles_emision_baltimore,aes(factor(year),Emissions,label=round(Emissions,2))) +
    geom_col(fill=color_range(4)) +
    labs(x="year", y=expression("Total PM "[2.5]*" Emission (Tons)")  ) + 
    labs(title=expression("PM"[2.5]*" Motor Vehicle Source Emissions in Baltimore from 1999-2008"))+
    geom_label(colour = "Black", fontface = "bold")
print(i)
dev.off()
