package com.knu.psh37;

import android.os.Bundle;
import android.app.Activity;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

//박상훈#37-if~else문 합격여부
// 점수를 입력받아 60점 이상이면 합격, 아니면 불합격을 출력하는 앱
public class PSH37 extends Activity implements OnClickListener {

    // 1단계: 객체변수 선언 (대소문자 주의: EditText, Button, TextView)
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

        // 3단계: 버튼 클릭 메소드 (붉은 줄 → 맨 마지막 해결책, 클래스 붉은 줄 → 1번)
        b_B.setOnClickListener(this);
    }

    // 4단계: 버튼 클릭 시 실행할 코드
    public void onClick(View arg0) {
        String temp = "";   // 입력값 저장용 문자열
        int x = 0;          // 점수 비교용 정수 (문자는 60 이상인지 비교 못 함)

        // ① 입력값 → 문자열
        temp = a_E.getText().toString();

        // ② 문자 → 숫자
        x = Integer.parseInt(temp);

        // ③ if~else: 조건이 참이면 실행문1, 거짓이면 실행문2
        //    if( ) 와 else 옆에는 아무것도(특히 세미콜론 ;) 적으면 안 된다
        if (x >= 60)
            temp = "합격";
        else
            temp = "불합격";

        // ④ 출력
        // c_T.setText(x);   // 실수! TextView는 문자열만 인식 → 숫자를 바로 넣으면 실행 오류
        c_T.setText("당신의 점수는 " + x + "점이고 " + temp + "입니다.");
        // 문자 + 숫자 = 문자열 붙이기, 문자 + 문자 = 붙이기
    }
}
