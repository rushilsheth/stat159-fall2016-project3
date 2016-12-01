#This script will pre-model the data and standardize the variables
#specifically make the data ready to be dealt with glmnet() function


#load the data
client <- read.csv("data/client_data.csv")
client_quant <- client[c(12:24,36,26)]

#Removing the schools whose graduation rates are unavaiable (NULL values)
client_quant <- client_quant[!(client_quant$Grad_Rate == "NULL"), ]

#Adding up ethnicity proportions to reduce columns needed for the model for clarity purposes
client_quant$Enroll_Other <- client_quant[5][[1]]+client_quant[6][[1]]+
  client_quant[7][[1]]+client_quant[8][[1]]+client_quant[9][[1]]
#Now the rows that won't be needed for the regression can be removed
#It's essential to remove at least one column from categories of columns that depend on each other (for exmaple: ethnicity and gender)

client_quant_model = client_quant[c(1:4, 11:15)]

#Since all the variables are quantitative, we need not trasnform them into dummy variables
#first transform each categorical variable into dummy variables
#We need to mean center and standardize
temp_client_quant <- model.matrix(Grad_Rate ~ ., data = client_quant_model)
new_client_quant <- temp_client_quant[ ,-1]
new_client_quant <- cbind(temp_client_quant[ ,-1], 
                          Grad_Rate = as.numeric(as.character(client_quant_model$Grad_Rate)))

#scaling and centering
scaled_client_quant <- scale(new_client_quant, center = TRUE, scale = TRUE)

#export scaled data
write.csv(scaled_client_quant, file = "data/scaled-client.csv")