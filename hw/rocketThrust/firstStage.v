// 소수 때문에 되는게 없어. 지구가속도도 그렇고 질량비도 그렇고 소수면 10 겁나 곱해서 크기 키우자.
// 32 bit

module firstStage (
    output wire [64:0] v1
);
wire [31:0] M2;
reg [31:0] mu1;
// reg [31:0] gravity;
reg reset;

// localparam은 불변하는 변수임
localparam SF = 10.0**6.0;
localparam propellentConsumeRatio = 2077000/168;
localparam specificImpulse = 263;
localparam burntime = 168;      // burntime이자 알파의 역수
localparam M1 = 2965000;        // 초기 새턴5 질량
localparam mp1 = 2077000;       // 1단 연료 질량
localparam mg1 = 2214000;
// localparam M2 = M1 - mg1 - LES;
localparam LES = 3628_74;          // LES 무게
localparam gravity = 9_799;
// localparam mu1 = (M1 - mp1)/M1;

// always @(*) begin
//     v1 <= -1 * gravity * specificImpulse * $ln(mu1);
// end 

// assign M2 = M1 - mg1 - LES;
// assign mu1 = (M1 - mp1) / M1;
always @(*) begin
    mu1 <= $itor((M1 - mp1)*SF / M1);
    reset <= reset;
end

// assign mu1 <= (M1 - mp1) / M1;
assign v1 = -1 * gravity * specificImpulse * $ln(mu1);

initial begin
    #10 reset = 0;
    #10 reset = 1;
    #10 reset = 0;
    #10 reset = 1;
    #10 reset = 0;
    #10 reset = 1;
    #10

    $display("%f", mu1);
    $display("%f", $ln(mu1));
    $display("최종속도 : %f, 질량비 : %f, 중력가속도 : %f", $itor(v1*10.0**-9.0), mu1, $itor(gravity * 10.0 ** -3.0));
    $finish;
end
initial begin
    $dumpfile("sim.vcd");
    $dumpvars(0, firstStage);  
end
endmodule //firstStage
