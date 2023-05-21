// 정보통신전자공학부 200421379 김철호
// 마이크로 프로세서 설계 기말고사
// Verilog source

`timescale 1 ns / 1 ps 

// 상태 정의
`define S0 2'b00
`define S1 2'b01
`define S2 2'b10
`define S3 2'b11

module mut ( clk ,rstn ,start ,load ,A ,B ,udf ,ovf ,done ,F );
	
	input clk, rstn, start, load;
	input [9:0] A, B;
	
	output udf, ovf, done;
	output [9:0] F;

	reg done, ovf, udf;
	reg [9:0] F;
	
	reg [1:0] cs, ns;
	
	// 가수부 연산을 위한 공간
	reg [4:0] m_a, m_b;
	reg [9:0] m_r;
	reg m_r_p, m_a_p, m_b_p;
	
	// 지수부 연산을 위한 공간
	reg [3:0] e_a, e_b;
	reg [4:0] e_r;
	
	reg fflag;

	always @(posedge clk or negedge rstn) begin 
		if(!rstn)	cs<=`S0;		// 리셋이면 처음상태
		else		cs<=ns;		// 아니면 다음 상태로
	end
	
	always @(cs or load) begin
		case(cs)  
			`S0 :begin
				if(start==1) ns<=`S1;						// start가 1이면 S1상태로 간다.
				else if(start==0) begin ns<=`S0;	// start가 0이면 계속 S0상태 유지
					if(load==1) begin						// start가 0일때 load가 1이면 값 입력 (내부 레지스터에 저장)
						m_a[0]<=A[8];
						m_a[1]<=A[7];
						m_a[2]<=A[6];
						m_a[3]<=A[5];
						m_a[4]<=A[4];
						m_a_p<=A[9];
						
						m_b[0]<=B[8];
						m_b[1]<=B[7];
						m_b[2]<=B[6];
						m_b[3]<=B[5];
						m_b[4]<=B[4];
						m_b_p<=B[9];						
						
						e_a<=A[3:0];
						e_b<=B[3:0];
					end
				end
				else ns<=ns;								// 기본 상태
				
				udf<=0;
				ovf<=0;
				done<=0;
				F<=0;
				
				end
			`S1:begin
				ns <= `S2;									// 다음상태 S2로 이동
				m_r <= m_a*m_b;						// 가수 곱셈
				m_r_p <= m_a_p+m_b_p;			// 가수 곱셈 부호
				e_r <= e_a+e_b+5'b11111;			// 지수 덧셈
				if(m_a==0||m_b==0) fflag=0; else fflag=1;	// 가수부가 0이면 fflag
			end
			`S2:
				if(fflag==1)	begin
					ns<=`S3;								// 다음상태 S3로 이동
					if(m_r[0]==0) begin
						m_r <= m_r >> 1;				// 오른쪽으로 시프트
						m_r[9] <= 0;      				// 마지막에 0채움
						e_r <= e_r +5'b11111;		// 지수에 1빼줌
					end
				end
				else if(fflag==0) begin
					ns<=`S0;								// F가 0이면 S0로 이동
					done<=1;
					F<=10'b000000_1000;			// F의 가수는 0, 지수는 -8로 세팅
				end
			`S3:begin
				ns<=`S0;										// 처음상태 S0로 이동
				if(e_r>7 && e_r<24 && e_a[3]==0 && e_b[3]==0) begin	// 지수 오버는 양수+양수일때만 발생한다
					ovf<=1;	 
					e_r=4'b0111;		// 오버 플로우에서 지수는 가장 큰 7로 세팅
				end
				if(e_r>31 && e_r<0 && (e_a[3]!=0 || e_b[3]!=0) || ((e_a[3]==1 && e_b[3]==1) && e_r[4]==1)) begin	// 지수 언더는 양수+양수일때는 일어날 수 없다.
					udf<=1;
					e_r=4'b1000;		// 언더 플로우에서 지수는 가장 작은 -8로 세팅
				end
				done<=1;
				// 연산 결과 출력
				F<={m_r_p, m_r[0], m_r[1], m_r[2], m_r[3], m_r[4], e_r[3], e_r[2], e_r[1], e_r[0]};
			end
		endcase
	end
endmodule
