// 1. Define states
`define P0 2'b01 // sleep
`define P1 2'b10 // cook
`define P2 2'b11 // book

// Port definitions
module parent (
    input clk,
    input resetb,
    input wakeup,
    output food,
    output book
);
    reg [1:0] state; 
    reg [1:0] next_state;
    reg food; 
    reg book; 

    // 2. Current FSM internal logic
    always @(negedge resetb or posedge clk) begin
        if(~resetb)
            state <= `P0; // Return to initial state on reset.
        else 
            state <= next_state; // Update state
    end

    // 3. Next state logic
    always @(*) begin
        case (state)
            `P0: begin
                if(wakeup)
                    next_state = `P1;
                else
                    next_state = `P0;
            end
            `P1: next_state = `P2;
            `P2: next_state = `P0;
            default: next_state = state;
        endcase
    end

    // 4. Output logic
    always @(negedge resetb or posedge clk) begin
        if(~resetb) begin
            state <= `P0; // Return to initial state on reset.
            food <= 1'b0; // Stop food output. 
            book <= 1'b0; // Stop book output.
        end else begin
            case (state)
                `P0: begin
                    food <= 1'b0; // Stop food output.
                    book <= 1'b0; // Stop book output.
                end
                `P1: begin
                    food <= 1'b1; // Output food.
                    book <= 1'b0; // Stop book output.
                end
                `P2: begin
                    food <= 1'b0; // Stop food output.
                    book <= 1'b1; // Output book.
                end
                default: begin
                    food <= 1'b0; // Stop food output.
                    book <= 1'b0; // Stop book output.
                end
            endcase
        end
    end

endmodule
