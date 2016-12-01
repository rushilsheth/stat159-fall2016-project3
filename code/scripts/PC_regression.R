# This script will run a pcr regression -- similar set up to my ridge script

# Load necessary libraries and variables
library (pls)
# Load my train and testing data set
load('data/train_test.RData')
# Load scaled-credit data
scaled_data <- read.csv("data/scaled-client.csv")[, -1]


test_x <- model.matrix(Grad_Rate ~ ., test_set)[,2:9]
test_y <- test_set$Grad_Rate

# Now begin pcr regression method

set.seed (420)

pcr_fit <- pcr(Grad_Rate ~ ., data = train_set, scale = TRUE, validation = 'CV')

# Find min lambda
lambda_min_pcr <- which.min(pcr_fit$validation$PRESS)

# Plot pcr regression
png('images/pcr_validationplot.png')
validationplot(pcr_fit, val.type = 'MSEP')
dev.off()

# Calculate test MSE
pcr_pred <- predict(pcr_fit, ncomp = lambda_min_pcr, newdata = test_set)
pcr_MSE <- mean((pcr_pred - test_y)^2)

# Find coeff for best value 
pcr_full <- pcr(Grad_Rate ~ ., data = scaled_data, ncomp = lambda_min_pcr, validation = 'CV')
pcr_coef_full <- coef(pcr_full)

# Save data in an Rdata file to be loaded later in the project
save(lambda_min_pcr, pcr_fit, pcr_MSE, pcr_coef_full,file = 'data/PCR.RData')

# Save useful statstics(and labels!) in a text file, to be used in report 
sink('data/PCR.txt')
cat('Output of PCR with 10-fold CV on the Full Data Set\n')
print(summary(pcr_fit))
cat('\nMinimum Lambda for PCR\n')
print(lambda_min_pcr)
cat('\nPCR MSE of Test Data Set\n')
print(pcr_MSE)
cat('\nCoefficients of using PCR Model on Full Data Set\n')
print(pcr_coef_full)
sink()