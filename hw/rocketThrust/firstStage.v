// 소수 때문에 되는게 없어. 지구가속도도 그렇고 질량비도 그렇고 소수면 10 겁나 곱해서 크기 키우자.
// 32 bit

/*
64bit로 통일하고 나중에 출력할 때 필요한 부분만 잘라서 출력한다.?? 안 썼음.

결론적으로 속도계산기 만들었다.
주의할 점은 소수를 피하기 위해 곱해준 ISF만큼 '곱하기'연산에서 커지기 때문에, 잘못하면 무한정 커지거나 스케일을 놓칠 수 있다.
이 점을 유의하여 다음 테스크는
    1. 거리계산기
    2. 각속도 계산기 및 궤도
*/


module firstStage (
    output wire [64:0] v1
);
wire [31:0] M2;
reg [31:0] mu1;
// reg [31:0] gravity;
reg reset;

// localparam은 불변하는 변수임
localparam SF = 10.0**-3.0;
localparam ISF = 10.0**3.0; // 얘를 곱하면 소수 3자리까지 계산하겠다는 의미가 된다.

localparam propellentConsumeRatio = 2077000/168;
localparam specificImpulse = 263_000;
localparam burntime = 168_000;      // burntime이자 알파의 역수

localparam M1 = 3233500_000;        // 초기 새턴5 질량
localparam mp1 = 2077000_000;       // 1단 연료 질량
// localparam mg1 = 2214000;      
// localparam M2 = M1 - mg1 - LES;
localparam LES = 3628_740;          // LES 무게
localparam gravity = 9_799;
// localparam mu1 = (M1 - mp1)/M1;

// always @(*) begin
//     v1 <= -1 * gravity * specificImpulse * $ln(mu1);
// end 

// assign M2 = M1 - mg1 - LES;
// assign mu1 = (M1 - mp1) / M1;
/*
always @(*) begin
    mu1 <= (M1 - mp1) / M1;
    // mu1 <= $itor((M1 - mp1)*ISF / M1);
    reset <= reset;
end
*/

always @(*) begin
    mu1 <= (M1 - mp1)* ISF*ISF/ M1; // 얜 소수 6자리다 지금. 결국엔 3자리까지 바꿔서 최종적으로 계산해야한다.
    reset <= reset;
end

// assign mu1 <= (M1 - mp1) / M1;
wire [63:0] lnmu;
assign lnmu = (-1)*($ln(mu1) - $ln(ISF*ISF))*ISF;

wire [63:0] uprime;
assign uprime = gravity * specificImpulse;

assign v1 = uprime * lnmu;

initial begin
    #10 reset = 0;
    #10 reset = 1;
    #10 reset = 0;
    #10 reset = 1;
    #10 reset = 0;
    #10 reset = 1;
    #10

    $display("질량비 : %f", mu1);
    $display("ln질량비? : %f", lnmu);
    $display("질량비의 ln : %f", $ln(mu1)); // 질량비가 문제다. 이거 원래 1보다 작아 음수가 나오는데
    $display("유효배출속도의 1e6 : %f", uprime);
    $display("유효배출속도는 : %f", uprime * SF * SF); // 잘되네
    $display("중력가속도 1e3 : %f", gravity);
    $display("중력가속도 : %f", gravity*SF);
    $display("최종속도 : %f", $itor(v1*SF*SF*SF));
    // $display("최종속도 : %f, 질량비 : %f, 중력가속도 : %f", $itor(v1*SF), mu1, $itor(gravity * 10.0 ** -3.0));
    $finish;
end
initial begin
    $dumpfile("sim.vcd");
    $dumpvars(0, firstStage);  
end
endmodule //firstStage
