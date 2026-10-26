packages <- c("rstatix", "skimr", "dplyr", "car", "lmtest", "ggplot2", "MASS")
new_pkgs <- packages[!(packages %in% installed.packages()[, "Package"])]
if (length(new_pkgs) > 0) install.packages(new_pkgs)

library(rstatix)
library(skimr)
library(dplyr)
library(car)
library(lmtest)
library(ggplot2)

file_path <- "C:/Users/Hoon/Downloads/Auto.csv"

df <- read.csv(file_path, header = TRUE, stringsAsFactors = TRUE)
skim(df)

df <- dplyr::select(df, -c(origin, name))
df$horsepower <- as.numeric(as.character(df$horsepower))
df <- na.omit(df)
skim(df)

result  <- lm(mpg ~ ., data = df)
result1 <- lm(mpg ~ 1, data = df)
print(anova(result1, result))
summary(result)

vif_values <- vif(result)
print(vif_values)

df2 <- dplyr::select(df, -c(cylinders, displacement, horsepower, acceleration))
skim(df2)

result2 <- lm(mpg ~ ., data = df2)
summary(result2)
print(vif(result2))

result_bk <- lm(mpg ~ ., data = df)
result_fw <- lm(mpg ~ 1, data = df)

fit_bk <- MASS::stepAIC(result_bk, direction = "backward", trace = TRUE)
fit_fw <- MASS::stepAIC(result_fw, direction = "forward",
                        scope = formula(result_bk), trace = TRUE)

summary(fit_bk)
summary(fit_fw)

final <- result2

diag_df <- data.frame(
  Fitted    = fitted(final),
  Residuals = resid(final)
)
diag_df$StdResid <- sqrt(abs(rstandard(final)))

p1 <- ggplot(diag_df, aes(Fitted, Residuals)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "loess", se = FALSE, color = "blue") +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
  labs(title = "Residuals vs Fitted", x = "Fitted", y = "Residuals") +
  theme_minimal()
print(p1)

p2 <- ggplot(diag_df, aes(Fitted, StdResid)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "loess", se = FALSE, color = "blue") +
  labs(title = "Scale-Location", x = "Fitted", y = "sqrt(|Std Residuals|)") +
  theme_minimal()
print(p2)

print(bptest(final))
print(durbinWatsonTest(final))
print(shapiro_test(resid(final)))

opar <- par(no.readonly = TRUE)
par(mfrow = c(2, 2))
plot(final)
par(opar)

cand <- influencePlot(final, id = list(n = 3))
mf <- model.frame(final)
z  <- round(scale(mf[sapply(mf, is.numeric)]), 1)
rownames(z) <- rownames(mf)
print(cbind(round(cand, 2), z[rownames(cand), ]))
print(max(cooks.distance(final)))

predicted <- predict(final, newdata = df2)
rmse <- sqrt(mean((df2$mpg - predicted)^2))
print(paste("RMSE:", round(rmse, 3)))

set.seed(123)
idx <- sample(1:nrow(df2), size = 0.7 * nrow(df2))
train <- df2[idx, ]
test  <- df2[-idx, ]

model_tr <- lm(mpg ~ weight + year, data = train)
pred <- predict(model_tr, newdata = test)
test_rmse <- sqrt(mean((test$mpg - pred)^2))
print(paste("Test RMSE:", round(test_rmse, 3)))

saveRDS(final, "regression_model.rds")
loaded_model <- readRDS("regression_model.rds")

new_path <- "C:/Users/Hoon/Downloads/Auto_test.csv"
new_data <- read.csv(new_path, header = TRUE, stringsAsFactors = TRUE)
skim(new_data)
str(new_data)

new_data$horsepower <- as.numeric(as.character(new_data$horsepower))
new_data <- na.omit(new_data)

new_pred <- predict(loaded_model, newdata = new_data)
head(new_pred)

new_results <- data.frame(Actual = new_data$mpg, Predicted = new_pred)
head(new_results)

new_rmse <- sqrt(mean((new_results$Actual - new_results$Predicted)^2))
print(paste("New data RMSE:", round(new_rmse, 3)))

new_data$Predicted <- new_pred
write.csv(new_data, "prediction_result.csv", row.names = FALSE)

out_rows <- c("323", "394")
df3 <- df2[!rownames(df2) %in% out_rows, ]
nrow(df2)
nrow(df3)

result4 <- lm(mpg ~ weight + year, data = df3)
summary(result4)
cand4 <- influencePlot(result4, id = list(n = 3))
print(max(cooks.distance(result4)))

result3 <- lm(log(mpg) ~ weight + year, data = df2)
summary(result3)

print(bptest(result3))
print(durbinWatsonTest(result3))
print(shapiro_test(resid(result3)))

par(mfrow = c(2, 2))
plot(result3)
par(opar)
