library(rstatix)
library(skimr)
library(dplyr)
library(car)
library(lmtest)
library(ggplot2)

# 1. 데이터 불러오기 및 정리
df <- read.csv("C:/Users/USER/Downloads/Auto.csv", header = TRUE, stringsAsFactors = TRUE)
skim(df)

df <- dplyr::select(df, -c(origin, name))
df$horsepower <- as.numeric(as.character(df$horsepower))  # "?" -> NA
df <- na.omit(df)
skim(df)

# 2. 전체 모형
result  <- lm(mpg ~ ., data = df)
result1 <- lm(mpg ~ 1, data = df)
print(anova(result1, result))
summary(result)

# 3. 다중공선성 확인 (변수 제거 근거)
vif_values <- vif(result)
print(vif_values)

# 4. 변수 제거 후 모형
df2 <- dplyr::select(df, -c(cylinders, displacement, horsepower, acceleration))
skim(df2)
result2 <- lm(mpg ~ ., data = df2)
summary(result2)
print(vif(result2))

# 5. 변수선택 (AIC)
result_bk <- lm(mpg ~ ., data = df2)
fit_bk <- MASS::stepAIC(result_bk, direction = "backward", trace = TRUE)

result_fw <- lm(mpg ~ 1, data = df2)
fit_fw <- MASS::stepAIC(result_fw, direction = "forward",
                        scope = formula(result_bk), trace = TRUE)

# 6. 최종 모형 진단 (result2 기준)
final <- result2

diag_df <- data.frame(
  Fitted    = fitted(final),
  Residuals = resid(final)
)
diag_df$StdResid <- sqrt(abs(rstandard(final)))  # Scale-Location용

ggplot(diag_df, aes(Fitted, Residuals)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "loess", se = FALSE, color = "blue") +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
  labs(title = "Residuals vs Fitted (선형성 확인)",
       x = "적합값", y = "잔차") +
  theme_minimal()

ggplot(diag_df, aes(Fitted, StdResid)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "loess", se = FALSE, color = "blue") +
  labs(title = "Scale-Location (등분산성 확인)",
       x = "적합값", y = "sqrt(|표준화 잔차|)") +
  theme_minimal()

bptest(final)                    # 등분산성
durbinWatsonTest(final)          # 독립성
shapiro_test(resid(final))       # 정규성

opar <- par(no.readonly = TRUE)
par(mfrow = c(2, 2))
plot(final)
par(opar)

# 7. 이상치/영향점
cand <- influencePlot(final, id = list(n = 3))
mf <- model.frame(final)
z  <- round(scale(mf[sapply(mf, is.numeric)]), 1)
rownames(z) <- rownames(mf)
cbind(round(cand, 2), z[rownames(cand), ])
max(cooks.distance(final))   # <0.5 영향점 없음