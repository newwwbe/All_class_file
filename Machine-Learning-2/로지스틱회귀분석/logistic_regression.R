# =============================================================
# 머신러닝2 - 로지스틱 회귀분석 (UniversalBank 개인대출 예측)
# 강의자료: 강의자료/4. 머신러닝2_로지스틱회귀분석.pdf
# 데이터 : 데이터자료/UniversalBank.csv, 데이터자료/UniversalBank_test.csv
# =============================================================

# 처음 한 번만 설치
# install.packages(c("GGally", "skimr", "tidyverse", "tidymodels", "caret",
#                    "car", "broom", "pROC", "e1071"))

library(GGally)
library(skimr)
library(tidyverse)
library(tidymodels)
library(caret)

# CSV가 있는 폴더로 작업 경로 지정
# setwd("F:/202224264_PSH/머신러닝 시험/03.로지스틱회귀분석")

# -------------------------------------------------------------
# 1. 데이터 불러오기 / 전처리
# -------------------------------------------------------------
df <- read.csv("UniversalBank.csv", header = TRUE, na = ".")
skim(df)

# 종속변수(Personal.Loan): 0/1 숫자 -> "no"/"yes" 범주형(factor)
# factor여야 createDataPartition이 yes/no 비율을 유지해서 나눔(층화추출)
df$Personal.Loan <- ifelse(df$Personal.Loan == 1, "yes", "no")
df$Personal.Loan <- as.factor(df$Personal.Loan)

# -------------------------------------------------------------
# 2. 학습/테스트 데이터 분할 (8:2)
# -------------------------------------------------------------
set.seed(123)
trainIndex <- createDataPartition(df$Personal.Loan, p = 0.8, list = FALSE)
train_data <- df[trainIndex, ]
test_data  <- df[-trainIndex, ]

# -------------------------------------------------------------
# 3. 로지스틱 회귀모델 (family = "binomial")
# -------------------------------------------------------------
# result1: 절편만 있는 모델 / result2: 모든 변수를 넣은 모델
result1 <- glm(Personal.Loan ~ 1, data = train_data, family = "binomial")
result2 <- glm(Personal.Loan ~ ., data = train_data, family = "binomial")

# 모델 전체가 유의한가? (p < 0.05 이면 변수를 넣은 모델이 유의함)
anova(result1, result2, test = "Chisq")
summary(result2)

# tidy(): 회귀계수 결과를 표(tibble)로 정리 / 숫자는 소수 셋째 자리 반올림
tidy_result <- tidy(result2)
tidy_result <- mutate_if(tidy_result, is.numeric, round, 3)
print(tidy_result)

# -------------------------------------------------------------
# 4. 가정 검정
# -------------------------------------------------------------
library(car)
library(broom)
library(dplyr)

# 독립성 검정 (Durbin-Watson, 2에 가까우면 독립)
durbinWatsonTest(result2)

# 다중공선성(변수의 중복성): VIF가 10 이상이면 문제
# Age와 Experience는 상관계수가 약 0.99라 VIF가 매우 큼
vif(result2)

# 다중공선성 위배 변수 제거 후 다시 분석
#  - ID, ZIP.Code : 의미 없는 식별번호
#  - Experience   : Age와 거의 같은 정보(다중공선성)
#  - CD.Account   : 새 데이터(UniversalBank_test.csv)에 없는 열이라 예측에 쓸 수 없음
#  (formula에 "- ID"로 쓰면 새 데이터에도 ID 열이 있어야 해서 에러가 남 -> 열 자체를 빼고 학습)
train_model <- select(train_data, -ID, -ZIP.Code, -Experience, -CD.Account)
result <- glm(Personal.Loan ~ ., data = train_model, family = "binomial")
summary(result)
vif(result)

# 이상치/영향점 확인 (Cook's distance, glm에도 사용 가능)
influencePlot(result)

# -------------------------------------------------------------
# 5. 모델 저장 / 불러오기
# -------------------------------------------------------------
saveRDS(result, file = "logistic_model.rds")
Load <- readRDS("logistic_model.rds")

tidy_result <- tidy(Load)
tidy_result <- mutate_if(tidy_result, is.numeric, round, 3)
tidy_result
# 참고: 선형회귀와 달리 tidy 결과의 estimate는 로그 오즈(log odds) 값
#       exp(estimate) = 오즈비(odds ratio)

# -------------------------------------------------------------
# 6. 모델 평가 (Confusion Matrix, ROC, AUC)
# -------------------------------------------------------------
library(pROC)
library(caret)
library(e1071)

# 테스트 데이터 예측 확률 -> 임계값 0.5 기준으로 yes/no 분류
test_predictions <- predict(result, newdata = test_data, type = "response")
predicted_class <- ifelse(test_predictions > 0.5, "yes", "no")
predicted_class <- factor(predicted_class, levels = levels(test_data$Personal.Loan))

# 혼동행렬 (positive = "yes" 로 지정해야 대출 승인 기준 정밀도/재현율이 나옴)
confusion_matrix <- confusionMatrix(predicted_class, test_data$Personal.Loan,
                                    positive = "yes")
confusion_matrix
confusion_matrix$byClass[c("Precision", "Recall", "F1")]
# Accuracy : 전체 중 맞춘 비율
# Kappa    : 1에 가까울수록 좋음. 한쪽 클래스가 많을 때 우연히 맞춘 건지 판단
# Mcnemar's Test P-Value : 0.05보다 크면 오류가 대칭적

# ROC 커브와 AUC (0.9 이상 매우 좋음)
roc_curve <- roc(test_data$Personal.Loan, test_predictions)
plot(roc_curve)
auc(roc_curve)

# -------------------------------------------------------------
# 7. 새로운 데이터에 모델 적용
# -------------------------------------------------------------
# UniversalBank_test.csv에는 ID, CD.Account, Personal.Loan 열이 없음
df_test <- read.csv("UniversalBank_test.csv", header = TRUE)

new_prob  <- predict(result, newdata = df_test, type = "response")
new_class <- ifelse(new_prob > 0.5, "yes", "no")
data.frame(df_test, prob = round(new_prob, 3), Personal.Loan = new_class)
