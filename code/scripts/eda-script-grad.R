#Read data and filter schools that don't have complete graduation rate data
dat<-read.csv("../../data/client_data.csv",row.names=1)
dat[dat=="NULL"]<-NA
dat<-dat[complete.cases(dat),]


#output summary statistics to file and convert factor columns to numerical columns 
sub_dat<-dat[,21:26]
for (i in 1:6){
  sub_dat[,i]<-as.numeric(as.character(sub_dat[,i]))
}

sink("../../data/eda-output-grad.txt")
print("Summary Statistics of Grad-related Variables")
cat("\n\n")
summary(sub_dat)
sink()



#create frequency bar-chart for grad ethnicity 
ethnicity<-c("Total","White","Black","Hispanic","Asian","Other")
avg_per<-c(mean(sub_dat$Grad_Rate),mean(sub_dat$Grad_Rate_White),mean(sub_dat$Grad_Rate_Black),mean(sub_dat$Grad_Rate_Hisp),
mean(sub_dat$Grad_Rate_Asian),mean(sub_dat$Grad_Rate_Other))
png("../../images/EDA/barplot-grad-ethnicity.png")
barplot(avg_per,names.arg=ethnicity,xlab="Ethnicity Breakdown",ylab="Grad Rate",ylim=c(0,0.6),main="Barplot of
Graduation Ethnicity",col="lightblue")

dev.off()
