package com.knu.psh31;

import android.os.Bundle;
import android.app.Activity;

//박상훈#31-버튼사용법1
// 31번은 XML(디자인)만 하는 예제라 Java는 기본 코드에서
// onCreateOptionsMenu()와 @Override만 지운 상태 그대로입니다.
public class PSH31 extends Activity {

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
    }
}
