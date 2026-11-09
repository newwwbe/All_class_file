package com.knu.psh38;

import android.os.Bundle;
import android.app.Activity;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

//박상훈#38-큰수작은수구별
// 정수 2개를 입력받아 큰 수와 작은 수를 구별해 출력하는 앱
public class PSH38 extends Activity implements OnClickListener {

    // 1단계: 객체변수 선언 (XML id 4개 → 객체변수 4개, 시험 때는 a b c d로만 써도 됨)
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

        // 3단계: 버튼이 존재하면 클릭 메소드 추가
        c_B.setOnClickListener(this);
    }

    // 4단계: 버튼 클릭 시 실행할 코드
    public void onClick(View arg0) {
        String temp = "";   // 입력값 저장용 (재사용)
        int x = 0, y = 0;   // 정수 2개

        // 첫 번째 입력값 → 문자열 → 숫자
        temp = a_E.getText().toString();
        x = Integer.parseInt(temp);

        // 두 번째 입력값 (temp 재사용) → 숫자
        temp = b_E.getText().toString();
        y = Integer.parseInt(temp);

        // if~else로 큰 수 구별 (같은 경우는 이번엔 무시)
        // String.format(): printf처럼 형식을 맞추지만 "출력"이 아니라 "문자열로 저장"하는 메소드
        //   %d 자리에 뒤의 변수가 순서대로 들어감, \n 은 줄바꿈
        if (x > y)
            temp = String.format("큰 수는 %d이고,\n작은 수는 %d입니다.", x, y);
        else
            temp = String.format("큰 수는 %d이고,\n작은 수는 %d입니다.", y, x);

        // 형식을 미리 temp에 만들어 놨으니 + 연산자 없이 바로 출력
        d_T.setText(temp);
    }
}
