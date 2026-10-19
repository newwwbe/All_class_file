#데이터 불러오기
train_data <- read.csv("C:\\Users\\USER\\Downloads\\archive (2)\\sony_stock_data.csv")

#산점도
library(ggplot2)

ggplot(train_data, aes(x = Open, y = Close)) +
  geom_point(alpha = 0.7) +
  labs(title = "종가 vs 시가 산점도",
       x = "시가",
       y = "종가") +
  theme_minimal()

#회귀모델
model <- lm(formula = Open ~ Close, data = train_data)
summary(model)

#잔차
residuals(model)
