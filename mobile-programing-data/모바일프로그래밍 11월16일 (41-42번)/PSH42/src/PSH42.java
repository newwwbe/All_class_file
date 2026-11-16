package com.knu.psh42;

import android.os.Bundle;
import android.app.Activity;

//박상훈#42-레이아웃 분할 (작년 시험 문제)
// 41번처럼 화면 구성만 보는 예제. main.xml을 화면에 띄우기만 한다.
public class PSH42 extends Activity {

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
    }
}
