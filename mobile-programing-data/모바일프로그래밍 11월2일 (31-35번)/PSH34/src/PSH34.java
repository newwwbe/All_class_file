package com.knu.psh34;

import android.os.Bundle;
import android.app.Activity;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

//박상훈#34-덧셈앱
// 정수 2개를 입력받아 덧셈한 결과를 출력하는 앱
public class PSH34 extends Activity implements OnClickListener {

    // 1단계: 객체변수 선언 (EditText 2개, Button 1개, TextView 1개)
    EditText a_E, b_E;
    Button c_B;
    TextView d_T;

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);

        // 2단계: 객체변수와 위젯 id 연결
        a_E = (EditText) findViewById(R.id.a_edt);
        b_E = (EditText) findViewById(R.id.b_edt);
        c_B = (Button) findViewById(R.id.c_btn);
        d_T = (TextView) findViewById(R.id.d_txt);

        // 3단계: 버튼 클릭 시 호출될 메소드 (붉은 줄 → 맨 마지막 해결책)
        c_B.setOnClickListener(this);
    }

    // 4단계: 버튼 클릭 시 실행할 코드
    public void onClick(View arg0) {
        String temp = "";        // 입력값·출력값 저장용 (재활용)
        int e = 0, f = 0;        // 정수 2개 저장용
        int g = 0;               // 덧셈 결과 저장용

        // ① 첫 번째 입력값 → 문자열,  ② 문자 → 숫자
        temp = a_E.getText().toString();
        e = Integer.parseInt(temp);

        // ① 두 번째 입력값 → 문자열 (temp 재활용),  ② 문자 → 숫자
        temp = b_E.getText().toString();
        f = Integer.parseInt(temp);

        g = e + f;               // 덧셈 연산

        // ③ 숫자 → 문자 (안 하면 데이터형 불일치로 실행 오류)
        temp = String.valueOf(g);

        // ④ 출력값을 TextView에 전달
        d_T.setText(temp);
    }
}
