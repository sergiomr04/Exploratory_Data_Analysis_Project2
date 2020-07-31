library(dplyr)
library(ggplot2)

filename <- "exdata_NEI_PM2.5.zip"
# Checking if archieve already exists.
if (!file.exists(filename)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
    download.file(fileURL, filename, method="curl")
}

# Checking if file exists
if (!file.exists("summarySCC_PM25.rds")) { 
    unzip(filename) 
}
#read data
NEI<-readRDS("summarySCC_PM25.rds")
SCC<-readRDS("Source_Classification_Code.rds")
#subset in base a emission
Activity_emision_baltimore<-NEI%>%filter(fips=="24510")%>%
    group_by(year,type)%>%
    summarize(Emissions=sum(Emissions))%>%print

#Total_emision_baltimore<-NEI%>%
#    group_by(year,type)%>%
#    summarize(Emissions=sum(Emissions))%>%print

#plotting
png(filename='plot3.png')
i<-ggplot(Activity_emision_baltimore,aes(factor(year),Emissions,fill=type,label=round(Emissions,2))) +
    geom_col() +
    facet_grid(.~type,scales = "free",space="free") + 
    labs(x="year", y=expression("Total PM"[2.5]*" Emission (Tons)")) + 
    labs(title=expression("PM"[2.5]*" Emissions, Baltimore City 1999-2008 by Source Type"))#+
    #geom_label(aes(fill = type), colour = "white", fontface = "bold")
print(i)
dev.off()

# b_em_plot <- ggplot(data = Activity_emision_baltimore, aes(x = factor(year), y = Emissions, fill = type, colore = "black")) +
#     geom_bar(stat = "identity") + facet_grid(. ~ type) + 
#     xlab("Year") + ylab(expression('PM'[2.5]*' Emission')) +
#     ggtitle("Baltimore Emissions by Source Type") 
# print(b_em_plot)


# ggplot(Activity_emision_baltimore, aes(x=factor(year), y=Emissions, fill=type,label = round(Emissions,2))) +
#     geom_bar(stat="identity") +
#     facet_grid(. ~ type) +
#     xlab("year") +
#     ylab(expression("total PM"[2.5]*" emission in tons")) +
#     ggtitle(expression("PM"[2.5]*paste(" emissions in Baltimore ",
#                                        "City by various source types", sep="")))+
#     geom_label(aes(fill = type), colour = "white", fontface = "bold")
