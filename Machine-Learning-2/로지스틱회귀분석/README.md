# 로지스틱 회귀분석 (Logistic Regression)

- 강의자료: [../강의자료/4. 머신러닝2_로지스틱회귀분석.pdf](../강의자료/4.%20머신러닝2_로지스틱회귀분석.pdf)
- 데이터: [../데이터자료/UniversalBank.csv](../데이터자료/UniversalBank.csv) (학습용 5,000행), [../데이터자료/UniversalBank_test.csv](../데이터자료/UniversalBank_test.csv) (새 데이터 10행)
- 코드
  - [logistic_regression.R](logistic_regression.R): 단계별 주석이 달린 공부용
  - [logistic_regression_exam.R](logistic_regression_exam.R): 시험 제출용 (주석 없음)

---

## 1. 개념

### 왜 로지스틱 회귀인가
- 다중회귀는 종속변수가 **연속형**(예금금액 등)일 때 사용
- 종속변수가 **범주형**(예금유지 0/1, 양성/악성, 강아지/고양이)이면 직선 회귀식으로는 0~1 범위를 벗어나서 문제가 생김
- 그래서 회귀식 결과를 **시그모이드 함수**에 넣어 0~1 사이 확률로 바꾼 뒤, **임계값(보통 0.5)** 기준으로 0/1을 판단함

### 식
```
y    = β0 + β1·x1 + β2·x2 + … + βn·xn      (연속적인 수치)
σ(y) = 1 / (1 + e^(-y))                     (0 < σ(y) < 1, 확률처럼 해석)
```

### 계산 예시 (강의자료)
β0 = -1, β1 = 0.8, β2 = -0.5, x1 = 2, x2 = 3

```
y    = -1 + 0.8×2 - 0.5×3 = -0.9
σ(y) = 1 / (1 + e^(0.9)) = 0.289   → 0.5보다 작으므로 0(고양이)으로 판단
```

- 시그모이드는 이진분류에 많이 쓰이고, 신경망의 **활성화 함수**로도 쓰임 (Forward → Loss → Backward → Optimizer)

---

## 2. R 분석 흐름

| 단계 | 코드 | 의미 |
|---|---|---|
| 전처리 | `ifelse(... == 1, "yes", "no")`, `as.factor()` | 종속변수를 범주형으로 |
| 분할 | `createDataPartition(p = 0.8)` | 학습 80% / 테스트 20% (yes/no 비율 유지) |
| 모델 | `glm(..., family = "binomial")` | 로지스틱 회귀 |
| 모델 유의성 | `anova(result1, result2, test = "Chisq")` | 절편만 있는 모델 vs 전체 모델, p < 0.05면 유의 |
| 결과 표 | `tidy()` + `mutate_if(is.numeric, round, 3)` | 계수 결과를 표로 정리 |
| 독립성 | `durbinWatsonTest()` | D-W 통계량 2에 가까우면 독립 |
| 다중공선성 | `vif()` | 10 이상이면 문제 → 변수 제거 후 재분석 |
| 영향점 | `influencePlot()` | Cook's distance로 이상치 확인 |
| 저장/로드 | `saveRDS()`, `readRDS()` | 모델 파일로 저장 |
| 평가 | `predict(type = "response")`, `confusionMatrix()`, `roc()`, `auc()` | 정확도, Kappa, ROC/AUC |
| 적용 | `predict(result, newdata = df_test)` | 새 고객 대출 여부 예측 |

> `tidy()` 결과의 estimate는 선형회귀처럼 "x가 1 늘면 y가 얼마 늘어난다"가 아니라 **로그 오즈(log odds)** 값. `exp(estimate)`가 오즈비.

---

## 3. 모델 평가 지표

|  | 실제 True | 실제 False |
|---|---|---|
| **예측 True** | TP | FP |
| **예측 False** | FN | TN |

| 지표 | 공식 | 의미 |
|---|---|---|
| Precision (정밀도) | TP / (TP + FP) | 내가 "장난감"이라고 집은 것 중 진짜 장난감 비율 → 확실한 것만 고름 |
| Recall (재현율, TPR) | TP / (TP + FN) | 상자 속 모든 장난감 중 내가 찾은 비율 → 빠짐없이 찾음 |
| Accuracy (정확도) | (TP + TN) / 전체 | 전체 중 맞춘 비율 |
| F1 Score | 2 × P × R / (P + R) | Precision과 Recall의 조화평균, 클래스가 불균형할 때 유용 |
| FPR | FP / (FP + TN) | 가짜를 얼마나 진짜로 착각했나 (ROC의 x축) |

