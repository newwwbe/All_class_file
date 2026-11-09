# 모바일프로그래밍 11/9 — 8장 조건문 (예제 36)

| 번호 | 내용 | 위젯 |
|---|---|---|
| 36 | if문1: 홀수/짝수 구별 (작년 기말 시험 문제) | TextView 2, EditText, Button, TextView |

> 수업 중 번호 정정: 지난주 "34번"으로 적은 사칙연산 계산기가 실제로는 **35번**이라 오늘 예제가 **36번**.
> 34번(덧셈) 개선은 건너뛰고, 나중에 37번 정도에서 같이 해설 예정.

## 프로젝트 만들기
- File → New → Android Application Project → 이름 `PSH36`, 패키지 `com.knu.psh36`, **API 8**
- 작업 공간이 다른 곳으로 되어 있으면 **File → Switch Workspace**로 본인 작업 공간 선택 후 재시작
- main.xml: `RelativeLayout` → `LinearLayout`, 두 번째 줄 제거, `fill_parent`, `orientation="vertical"`
- 자바: 클래스 위 `@Override` 제거, `onCreateOptionsMenu` 메소드 삭제
- 에뮬레이터: Window → Android Virtual Device Manager → `a` 또는 `a1` Start

## 조건문 (if)
```java
if (조건식)
    실행문;   // 조건이 참일 때만 실행, 거짓이면 건너뛰고 계속 진행
```
- 예: 신호등이 빨간불이면 브레이크, 로봇청소기 배터리 10% 이하면 충전대로, 장애물이 있으면 피해 간다
- **기말고사 범위: 조건문, 반복문, 배열** — 질문이 주어지면 필요한 위젯을 떠올리고 코드를 작성

## 시험 루틴 (항상 똑같음)
1. **XML**: 입력 `EditText`(id만) → 동작 `Button`(이름표+id) → 출력 `TextView`(id만) → **id 3개 확인 후 모두 저장**
2. **멤버 변수**: XML에서 id를 준 위젯에 대응되는 객체변수 선언 (id 3개 → 객체변수 3개). 붉은 줄은 1번(import)
3. **onCreate**: `findViewById(R.id.~)`로 객체변수와 위젯 id 연결
4. **setOnClickListener(this)**: 붉은 줄 해결책은 **버튼만 맨 마지막**(implements), 클래스 붉은 줄은 1번 → `onClick` 생성
5. **onClick**: `getText().toString()` → `Integer.parseInt()` → `if` → `setText()`

## 홀짝 구별 알고리즘
사람은 1, 3, 5는 홀수라고 **암기**하지만 컴퓨터는 암기할 수 없으니 **2로 나눈 나머지**로 구별한다.

```java
if (x % 2 == 1) temp = "홀수";
if (x % 2 == 0) temp = "짝수";
```

## 기억할 것
- **숫자 + 문자 = 문자열 붙이기**: `x + temp` → `"123홀수"` (덧셈이 아님)
- getText / setText처럼 메소드는 많이 외울 필요 없음. 모르면 `.` 찍고 Ctrl+Space로 찾기
- 너무 큰 수(int 범위 약 21억 초과, 10자리 이상)를 넣으면 앱이 멈춤 → 더 큰 수는 다른 자료형 필요
- 참고: 음수 홀수(-3)는 `-3 % 2 == -1`이라 두 if 모두 거짓 → temp에 입력값이 그대로 남아 `-3-3`이 출력됨. `x % 2 != 0`으로 쓰면 음수도 홀수로 판별됨
