# =====================================================================
# Auto 데이터 다중회귀분석: 연비(mpg) 예측
# 처음 실행하는 컴퓨터 기준 (패키지 설치부터 전부 포함)
# =====================================================================

# 0. 패키지 설치 및 불러오기 ------------------------------------------
# 설치 안 된 패키지만 골라서 설치 (이미 있으면 건너뜀)
packages <- c("rstatix",   # 통계 검정 (shapiro_test)
              "skimr",     # 데이터 요약 (skim)
              "dplyr",     # 데이터 정리 (select)
              "car",       # VIF, Durbin-Watson, influencePlot
              "lmtest",    # Breusch-Pagan 검정 (bptest)
              "ggplot2",   # 그래프
              "MASS")      # 변수선택 (stepAIC)

new_pkgs <- packages[!(packages %in% installed.packages()[, "Package"])]
if (length(new_pkgs) > 0) install.packages(new_pkgs)

library(rstatix)
library(skimr)
library(dplyr)
library(car)
library(lmtest)
library(ggplot2)
# MASS는 library()로 불러오지 않고 MASS::stepAIC 로 호출
# (MASS::select 가 dplyr::select 를 덮어쓰는 충돌 방지)


# 1. 데이터 불러오기 및 정리 ------------------------------------------
# ★ 본인 컴퓨터의 Auto.csv 경로로 바꾸세요
#   경로를 모르면 file_path <- file.choose() 로 직접 파일 선택 가능
file_path <- "C:/Users/Hoon/Downloads/Auto.csv"

df <- read.csv(file_path, header = TRUE, stringsAsFactors = TRUE)
skim(df)

# 분석에 쓰지 않는 변수 제거 (origin: 범주형 코드, name: 차량 이름)
df <- dplyr::select(df, -c(origin, name))

# horsepower에 "?"가 섞여 있어 문자로 읽힘 -> 숫자로 변환 ("?"는 NA가 됨)
df$horsepower <- as.numeric(as.character(df$horsepower))

# 결측치 제거
df <- na.omit(df)
skim(df)


# 2. 전체 모형 ---------------------------------------------------------
result  <- lm(mpg ~ ., data = df)   # 모든 변수 사용 (주의: df$mpg 가 아니라 mpg)
result1 <- lm(mpg ~ 1, data = df)   # 변수 없이 평균으로만 예측

# 두 모형 비교: 변수를 넣은 모형이 유의하게 나은지 (F검정)
print(anova(result1, result))
summary(result)


# 3. 다중공선성 확인 ---------------------------------------------------
# VIF 10 이상: 다른 독립변수와 정보가 심하게 겹침
vif_values <- vif(result)
print(vif_values)
# 결과: cylinders, displacement, horsepower, weight 가 서로 겹치는 그룹
#       -> 그룹 중 설명력이 가장 강한 weight 만 남김
#       acceleration 은 VIF는 낮지만 유의하지 않아(p > 0.05) 제거


# 4. 변수 제거 후 모형 -------------------------------------------------
df2 <- dplyr::select(df, -c(cylinders, displacement, horsepower, acceleration))
skim(df2)

result2 <- lm(mpg ~ ., data = df2)
summary(result2)
print(vif(result2))   # 1에 가까우면 다중공선성 해결


# 5. 변수선택 (AIC) - 위에서 고른 변수가 타당한지 검증 -----------------
# 반드시 "전체 변수(df)"로 돌려야 의미가 있음
result_bk <- lm(mpg ~ ., data = df)
result_fw <- lm(mpg ~ 1, data = df)

# 후진제거법: 전부 넣고 하나씩 빼기
fit_bk <- MASS::stepAIC(result_bk, direction = "backward", trace = TRUE)

# 전진선택법: 빈 모형에서 하나씩 넣기
fit_fw <- MASS::stepAIC(result_fw, direction = "forward",
                        scope = formula(result_bk), trace = TRUE)

summary(fit_bk)
summary(fit_fw)
# 전진선택 결과가 weight + year 로 나오면 VIF 기반 선택과 일치


# 6. 최종 모형 진단 (result2 기준) -------------------------------------
final <- result2

diag_df <- data.frame(
  Fitted    = fitted(final),
  Residuals = resid(final)
)
diag_df$StdResid <- sqrt(abs(rstandard(final)))  # Scale-Location 용

# 선형성: 파란 선이 0 근처에서 평평해야 함
p1 <- ggplot(diag_df, aes(Fitted, Residuals)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "loess", se = FALSE, color = "blue") +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
  labs(title = "Residuals vs Fitted (선형성 확인)",
       x = "적합값", y = "잔차") +
  theme_minimal()
print(p1)

# 등분산성: 점이 고르게 퍼지고 선이 평평해야 함
p2 <- ggplot(diag_df, aes(Fitted, StdResid)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "loess", se = FALSE, color = "blue") +
  labs(title = "Scale-Location (등분산성 확인)",
       x = "적합값", y = "sqrt(|표준화 잔차|)") +
  theme_minimal()
print(p2)

# 가정 검정: 세 검정 모두 H0 = "가정을 만족함" -> p > 0.05 이어야 만족
print(bptest(final))                 # 등분산성 (Breusch-Pagan)
print(durbinWatsonTest(final))       # 독립성 (DW 통계량 2 근처가 이상적)
print(shapiro_test(resid(final)))    # 정규성 (Shapiro-Wilk)

# 기본 진단 그래프 4종
opar <- par(no.readonly = TRUE)
par(mfrow = c(2, 2))
plot(final)
par(opar)


# 7. 이상치 / 영향점 ---------------------------------------------------
# 스튜던트화 잔차, 레버리지, Cook's D 기준 상위 3개씩
cand <- influencePlot(final, id = list(n = 3))
mf <- model.frame(final)
z  <- round(scale(mf[sapply(mf, is.numeric)]), 1)
rownames(z) <- rownames(mf)
print(cbind(round(cand, 2), z[rownames(cand), ]))

# Cook's D 최댓값: < 0.5 영향점 없음, 0.5~1 확인 필요, > 1 영향점
print(max(cooks.distance(final)))

# 이상치 제거 (Cook's D 최댓값이 0.5 이상일 때만 사용)
# ★ 위 cbind 출력에서 확인한 행 번호로 직접 바꿔 넣기
out_rows <- c("323", "394")
df3 <- df2[!rownames(df2) %in% out_rows, ]   # df2를 덮어쓰지 않도록 새 이름 사용
nrow(df2)   # 제거 전 행 수
nrow(df3)   # 제거 후 행 수 (줄어들지 않았으면 행 번호가 잘못된 것)

result4 <- lm(mpg ~ weight + year, data = df3)
summary(result4)
cand4 <- influencePlot(result4, id = list(n = 3))
print(max(cooks.distance(result4)))


# 8. (보완) 가정 위반 시 로그 변환 모형 --------------------------------
# 진단에서 선형성/등분산성/정규성이 어긋나면 종속변수에 로그를 씌워 비교
result3 <- lm(log(mpg) ~ weight + year, data = df2)
summary(result3)

print(bptest(result3))
print(durbinWatsonTest(result3))
print(shapiro_test(resid(result3)))

par(mfrow = c(2, 2))
plot(result3)
par(opar)

# 그래도 등분산성이 안 맞으면: 이분산에 강건한 표준오차로 p값 보정
# (sandwich 패키지 필요 시 아래 두 줄 실행)
# if (!"sandwich" %in% installed.packages()[, "Package"]) install.packages("sandwich")
# print(coeftest(result3, vcov = sandwich::vcovHC(result3, type = "HC3")))
