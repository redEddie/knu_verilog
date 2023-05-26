module readmemh_tb();
    reg [7:0] test_memory [0:15]; // 테스트 메모리는 8비트로 16개 만들었다.
    initial begin
        $display("Loading rom.");
        $readmemh("rom_image.mem", test_memory);
    end

    reg [7:0] temp;
    reg clk;
    reg [3:0] N;

    always @(posedge clk) begin
        temp <= test_memory[N];
    end

    always @(temp) begin
        $display("temp[%d] : %f", N, temp);
        N <= N+1;
    end
    
    
    always begin
        #10 clk = ~clk;
    end

    initial begin
        clk = 0;
        temp = 0;
        N = 0;

        #500 $finish;
    end

    initial begin
    $dumpfile("temp.vcd");
    $dumpvars(0, readmemh_tb);  
    end

endmodule