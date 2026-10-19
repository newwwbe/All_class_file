install.packages("rstatix") #통계 테스트
install.packages("skimr") #데이터의 흐름 요약
library(rstatix)
library(skimr)
#데이터 불러오기
df <- read.csv("C:/Users/USER/Downloads/Auto.csv", header = TRUE, stringsAsFactors = TRUE)
skim(df)
#결측값 제거
df <- na.omit(df)
#불필요 변수 제거
df <- select(df, -c(name)) #하나면 제거(순수한 열 이름만 적기)
df <- dplyr::select(df, -c(name, origin)) #여러 개 제거
skim(df)

str(df)
df$horsepower <- as.numeric(as.character(df$horsepower))
df <- na.omit(df)
#다중회귀분석
result <- lm(df$mpg ~ ., data = df)
result1 <- lm(df$mpg ~ 1, data = df) # 다른 변수 고려 X(단순 평균으로 예측)
#ANOVA분석을 활용해 두 집단의 의미있는 차이가 있는지 확인(잔차제곱합 차이의 검증)
anova_result <- anova(result1, result)
print(anova_result)



#회귀모델
summary(result)
#모델 저장
saveRDS(result, "regression_model.rds")
#모델 불러오기
loaded_model <- readRDS("regression_model.rds")


#데이터를 CSV에서 불러오기
new_data <- read.csv("C:/Users/USER/Downloads/Auto.csv")
skim(new_data)
str(new_data)
new_data$horsepower <- as.numeric(as.character(new_data$horsepower))
new_data <- na.omit(new_data)
#모델에 새로운 데이터 추가
predicted<- predict(loaded_model, newdata = new_data)
head(predicted)
#예측 결과 출력 
results <- data.frame(new_data, Predicted = predicted)

#RMSE 계산
rmse <- sqrt(mean((results$mpg- results$Predicted)^2))
print(paste("RMSE:", round(rmse, 3)))

#등분산성 : p>0.05보다 크면, 등분산성 가정을 유지 반대는 이분산성
library(lmtest)
bptest(result)

#독립성 : p>0.05보다 크면 잔차의 독립성을 가짐
library(car)
durbinWatsonTest(result)

#정규성 : p>0.05보다 크면 귀무가설 채택(정규성이 있음)
shapiro_test(result$residuals)

#4개의 조건에 대한 그래프를 모두 보는 방법
opar <- par(no.readonly = TRUE)  # 그래프가 들어갈 Window 생성
par(mfrow = c(2, 2))  # 그래프가 들어갈 공간 생성 2X2
plot(result)  # 그래프 결과 도출
par(opar)  # 그래픽 매개변수 복원

#이상치검정 : cook's D 값이 높으면 문제
#세 기준에서(StudRes, Hat CookD) 상위 3개를 각각 뽑아 합친 것
cand <- influencePlot(result, id = list(n = 3))
mf <- model.frame(result) # 모형에 실제로 쓰인 데이터 (결측 제외된 상태)
z  <- round(scale(mf[sapply(mf, is.numeric)]), 1)
rownames(z) <- rownames(mf) # 행 이름을 다시 붙임
cbind(round(cand, 2), z[rownames(cand), ])

#이상치 제거
out_rows <- c("14","29") #확인 후 직접 입력
df2 <- df[!rownames(df) %in% out_rows, ]
#이상치가 제거된 데이터로 다시 분석 및 그래프 추출
result2 <- lm(mpg ~ ., data = df2)
cand <- influencePlot(result2, id = list(n = 3))
#max Cook's D < 0.5 → 영향점 없음, 0.5~1 → 확인, > 1 → 영향점
max(cooks.distance(result2))

#다중공선성(변수의 중복성) : 10이상 GVIF^(1/(2*DF))
vif_values <- vif(result)
print(vif_values)
#그래프와 상관계수를 그려주는 것이 좋을거 같음
selected_predictors <- names(vif_values[vif_values > 7])  #서로가 영향을 주는 
#변수 추출 후 임의로 제거 필요
print(selected_predictors) 

# AIC(Akaike information criterion): AIC값이 줄어들면 그 변수는 의미가 있음
# library(MASS)로 불러오지 않고 MASS::stepAIC로 호출 (select 충돌 방지)

# 후진소거법
result_bk <- lm(mpg ~ ., data = df)
Df_fit_bk <- MASS::stepAIC(result_bk, direction = "backward", trace = TRUE)

# 단계적선택법
Df_fit_st <- MASS::stepAIC(result_bk, direction = "both", trace = TRUE)

# 전진선택법
result_fw <- lm(mpg ~ 1, data = df)
Df_fit_fw <- MASS::stepAIC(result_fw,
                           direction = "forward",
                           scope = formula(result_bk),  # 전체 변수 모형 = 위의 backward 모형
                           trace = TRUE)

# 최종 선택된 모형 확인
summary(Df_fit_bk)
summary(Df_fit_st)
summary(Df_fit_fw)
