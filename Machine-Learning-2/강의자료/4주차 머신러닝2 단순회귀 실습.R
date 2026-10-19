#데이터 불러오기
train_data <- read.csv("C:/Users/Hoon/Documents/카카오톡 받은 파일/단순회귀분석_데이터셋/simple_train_data.csv")
test_data <- read.csv("C:/Users/Hoon/Documents/카카오톡 받은 파일/단순회귀분석_데이터셋/simple_test_data.csv")
#회귀분석 모델
model <- lm(upper_arm ~ thigh, data = train_data)
summary(model)
#모델 저장
saveRDS(model, "regression_model.rds")
#모델 불러오기
loaded_model <- readRDS("regression_model.rds")
#불러온 모델을 활용한 예측
predicted <- predict(loaded_model, newdata = test_data)
head(predicted)

# 예측 결과와 실제값 비교
results <- data.frame(Actual = test_data$upper_arm, Predicted = predicted)
#RMSE 계산
rmse <- sqrt(mean((results$Actual - results$Predicted)^2))
print(paste("RMSE:", round(rmse, 3)))
