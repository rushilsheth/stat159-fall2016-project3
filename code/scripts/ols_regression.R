scaled_data <- read.csv("data/scaled-client.csv")[, -1]
# Fit OLS model:
ols_model <- lm(Grad_Rate ~ .,data = scaled_data)
OLS_summary <-summary(ols_model)
ols_mse = mean(OLS_summary$residuals^2)
sink('data/OLS.txt')
cat('OLS model summary \n')
OLS_summary
cat('MSE \n')
ols_mse
sink()

save(OLS_summary,ols_mse, file='data/OLS.RData')
