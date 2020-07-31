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

#read Data
NEI<-readRDS("summarySCC_PM25.rds")
SCC<-readRDS("Source_Classification_Code.rds")


#only Highway Vehicles
#motor_vehicles <- SCC[grep("Vehicle", SCC$EI.Sector,ignore.case = TRUE),"SCC"]
#motor_vehicles <- SCC[grep("[Vv]ehicle", SCC$EI.Sector),"SCC"]
#motor_vehicles <- SCC[grep("Mobile.*Vehicles", SCC$EI.Sector),"SCC"]

#include Off-highway Vehicle
motor_vehicles <- SCC[grep("Vehicle", SCC$SCC.Level.Two,ignore.case = TRUE),"SCC"]
vehicles_NEI<-subset(NEI,NEI$SCC%in%motor_vehicles)

Vehicles_emision_baltimore<-vehicles_NEI%>%filter(fips=="24510")%>%
    group_by(year)%>%
    summarize(Emissions=sum(Emissions))%>%mutate(city="Baltimore City, MD")%>%
    print

Vehicles_emision_losangeles<-vehicles_NEI%>%filter(fips=="06037")%>%
    group_by(year)%>%
    summarize(Emissions=sum(Emissions))%>%mutate(city="Los Angeles County, CA")%>%
    print
vehicle_emissions <- rbind(Vehicles_emision_baltimore,Vehicles_emision_losangeles)


#plotting
png(filename='plot6.png',width = 640,height = 480)
i<-ggplot(vehicle_emissions,aes(factor(year),Emissions,fill=city,label=round(Emissions,2)))+
    geom_col()+facet_grid(.~city)+
    ylab(expression("total PM "[2.5]*" emissions in tons")) + 
    xlab("year") +
    ggtitle(expression("PM"[2.5]*" Motor Vehicle Source Emissions in Baltimore & LA, 1999-2008"))#+
    #geom_label(aes(fill = city),colour = "white", fontface = "bold")
print(i)
dev.off()

ggplot(vehicle_emissions, aes(x=factor(year), y=Emissions, fill=city,label = round(Emissions,2))) +
    geom_col()+
    #geom_bar(stat="identity") + 
    facet_grid(city~., scales="free") +
    ylab(expression("total PM"[2.5]*" emissions in tons")) + 
    xlab("year") +
    ggtitle(expression("PM"[2.5]*" Motor Vehicle Source Emissions in Baltimore & LA, 1999-2008"))+
    geom_label(aes(fill = city),colour = "white", fontface = "bold")
