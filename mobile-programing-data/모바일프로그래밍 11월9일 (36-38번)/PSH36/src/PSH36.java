package com.knu.psh36;

import android.os.Bundle;
import android.app.Activity;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

//박상훈#36-if문1 홀짝수구별
// 정수값을 입력받아 홀수인지 짝수인지 구별하는 앱 (작년 기말 시험 문제)
public class PSH36 extends Activity implements OnClickListener {

    // 1단계: 객체변수 선언 (XML에서 id를 3개 줬으니 객체변수도 3개)
    EditText a_E;
    Button b_B;
    TextView c_T;

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);

        // 2단계: 객체변수와 위젯 id 연결 (XML에 있는 id를 찾으러 간다 → find)
        a_E = (EditText) findViewById(R.id.a_edt);
        b_B = (Button) findViewById(R.id.b_btn);
        c_T = (TextView) findViewById(R.id.c_txt);

        // 3단계: 버튼 클릭 시 호출될 메소드
        // 붉은 줄 → 버튼만 "맨 마지막" 해결책(implements), 그다음 클래스 붉은 줄은 1번(Add unimplemented methods)
        b_B.setOnClickListener(this);
    }

    // 4단계: 버튼 클릭 시 실행할 코드
    public void onClick(View arg0) {
        String temp = "";   // 입력값 저장용 문자열 (큰따옴표 두 개를 붙여서 초기화)
        int x = 0;          // 홀짝수 구별용 정수 (문자는 홀수/짝수를 모른다)

        // ① 입력값 → 문자열
        temp = a_E.getText().toString();

        // ② 문자 → 숫자 (홀짝 구별은 숫자로만 가능)
        x = Integer.parseInt(temp);

        // ③ if문: 2로 나눈 나머지가 1이면 홀수, 0이면 짝수
        //    (else는 아직 안 배웠으니 if를 두 번 사용)
        if (x % 2 == 1)
            temp = "홀수";
        if (x % 2 == 0)
            temp = "짝수";

        // ④ 결과를 TextView에 전달
        // c_T.setText(temp);          // 수업 처음 버전: "홀수" / "짝수"만 출력
        c_T.setText(x + temp);         // 꾸민 버전: "123홀수" (숫자 + 문자 = 문자열 붙이기)
    }
}
