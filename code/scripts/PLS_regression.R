library(pls)

load("data/train_test.RData")
scaled_data <- read.csv("data/scaled-client.csv")[, -1]

test_x = model.matrix(Grad_Rate ~ ., test_set)[,-1]
test_y = test_set$Grad_Rate

set.seed (420)

# Perform ten-fold cross validation on the training data
pls_fit = plsr(Grad_Rate ~ ., data=train_set,scale=TRUE, validation="CV")

# Find the number of components that yields the lowest MSEP
min.comp = which.min(pls_fit$validation$PRESS)

# Save validation plot to png file
png(filename="images/Plsr_validationplot.png")
validationplot(pls_fit, val.type="MSEP")
dev.off()

# Find the test mse
pls_pred = predict(pls_fit, test_x, ncomp=min.comp)
mse = mean((pls_pred-test_y)^2)

# Find the coefficients for the best value of the number of components
pls_out = plsr(Grad_Rate ~ ., data=scaled_data ,scale=TRUE,ncomp=min.comp)
coeff = pls_out$coefficients[, , min.comp]

# Save output objects to RData file
save(pls_fit, min.comp, mse, coeff, file="data/PLSR.RData")

# Write coefficients, best number of components, and mse to a text file
library(pander)
sink("data/PLSR.txt")
pander(coeff)
cat("\nTest MSE:\n")
mse
cat("\nBest Number of Components:\n")
min.comp
sink()