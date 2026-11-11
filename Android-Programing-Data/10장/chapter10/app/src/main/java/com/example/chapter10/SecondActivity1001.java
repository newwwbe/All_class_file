package com.example.chapter10;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

// 직접 풀어보기 10-1 (수정): 좋아하는 가수 그룹 선택 추가
public class SecondActivity1001 extends AppCompatActivity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {

		super.onCreate(savedInstanceState);
		setContentView(R.layout.second1001);
		setTitle("Second 액티비티");

		Button btnReturn = (Button) findViewById(R.id.btnReturn);
		btnReturn.setOnClickListener(new View.OnClickListener() {
			public void onClick(View v) {
				finish();
			}
		});

		final RadioGroup rGroupSinger = (RadioGroup) findViewById(R.id.rGroupSinger);
		final TextView tvResult = (TextView) findViewById(R.id.tvResult);

		Button btnSelect = (Button) findViewById(R.id.btnSelect);
		btnSelect.setOnClickListener(new View.OnClickListener() {
			public void onClick(View v) {
				// 선택된 라디오버튼의 글자를 그대로 결과로 표시
				RadioButton checked = (RadioButton) findViewById(rGroupSinger.getCheckedRadioButtonId());
				tvResult.setText("결과: " + checked.getText());
			}
		});

	}

}
