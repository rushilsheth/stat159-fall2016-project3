#Read data and inspect data frame
dat<-read.csv("../../data/client_data.csv",row.names=1)
head(dat)
str(dat)
summary(dat)

#Output enrollment related data to the file
sub_dat<-dat[,12:20]
sink("../../data/eda-output-enroll.txt")
print ('Summary Statistics of Enrollment-related Variables')
summary(sub_dat)
cat("\n\n")

#Correlation Matrix
print("Correlation Matrix")
cat('\n')
#matrix correlation 
cor(sub_dat)
sink()

#save correlation matrix into binary file
matrix<-as.data.frame(cor(sub_dat))
save(matrix,file="../../data/correlation-matrix.RData")


#create histogram for age and average-income variables
png("../../images/EDA/histogram-age.png")
hist(dat$Avg_Age,main="Histogram of Average Age",xlab="Average Age",col="lightblue")

png("../../images/EDA/histogram-income.png")
hist(dat$Avg_Fam_Inc,main="Histogram of Averag Family Income", xlab="Average Family Income",col="lightblue")



#create frequency bar-chart for enrollment ethnicity and gender variables
ethnicity<-c("White","Black","Hispanic","Asian","Other")
avg_per<-c(mean(dat$Enroll_White),mean(dat$Enroll_Black),
mean(dat$Enroll_Hisp),mean(dat$Enroll_Asian),mean(dat$Enroll_Other))
png("../../images/EDA/barplot-enroll-ethnicity.png")
barplot(avg_per,names.arg=ethnicity,main="Barplot of Enrollment Ethnicity",ylim=c(0,0.4), xlab="Ethnicity Breakdown",ylab="Enrollment Rate", col="lightblue")

gender<-c("Men","Women")
avg_per<-c(mean(dat$Enroll_Men),mean(dat$Enroll_Women))
png("../../images/EDA/barplot-enroll-gender.png")
barplot(avg_per,names.arg=gender,main="Barplot of Enrollment Gender",ylim=c(0,1.0),xlab="Gender Breakdown",ylab="Enrollment Rate",col="lightblue")



#Create scatterplot matrix 
png("../../images/EDA/scatterplot-matrix.png")
pairs(~Enroll_White+Enroll_Black+Enroll_Hisp+Enroll_Asian+Enroll_Other+Enroll_Men+Enroll_Women+Avg_Age+
Avg_Fam_Inc+Med_Fam_Inc,data=dat, main="Scatterplot Matrix")
dev.off()





