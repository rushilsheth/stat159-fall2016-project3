# This script will run a ridge regression

# Load necessary libraries and variables
library (glmnet)
# Load my train and testing data set
load("data/train_test.RData")
# Load scaled-credit data
scaled_client <- read.csv("data/scaled-client.csv")[, -1]



# Now begin ridge regression method

# Create an x and y for glmnet() to input
x <- as.matrix(train_set[,2:9]) 
y <- as.double(train_set$Grad_Rate)

# Ridge regression utilizes a variable lambda which can vary in size, so we make a vector modeling this
grid <- 10^seq(10, -2, length = 100)

ridge_mod = glmnet(model.matrix(Grad_Rate ~ ., train_set)[,-1], train_set$Grad_Rate, alpha=0, lambda= grid)

set.seed (420)

# Create ridge object using glmnet and grid for lambda arguemnet
# Alpha =0 ensures that ridge is used
cv_ridge_models <- cv.glmnet (x,y,alpha =0, lambda = grid, standardize = FALSE, intercept = FALSE)

# Save the output for lambda
lambda_min_ridge <- cv_ridge_models$lambda.min
ridge_coef <- coef(cv_ridge_models, s = lambda_min_ridge)

# Plot ridge output
png("images/Ridge_plot.png")
plot(cv_ridge_models)
dev.off()

# Calculate MSE
ridge_matrix_test <- model.matrix(Grad_Rate ~ ., test_set)[,-1]
ridge_predict <- predict(ridge_mod,newx = ridge_matrix_test, s = lambda_min_ridge)
ridge_MSE <- mean((ridge_predict - test_set$Grad_Rate)^2)

# Find coeff for best value

# Create new x and y variables
full_credit <- as.matrix(scaled_client[ ,2:9])
y_full <- scaled_client$Grad_Rate

ridge_fit <- glmnet(x = full_credit, y = y_full, lambda = lambda_min_ridge,
                    standardize = FALSE, intercept = FALSE, alpha = 0)
ridge_coef_full <- coef(ridge_fit, s = lambda_min_ridge)

# Save data in an Rdata file to be loaded later in the project
save(lambda_min_ridge, cv_ridge_models, ridge_MSE, ridge_coef_full,file = 'data/Ridge.RData')

# Save useful statstics(and labels!) in a text file, to be used in report 
sink('data/Ridge.txt')
cat('Output of Ridge Regression with 10-fold CV on the Full Data Set\n')
print(ridge_fit)
cat('\nRidge MSE of Test Data Set\n')
print(ridge_MSE)
cat('\nMinimum Lambda\n')
print(lambda_min_ridge)
cat('\nCoefficients for Ridge Regression Model on Full Data Set\n')
print(ridge_coef_full)
sink()
