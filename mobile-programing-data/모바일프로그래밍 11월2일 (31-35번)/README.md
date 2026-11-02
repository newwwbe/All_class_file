# 모바일프로그래밍 11/2 — 버튼 (예제 31~35)

| 번호 | 내용 | 위젯 |
|---|---|---|
| 31 | 버튼사용법1 (XML만) | TextView, EditText, Button |
| 32 | 입력값 그대로 출력 | EditText, Button, TextView |
| 33 | 입력값 +10 출력 | EditText, Button, TextView |
| 34 | 정수 2개 덧셈 | EditText 2, Button, TextView |
| 35 | 사칙연산 계산기 (switch~case) | EditText 2, Button 4, TextView |

## 버튼이 있을 때 4단계
1. 객체변수 선언
2. `findViewById()`로 위젯 id와 연결
3. `버튼.setOnClickListener(this);` → 붉은 줄은 **맨 마지막** 해결책(implements), 그다음 클래스 붉은 줄은 1번(Add unimplemented methods)
4. `onClick()`에 코드 입력

## onClick 안의 순서 (메소드 4개)
1. `getText().toString()` — 입력값을 문자열로
2. `Integer.parseInt()` — 문자 → 숫자 (연산용)
3. `String.valueOf()` — 숫자 → 문자 (안 하면 실행 오류)
4. `setText()` — TextView에 출력

버튼이 여러 개면 `switch (arg0.getId()) { case R.id.c_btn: ... break; }`

※ 35번은 수업에서 더하기만 완성, 빼기·곱하기·나누기는 미리 채워둔 것.
