setwd("F:/202224264_PSH/머신러닝 시험/03.로지스틱회귀분석")

library(GGally)
library(skimr)
library(tidyverse)
library(tidymodels)
library(caret)

df <- read.csv("UniversalBank.csv", header = TRUE, na = ".")
skim(df)

df$Personal.Loan <- ifelse(df$Personal.Loan == 1, "yes", "no")
df$Personal.Loan <- as.factor(df$Personal.Loan)

set.seed(123)
trainIndex <- createDataPartition(df$Personal.Loan, p = 0.8, list = FALSE)
train_data <- df[trainIndex, ]
test_data  <- df[-trainIndex, ]

result1 <- glm(Personal.Loan ~ 1, data = train_data, family = "binomial")
result2 <- glm(Personal.Loan ~ ., data = train_data, family = "binomial")

anova(result1, result2, test = "Chisq")
summary(result2)

tidy_result <- tidy(result2)
tidy_result <- mutate_if(tidy_result, is.numeric, round, 3)
print(tidy_result)

library(car)
library(broom)
library(dplyr)

durbinWatsonTest(result2)

vif(result2)

train_model <- select(train_data, -ID, -ZIP.Code, -Experience, -CD.Account)
result <- glm(Personal.Loan ~ ., data = train_model, family = "binomial")
summary(result)
vif(result)

influencePlot(result)

saveRDS(result, file = "logistic_model.rds")
Load <- readRDS("logistic_model.rds")

tidy_result <- tidy(Load)
tidy_result <- mutate_if(tidy_result, is.numeric, round, 3)
tidy_result

library(pROC)
library(caret)
library(e1071)

test_predictions <- predict(result, newdata = test_data, type = "response")
predicted_class <- ifelse(test_predictions > 0.5, "yes", "no")
predicted_class <- factor(predicted_class, levels = levels(test_data$Personal.Loan))

confusion_matrix <- confusionMatrix(predicted_class, test_data$Personal.Loan,
                                    positive = "yes")
confusion_matrix
confusion_matrix$byClass[c("Precision", "Recall", "F1")]

roc_curve <- roc(test_data$Personal.Loan, test_predictions)
plot(roc_curve)
auc(roc_curve)

df_test <- read.csv("UniversalBank_test.csv", header = TRUE)

new_prob  <- predict(result, newdata = df_test, type = "response")
new_class <- ifelse(new_prob > 0.5, "yes", "no")
data.frame(df_test, prob = round(new_prob, 3), Personal.Loan = new_class)
