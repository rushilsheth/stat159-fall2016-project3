# Read original data in

orig_data <- read.csv("data/orig_data.csv")

# Filter for only CA colleges
cali_data <- orig_data[orig_data$STABBR == 'CA',]

# Filter for Special Focus Four-Year: Arts, Music & Design Schools
cali_art_data <- cali_data[cali_data$CCBASIC == 30,]

#only include certain columns for race, gender, age, income, grad rate for race, gender and age
clean_data <- as.matrix(cali_art_data[c(1:10,293:304,1740:1741,1607,1615:1616,826:827,839:840, 853:854,387,397:408, 291)])

#remove cols: UGDS_WHITENH, UGDS_BLACKNH, UGDS_API, All of the Lo_INC_ENRL_2……, C150_4_UNKN, C150_4_BLACKNH, C150_4_API

rem <- c(20:22, 28:33, 44:46)

clean_data_rm <- clean_data[,-rem]


#combine the enrollment race columns: c(15:19)


Enroll_Other <- as.double(clean_data_rm[,15]) + as.double(clean_data_rm[,16]) +as.double(clean_data_rm[,17]) + as.double(clean_data_rm[,18]) + as.double(clean_data_rm[,19])

#combine the grad race columbs c(30:34)

Grad_Rate_Other_columns <- cbind(as.double(clean_data_rm[,30]), as.double(clean_data_rm[,31]), as.double(clean_data_rm[,32]), as.double(clean_data_rm[,33]), as.double(clean_data_rm[,34]))

Grad_Rate_Other <- .rowSums(Grad_Rate_Other_columns,33,5, na.rm = TRUE)


client_data <- data.frame(clean_data_rm[,c(1:14)], Enroll_Other, clean_data_rm[,c(20:29)], Grad_Rate_Other, clean_data_rm[,35])

header <- c("UNIT_ID", "OPE_ID", "OPE_ID6", "INST", "City", "State", "Zip_Code", "Accreditor", "URL_main", "URL_net_price", "Enroll_White", "Enroll_Black", "Enroll_Hisp", "Enroll_Asian", "Enroll_Other", "Enroll_Men", "Enroll_Women", "Avg_Age", "Avg_Fam_Inc", "Med_Fam_Inc", "Grad_Rate", "Grad_Rate_White", "Grad_Rate_Black", "Grad_Rate_Hisp", "Grad_Rate_Asian", "Grad_Rate_Other", "Total_enroll")

colnames(client_data) <- header

#remove schools that don't have any data
client_data<-client_data[-c(2,3),]

write.csv(client_data, file = "data/client_data.csv")

