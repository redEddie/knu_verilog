module firstStage (
    output wire [64:0] v1
);
wire [31:0] M2;
reg reset;

// localparam은 불변하는 변수임
localparam SF = 10.0**-3.0;
localparam ISF = 10.0**3.0; // 얘를 곱하면 소수 3자리까지 계산하겠다는 의미가 된다.

localparam propellentConsumeRatio = 2077000/168;
localparam specificImpulse = 263_000;
localparam burntime = 168_000;      // burntime이자 알파의 역수

localparam M1 = 3233500_000;        // 초기 새턴5 질량
localparam mp1 = 2077000_000;       // 1단 연료 질량

localparam gravity = 9_799;


wire [31:0] mu1;
assign mu1 = (M1 - mp1)*ISF*ISF / M1;


wire [63:0] lnmu;
assign lnmu = (-1)*($ln(mu1) - $ln(ISF*ISF))*ISF; // 소수 6자리에 대한 mu의 ln 절댓값이다.


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
    $dumpfile("yes.vcd");
    $dumpvars(0, firstStage);  
end
endmodule //firstStage
