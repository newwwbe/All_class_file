package com.example.chapter10;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.RadioButton;

import androidx.appcompat.app.AppCompatActivity;

// 직접 풀어보기 10-1
public class Self1001 extends AppCompatActivity {

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.self1001_main);
		setTitle("메인 액티비티 (수정)");

		final RadioButton rdoSecond = (RadioButton) findViewById(R.id.rdoSecond);

		Button btnNewActivity = (Button) findViewById(R.id.btnNewActivity);
		btnNewActivity.setOnClickListener(new View.OnClickListener() {
			public void onClick(View v) {
				Intent intent;

				if (rdoSecond.isChecked() == true)
					intent = new Intent(getApplicationContext(),
							SecondActivity1001.class);
				else
					intent = new Intent(getApplicationContext(),
							ThirdActivity1001.class);

				startActivity(intent);
			}
		});
	}

}
