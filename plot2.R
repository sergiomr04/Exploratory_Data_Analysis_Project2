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
#read Data
NEI<-readRDS("summarySCC_PM25.rds")
SCC<-readRDS("Source_Classification_Code.rds")
#create subset
Total_emision_baltimore<-NEI%>%filter(fips=="24510")%>%
    group_by(year)%>%
    summarize(Emissions=sum(Emissions))
#balti<-subset(NEI,fips==24510,select = c(year,Emissions))
#Total_bal<-with(balti,tapply(balti$Emissions, as.factor(balti$year), sum))
#total_annual_emissions <- aggregate(Emissions ~ year, balti, FUN = sum)

#plotting
color_range <- 2:5
png(filename='plot2.png')
x<-barplot(height = Total_emision_baltimore$Emissions
           , names.arg = Total_emision_baltimore$year
           , xlab = "Years", ylab = expression("Emissions Tons")
           , col = color_range, ylim = c(0,3800)
           , main = expression('Annual Emission PM'[2.5]*' in Baltimore City-MD'))
text(x =x , y = round(Total_emision_baltimore$Emissions,3)
     , label = round(Total_emision_baltimore$Emissions,3)
     , pos = 3, cex = 0.8, col = "black")
dev.off()