**강의자료 예제** (TP 20, FP 40, FN 30, TN 10)
- Precision = 20/60 = 0.333
- Recall = 20/50 = 0.4
- Accuracy = 30/100 = 0.3
- F1 = 2 × 0.333 × 0.4 / (0.333 + 0.4) = 0.364

**ROC / AUC**
- 임계값을 바꿔가며 (FPR, TPR)을 찍은 곡선. 왼쪽 위로 붙을수록 좋음
- 임계값을 내리면 TPR과 FPR이 같이 올라가고, 올리면 같이 내려감
- AUC: 0.5 무작위 / 0.6~0.7 낮음 / 0.7~0.8 보통 / 0.8~0.9 좋음 / 0.9 이상 매우 좋음

**confusionMatrix 출력 읽기**
- Kappa: 1에 가까울수록 좋음. 한쪽 클래스가 많아서 우연히 맞힌 건지 판단. 음수면 무작위보다 못함
- Mcnemar's Test P-Value: 0.05보다 크면 오류(FP와 FN)가 대칭적

---

## 4. 실행 결과 (set.seed(123))

**전체 변수 모델(result2)**
- anova: Deviance 2529.63 → 993.68, p < 2.2e-16 → 모델 유의함
- VIF: **Age 95.16, Experience 94.99** (둘의 상관계수 0.99) → 다중공선성 위배, 나머지는 모두 3 이하

**최종 모델(result)**: ID, ZIP.Code, Experience, CD.Account 제거
- VIF 모두 2.3 이하로 해결

| 지표 | 값 |
|---|---|
| Accuracy | 0.939 |
| Kappa | 0.606 |
| Precision | 0.740 |
| Recall | 0.562 |
| F1 | 0.639 |
| AUC | 0.935 |

혼동행렬 (테스트 1,000명)

|  | 실제 no | 실제 yes |
|---|---|---|
| 예측 no | 885 | 42 |
| 예측 yes | 19 | 54 |

- 정확도는 높지만 대출 승인(yes)이 전체의 9.6%뿐이라 Recall이 낮음 → 실제 대출자 96명 중 54명만 찾음
- 새 데이터 10명 중 **10번(Income 180, CCAvg 8.9)** 만 대출 승인 확률 0.957로 yes

---

## 5. 실습하면서 난 에러 정리

| 에러 | 원인 | 해결 |
|---|---|---|
| `함수 "createDataPartition"를 찾을 수 없습니다` | 패키지를 설치만 하고 불러오지 않음 | `library(caret)` |
| `네임스페이스 'rlang' 1.1.6는 이미 로드되었으나 >= 1.2.0가 필요합니다` | rlang이 옛 버전인데 이미 켜져 있음 | R 세션을 새로 시작한 직후 `install.packages("rlang")` |
| `Permission denied` (00LOCK ... .dll 복사 실패) | 다른 RStudio 창이나 `.RData` 자동 로드 때문에 패키지 파일이 사용 중 | RStudio 창을 모두 닫고 하나만 연 뒤 다른 코드 실행 전에 설치. `Tools → Global Options → General`에서 Restore .RData 끄기 |
| `함수 "tidy"를 찾을 수 없습니다` | tidymodels(broom)가 위 에러로 안 불러와짐 | rlang 업데이트 후 `library(tidymodels)` 또는 `library(broom)` |
| `객체 'df_tset'를 찾을 수 없습니다` | 오타 | `df_test` |
| 새 데이터 예측 시 `객체 'ID'를 찾을 수 없습니다` | 새 데이터에 ID, CD.Account 열이 없음. formula에 `- ID`로 써도 예측할 때 ID를 찾음 | 학습 데이터에서 열 자체를 빼고(`select(-ID, ...)`) 모델을 다시 만듦 |
| `glm(train_data$Personal.Loan ~ ., ...)` | 강의자료 표기. 동작은 하지만 `.`에 종속변수가 섞일 수 있고 예측 때 헷갈림 | `glm(Personal.Loan ~ ., data = train_data, ...)` |
