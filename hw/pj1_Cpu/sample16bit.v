`timescale 1ns / 1ps

module cpu(clk, reset, DR, AC, IR, AR, PC);

input clk, reset;

output reg [15:0] DR, AC, IR;
output reg [11:0] AR, PC;

reg [3:0] sc;    //Sequence Counter
reg [15:0] T;    //output of decoder for Sequence Counter
reg [7:0] D;     //output of decoder for OPCODE
reg I;           //flipflop for IR[15]
reg E;           //register

integer j;

always @ (negedge reset) begin  //reset
    if(!reset) begin
        DR <= 0;                //register reset
        AC <= 0;
        IR <= 0;
        AR <= 0;
        PC <= 0;
        E  <= 0;
        for(j = 0; j < 4096; j = j + 1) begin   //SRAM reset
            sync_sram.mem[j] <= 4'h0000;
        end
    end
end

always @ (posedge clk or negedge reset) begin   //Sequence counter
    if(!reset) begin
        sc <= 0;
    end
    else begin
        sc <= sc + 4'b0001;
    end
end

always @ (sc) begin  //4 to 16 decoder for SC
    case(sc)
        4'b0000: T <= 16'b0000_0000_0000_0001;    //t0
        4'b0001: T <= 16'b0000_0000_0000_0010;    //t1
        4'b0010: T <= 16'b0000_0000_0000_0100;    //t2
        4'b0011: T <= 16'b0000_0000_0000_1000;    //t3
        4'b0100: T <= 16'b0000_0000_0001_0000;    //t4
        4'b0101: T <= 16'b0000_0000_0010_0000;    //t5
        4'b0110: T <= 16'b0000_0000_0100_0000;    //t6
        default: T <= 16'b0000_0000_0000_0000;
    endcase
end

always @ (IR) begin    //3 to 8 decoder for opcode
    case(IR[14:12])
        3'b000: D <= 8'b0000_0001;      //D0
        3'b001: D <= 8'b0000_0010;
        3'b010: D <= 8'b0000_0100;
        3'b011: D <= 8'b0000_1000;
        3'b100: D <= 8'b0001_0000;
        3'b101: D <= 8'b0010_0000;
        3'b110: D <= 8'b0100_0000;
        3'b111: D <= 8'b1000_0000;      //D7
        default: D <= 8'b0000_0000;
    endcase
end

always @ (posedge clk) begin
    if(T[0] == 1) begin            //t0
        AR <= PC;
    end
    else if(T[1] == 1) begin       //t1
        IR <= sync_sram.mem[AR];
        PC <= PC + 3'h001;
    end
    else if(T[2] == 1) begin       //t2
        AR <= IR[11:0];
        I <= IR[15];
    end
    else if(T[3] == 1) begin       //t3
        if(D[7] == 1 && I == 0) begin    //I'D7: register-reference instruction
            if(AR == 12'b1000_0000_0000) begin        //CLA
                AC <= 0;
            end
            else if(AR == 12'b0100_0000_0000) begin   //CLE
                E <= 0;
            end
            else if(AR == 12'b0010_0000_0000) begin   //CMA
                AC <= ~AC;
            end
            else if(AR == 12'b0001_0000_0000) begin   //CME
                E <= ~E;
            end
            else if(AR == 12'b0000_1000_0000) begin   //CIR
                AC <= AC >> 1;
                AC[15] <= E;
                E <= AC[0];
            end
            else if(AR == 12'b0000_0100_0000) begin   //CIL
                AC <= AC << 1;
                AC[0] <= E;
                E <= AC[15];
            end
            else if(AR == 12'b0000_0010_0000) begin   //INC
                AC <= AC + 16'b0000_0000_0000_0001;
            end
            else if(AR == 12'b0000_0001_0000) begin   //SPA
                if(AC[15] == 0)
                    PC <= PC + 1;
            end
            else if(AR == 12'b0000_0000_1000) begin   //SNA
                if(AC[15] == 1)
                    PC <= PC + 1;
            end
            else if(AR == 12'b0000_0000_0100) begin   //SZA
                if(AC == 0)
                    PC <= PC + 1;
            end
            else if(AR == 12'b0000_0000_0010) begin   //SZE
                if(E == 0)
                    PC <= PC + 1;
            end
            else if(AR == 12'b0000_0000_0001) begin   //MOV
                DR <= AC;
            end
            sc <= 0;      //reset sc at end of register-reference instruction
        end
        else if(D[7] == 0 && I == 1) begin                //D7'IT3: indirect address
            AR <= sync_sram.mem[AR];
        end
    end
    else if(T[4] == 1) begin                 //T4, memory-reference instruction
        if(D[0] == 1) begin                  //AND
            DR <= sync_sram.mem[AR];
        end
        else if(D[1] == 1) begin             //ADD
            DR <= sync_sram.mem[AR];
        end
        else if(D[2] == 1) begin             //LDA
            DR <= sync_sram.mem[AR];
        end
        else if(D[3] == 1) begin             //STA
            sync_sram.mem[AR] <= AC;
            sc <= 0;
        end
        else if(D[4] == 1) begin             //BUN
            PC <= AR;
            sc <= 0;
        end
        else if(D[5] == 1) begin             //BSA
            sync_sram.mem[AR] <= {0, PC};
            AR <= AR + 1;
        end
        else if(D[6] == 1) begin             //ISZ
            DR <= sync_sram.mem[AR];
        end
    end
    else if(T[5] == 1) begin                 //T5
        if(D[0] == 1) begin                  //AND
            AC <= AC ^ DR;
            sc <= 0;
        end
        else if(D[1] == 1) begin             //ADD
            {E, AC} <= AC + DR;
            sc <= 0;
        end
        else if(D[2] == 1) begin             //LDA
            AC <= DR;
            sc <= 0;
        end
        else if(D[5] == 1) begin             //BSA
            PC <= AR;
            sc <= 0;
        end
        else if(D[6] == 1) begin             //ISZ
            DR <= DR + 1;
        end
    end
    else if(T[6] == 1) begin                 //T6
        if(D[6] == 1) begin             //ISZ
            sync_sram.mem[AR] <= DR;
            if(DR == 0) begin
                PC <= PC + 1;
            end
            sc <= 0;
        end
    end
end

endmodule