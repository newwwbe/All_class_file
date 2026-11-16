package com.knu.psh41;

import android.os.Bundle;
import android.app.Activity;

//박상훈#41-리니어레이아웃 안에 3개의 리니어레이아웃
// 화면 구성(레이아웃)만 보는 예제라 버튼·클릭 코드가 없음. main.xml을 화면에 띄우기만 한다.
public class PSH41 extends Activity {

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
    }
}
