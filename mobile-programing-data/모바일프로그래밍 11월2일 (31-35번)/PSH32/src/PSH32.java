package com.knu.psh32;

import android.os.Bundle;
import android.app.Activity;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

//박상훈#32-버튼사용법2
public class PSH32 extends Activity implements OnClickListener {

    // [멤버변수] XML에서 id를 준 위젯에 대응되는 객체변수 선언
    EditText a_E;
    Button b_B;
    TextView c_T;

    // [멤버메소드] 프로그램 실행을 위한 코드
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);

        // 객체변수와 위젯 id 연결 (붉은 줄 → 1번 해결책: 캐스트 추가)
        a_E = (EditText) findViewById(R.id.a_edt);
        b_B = (Button) findViewById(R.id.b_btn);
        c_T = (TextView) findViewById(R.id.c_txt);

        // 버튼이 있으면: 클릭했을 때 동작을 세팅 (this = 이 화면에서)
        // 붉은 줄 → 맨 마지막 해결책 "Let 'PSH32' implement 'OnClickListener'"
        b_B.setOnClickListener(this);
    }

    // 붉은 줄 → 1번 "Add unimplemented methods" 로 생긴 메소드
    // 스마트폰에서 버튼을 클릭한 경우 수행할 코드
    public void onClick(View arg0) {
        String temp = "";                    // 따옴표 두 개를 붙여서 = 값이 없는 문자열

        temp = a_E.getText().toString();     // 입력한 값을 가져와서 temp에 저장
        c_T.setText(temp);                   // 아래쪽 TextView에 출력
    }
}
