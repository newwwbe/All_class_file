package com.knu.psh35;

import android.os.Bundle;
import android.app.Activity;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

//박상훈#35-사칙연산계산기
// 정수 2개를 입력받아 사칙연산 버튼 4개 중 하나를 클릭하면 결과를 출력하는 앱
public class PSH35 extends Activity implements OnClickListener {

    // 1단계: 객체변수 7개 선언 (입력 a,b / 버튼 c,d,e,f / 출력 g)
    EditText a_E, b_E;
    Button c_B, d_B, e_B, f_B;
    TextView g_T;

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);

        // 2단계: 객체변수와 위젯 id 연결
        a_E = (EditText) findViewById(R.id.a_edt);
        b_E = (EditText) findViewById(R.id.b_edt);
        c_B = (Button) findViewById(R.id.c_btn);
        d_B = (Button) findViewById(R.id.d_btn);
        e_B = (Button) findViewById(R.id.e_btn);
        f_B = (Button) findViewById(R.id.f_btn);
        g_T = (TextView) findViewById(R.id.g_txt);

        // 3단계: "모든" 버튼에 클릭 메소드 연결
        // 붉은 줄 4개지만 해결책(맨 마지막 implements)은 한 번만 하면 다 해결
        c_B.setOnClickListener(this);
        d_B.setOnClickListener(this);
        e_B.setOnClickListener(this);
        f_B.setOnClickListener(this);
    }

    // 4단계: 버튼 클릭 시 실행할 코드
    // 4개 중 어느 버튼이 클릭되었는지는 arg0이 가지고 있다
    public void onClick(View arg0) {
        String temp = "";
        int x = 0, y = 0;    // 정수 2개 저장용
        int z = 0;           // 계산 결과 저장용

        // 첫 번째 값: 입력 → 문자열 → 숫자
        temp = a_E.getText().toString();
        x = Integer.parseInt(temp);

        // 두 번째 값: temp 재활용
        temp = b_E.getText().toString();
        y = Integer.parseInt(temp);

        // 여러 개 중 1개 선택 → 다중 분기문 switch~case
        // getId(): 클릭된 버튼의 id를 가져온다 (getText는 문자열, getId는 id)
        switch (arg0.getId()) {
        case R.id.c_btn:     // + 버튼
            z = x + y;
            break;
        case R.id.d_btn:     // - 버튼
            z = x - y;
            break;
        case R.id.e_btn:     // x 버튼
            z = x * y;
            break;
        case R.id.f_btn:     // / 버튼 (정수끼리라 몫만 나옴)
            z = x / y;
            break;
        }

        // 숫자 → 문자 변환 후 TextView에 전달
        temp = String.valueOf(z);
        g_T.setText(temp);
    }
}
