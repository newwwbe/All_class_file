package com.knu.psh33;

import android.os.Bundle;
import android.app.Activity;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

//박상훈#33-버튼사용법3
// 정수 1개를 입력받아 +10 한 결과를 출력하는 앱
public class PSH33 extends Activity implements OnClickListener {

    // 1단계: 객체변수 선언
    EditText a_E;
    Button b_B;
    TextView c_T;

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);

        // 2단계: 객체변수와 위젯 id 연결
        a_E = (EditText) findViewById(R.id.a_edt);
        b_B = (Button) findViewById(R.id.b_btn);
        c_T = (TextView) findViewById(R.id.c_txt);

        // 3단계: 버튼 클릭 시 호출될 메소드 작성 (붉은 줄 → 맨 마지막 해결책)
        b_B.setOnClickListener(this);
    }

    // 4단계: onClick()에 실행할 코드 입력
    public void onClick(View arg0) {
        String temp = "";   // 문자열 초기화: 큰따옴표 두 개를 붙여서
        int d = 0;          // 정수 초기화: 0

        // ① EditText 입력값은 문자열 → getText().toString()으로 문자열 변수에 대입
        temp = a_E.getText().toString();

        // ② 문자는 연산이 안 됨 → Integer.parseInt()로 문자를 숫자로 변환
        d = Integer.parseInt(temp);
        d = d + 10;         // +10 연산

        // c_T.setText(d);  // 오류! TextView는 문자열만 인식 → 정수를 바로 넣으면
        //                  // "Unfortunately, ... has stopped" 실행 오류 (데이터형 불일치)

        // ③ 숫자를 문자로 변환: String.valueOf()
        temp = String.valueOf(d);

        // ④ 출력값을 TextView에 전달: setText()
        c_T.setText(temp);
    }
}
