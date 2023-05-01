// 1. Define states
`define S0 2'b01 // hungry
`define S1 2'b10 // full
`define S2 2'b11 // study

// Define ports
module kid (
    input clk,
    input resetb,
    input meal,
    input book,
    output reg request
);
    reg [1:0] state; // current state
    reg [1:0] next_state;

    // 2. FSM logic
    always @(negedge resetb or posedge clk)
        if(~resetb)
            state <= `S0; // reset to initial state
        else
            state <= next_state; //update from next_state

    // 3. Next state logic
    always @(*)
        case(state)
            `S0: // When hungry and meal is served, become full, else remain hungry
                if(meal)
                    next_state = `S1;
                else
                    next_state = `S0;
            `S1: // When full and book is read, become study, else remain full
                if(book)
                    next_state = `S2;
                else
                    next_state = `S1;
            `S2: // When study and time passes, become hungry
                next_state = `S0;
            default:
                next_state = state;
        endcase

    // 4. Output logic
    always @(negedge resetb or posedge clk) begin
        if(~resetb)
            request <= 1'b0;
        else if(state == `S0) // When hungry, request meal
            request <= 1'b1;
        else if(state == `S1) // When full, do not request meal
            request <= 1'b0;
    end

endmodule
