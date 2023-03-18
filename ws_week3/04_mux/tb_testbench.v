// 원래 i/o 없다.
module tb_testbench;

reg A, B, SEL;
wire OUT;

mux_2by1_wire dut1(
    .a(A),
    .b(B),
    .sel(SEL),
    .out(OUT)
)

// check design function




end module
