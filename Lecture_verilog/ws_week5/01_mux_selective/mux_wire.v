module mux_2by1_wire(
    input a,
    input b,
    input sel,
    output out
);

wire out;

assign out = sel ? b : a;

endmodule