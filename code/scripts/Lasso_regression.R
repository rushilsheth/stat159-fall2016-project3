library(glmnet)

load("data/train_test.RData")
scaled_data <- read.csv("data/scaled-client.csv")[, -1]

scaled_x = model.matrix(Grad_Rate ~ ., scaled_data)[,-1]
scaled_y = scaled_data$Grad_Rate
test_x = model.matrix(Grad_Rate ~ ., test_set)[,-1]
test_y = test_set$Grad_Rate
train_x = model.matrix(Grad_Rate ~ ., train_set)[,-1]
train_y = train_set$Grad_Rate
lasso.grid = 10^seq(10,-2,length=100)

lasso_mod = glmnet(train_x, train_y, alpha=1, lambda= lasso.grid)

set.seed (420)

#Cross-Validation
cv_out = cv.glmnet(train_x, train_y, alpha=1, 
                   intercept=FALSE, standardize=FALSE, lambda= lasso.grid)

# Best lambda value
best_lambda = cv_out$lambda.min

# Save plot for cross-validation errors in terms of the tuning parameter (lambda)
png(filename="images/Lasso_plot.png", width = 800, height = 600)
plot(cv_out)
dev.off()

# Calculate test values given the best lambda
lasso_predict = predict(lasso_mod, s = best_lambda, newx=test_x)

# Mean squared error for the test values
test_mse = mean((lasso_predict-test_y)^2)

# Refit the lasso model on the whole data set
lasso_out = glmnet(scaled_x, scaled_y, alpha=1, lambda=best_lambda)

# Determine the coefficients given the best value of lambda
lasso_coef = predict(lasso_out,type="coefficients",s=best_lambda)[1:9,]

# Save cross validation output, best lambda, mse, and coefficients to RData file
save(cv_out, best_lambda, test_mse, lasso_coef, file="data/Lasso.RData")

# Write coefficients, best lambda, and mse to a text file
library(pander)
sink("data/Lasso.txt")
pander(lasso_coef)
"TestMSE:"
test_mse
"Best Lambda:"
best_lambda
sink()