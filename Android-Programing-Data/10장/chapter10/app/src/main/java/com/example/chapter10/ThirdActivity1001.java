package com.example.chapter10;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

// 직접 풀어보기 10-1 (수정): 선택완료 버튼을 누르면 Toast 메시지
public class 	ThirdActivity1001 extends AppCompatActivity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {

		super.onCreate(savedInstanceState);
		setContentView(R.layout.third1001);

		Button btnReturn = (Button) findViewById(R.id.btnReturn);
		btnReturn.setOnClickListener(new View.OnClickListener() {
			public void onClick(View v) {
				finish();
			}
		});

		Button btnSelect = (Button) findViewById(R.id.btnSelect);
		btnSelect.setOnClickListener(new View.OnClickListener() {
			public void onClick(View v) {
				Toast.makeText(getApplicationContext(), "버튼 눌렸습니다.",
						Toast.LENGTH_SHORT).show();
			}
		});

	}
}
