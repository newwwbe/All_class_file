package com.example.chapter10;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;

import androidx.appcompat.app.AppCompatActivity;

// 직접 풀어보기 10-1 원본
public class ThirdActivity1001_org extends AppCompatActivity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {

		super.onCreate(savedInstanceState);
		setContentView(R.layout.third1001_org);

		Button btnReturn = (Button) findViewById(R.id.btnReturn);
		btnReturn.setOnClickListener(new View.OnClickListener() {
			public void onClick(View v) {
				finish();
			}
		});

	}
}
