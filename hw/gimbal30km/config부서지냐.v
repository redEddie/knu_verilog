#! /opt/homebrew/Cellar/icarus-verilog/11.0/bin/vvp
:ivl_version "11.0 (stable)";
:ivl_delay_selection "TYPICAL";
:vpi_time_precision + 0;
:vpi_module "/opt/homebrew/Cellar/icarus-verilog/11.0/lib/ivl/system.vpi";
:vpi_module "/opt/homebrew/Cellar/icarus-verilog/11.0/lib/ivl/vhdl_sys.vpi";
:vpi_module "/opt/homebrew/Cellar/icarus-verilog/11.0/lib/ivl/vhdl_textio.vpi";
:vpi_module "/opt/homebrew/Cellar/icarus-verilog/11.0/lib/ivl/v2005_math.vpi";
:vpi_module "/opt/homebrew/Cellar/icarus-verilog/11.0/lib/ivl/va_math.vpi";
S_0x15b614870 .scope module, "tb" "tb" 2 1;
 .timescale 0 0;
P_0x15b607f60 .param/l "GRAVITY" 1 2 31, +C4<00000000000000000010011001000111>;
P_0x15b607fa0 .param/real "ISF" 1 2 33, Cr<m7d00000000000000gfcb>; value=1000.00
P_0x15b607fe0 .param/real "SF" 1 2 32, Cr<m4189374bc6a7f000gfb8>; value=0.00100000
v0x15b6280e0_0 .net "AFTERWEIGHT", 63 0, v0x15b6261f0_0;  1 drivers
v0x15b628170_0 .var "BURNTIME", 63 0;
v0x15b628200_0 .var "CLK", 0 0;
v0x15b6282b0_0 .var "INITIALWEIGHT", 63 0;
v0x15b628360_0 .net "INTEGRAL_RESULT", -1 0, L_0x15b6294e0;  1 drivers
v0x15b628430_0 .var "PROPELLENTWEIGHT", 63 0;
v0x15b6284c0_0 .var "RESETB", 0 0;
v0x15b628550_0 .var "SIGNAL_INPUT", -1 0;
v0x15b6285f0_0 .var "SPECIFICIMPULSE", 63 0;
v0x15b628730_0 .var "START_INTEGRATION", 0 0;
v0x15b6287c0_0 .net "VELOCITY", 63 0, v0x15b626b80_0;  1 drivers
L_0x160078178 .functor BUFT 1, C4<00000000000000000000000000000000000000000000000000000000000000>, C4<0>, C4<0>, C4<0>;
v0x15b628850_0 .net *"_ivl_5", 61 0, L_0x160078178;  1 drivers
v0x15b6288e0_0 .var "elapsed", 63 0;
L_0x15b6294e0 .part v0x15b627bd0_0, 0, 2;
L_0x15b629580 .concat [ 2 62 0 0], L_0x15b6294e0, L_0x160078178;
S_0x15b60f120 .scope module, "getVelocity_1" "getVelocity" 2 3, 3 9 0, S_0x15b614870;
 .timescale 0 0;
    .port_info 0 /OUTPUT 64 "velocity";
    .port_info 1 /OUTPUT 64 "afterWeight";
    .port_info 2 /INPUT 64 "specificImpulse";
    .port_info 3 /INPUT 64 "initialWeight";
    .port_info 4 /INPUT 64 "propellentWeight";
    .port_info 5 /INPUT 64 "burntime";
    .port_info 6 /INPUT 1 "clk";
    .port_info 7 /INPUT 1 "resetb";
P_0x15b613430 .param/l "GRAVITY" 0 3 12, +C4<00000000000000000010011001000111>;
P_0x15b613470 .param/real "ISF" 0 3 11, Cr<m7d00000000000000gfcb>; value=1000.00
P_0x15b6134b0 .param/real "SF" 0 3 10, Cr<m4189374bc6a7f000gfb8>; value=0.00100000
v0x15b612200_0 .net/real *"_ivl_11", 0 0, L_0x15b628d00;  1 drivers
L_0x1600780a0 .functor BUFT 1, Cr<m7d00000000000000gfcb>, C4<0>, C4<0>, C4<0>;
v0x15b625bd0_0 .net/real *"_ivl_12", 0 0, L_0x1600780a0;  1 drivers
v0x15b625c70_0 .net/real *"_ivl_15", 0 0, L_0x15b628e20;  1 drivers
L_0x1600780e8 .functor BUFT 1, Cr<m7d00000000000000gfcb>, C4<0>, C4<0>, C4<0>;
v0x15b625d00_0 .net/real *"_ivl_16", 0 0, L_0x1600780e8;  1 drivers
v0x15b625d90_0 .net/real *"_ivl_19", 0 0, L_0x15b628f90;  1 drivers
L_0x160078130 .functor BUFT 1, C4<0000000000000000000000000000000000000000000000000010011001000111>, C4<0>, C4<0>, C4<0>;
v0x15b625e40_0 .net/2u *"_ivl_22", 63 0, L_0x160078130;  1 drivers
v0x15b625ef0_0 .net/real *"_ivl_3", 0 0, L_0x15b628ac0;  1 drivers
L_0x160078010 .functor BUFT 1, Cr<m6e862a663ffe8000gfc5>, C4<0>, C4<0>, C4<0>;
v0x15b625fa0_0 .net/real *"_ivl_4", 0 0, L_0x160078010;  1 drivers
v0x15b626040_0 .net/real *"_ivl_6", 0 0, L_0x15b628ba0;  1 drivers
L_0x160078058 .functor BUFT 1, Cr<m4000000000000000g4fc2>, C4<0>, C4<0>, C4<0>;
v0x15b626150_0 .net/real *"_ivl_8", 0 0, L_0x160078058;  1 drivers
v0x15b6261f0_0 .var "afterWeight", 63 0;
v0x15b6262a0_0 .net "burntime", 63 0, v0x15b628170_0;  1 drivers
v0x15b626350_0 .net "clk", 0 0, v0x15b628200_0;  1 drivers
v0x15b6263f0_0 .net "consumeRatio", 63 0, L_0x15b628980;  1 drivers
v0x15b6264a0_0 .net "initialWeight", 63 0, v0x15b6282b0_0;  1 drivers
v0x15b626550_0 .net "lnmu", 63 0, L_0x15b6290b0;  1 drivers
v0x15b626600_0 .var "mu", 63 0;
v0x15b626790_0 .net "propellentWeight", 63 0, v0x15b628430_0;  1 drivers
v0x15b626820_0 .net "resetb", 0 0, v0x15b6284c0_0;  1 drivers
v0x15b6268c0_0 .net "specificImpulse", 63 0, v0x15b6285f0_0;  1 drivers
v0x15b626970_0 .net "uprime", 63 0, L_0x15b629260;  1 drivers
v0x15b626a20_0 .var "usedPropellent", 63 0;
v0x15b626ad0_0 .var "usedPropellentForCalcul", 63 0;
v0x15b626b80_0 .var "velocity", 63 0;
E_0x15b6129d0/0 .event negedge, v0x15b626820_0;
E_0x15b6129d0/1 .event posedge, v0x15b626350_0;
E_0x15b6129d0 .event/or E_0x15b6129d0/0, E_0x15b6129d0/1;
E_0x15b612a40 .event edge, v0x15b6264a0_0, v0x15b626a20_0;
L_0x15b628980 .arith/div 64, v0x15b628430_0, v0x15b628170_0;
L_0x15b628ac0 .sfunc 3 44 "$ln", "rv64", v0x15b626600_0;
L_0x15b628ba0 .arith/sub.r 1, L_0x15b628ac0, L_0x160078010;
L_0x15b628d00 .arith/mult.r 1, L_0x15b628ba0, L_0x160078058;
L_0x15b628e20 .arith/mult.r 1, L_0x15b628d00, L_0x1600780a0;
L_0x15b628f90 .arith/mult.r 1, L_0x15b628e20, L_0x1600780e8;
L_0x15b6290b0 .cast/int 64, L_0x15b628f90;
L_0x15b629260 .arith/mult 64, v0x15b6285f0_0, L_0x160078130;
S_0x15b626cf0 .scope module, "gimbal_1" "gimbal30km" 2 22, 4 9 0, S_0x15b614870;
 .timescale 0 0;
    .port_info 0 /INPUT 1 "clk";
    .port_info 1 /INPUT 1 "resetb";
    .port_info 2 /INPUT 64 "velocity";
    .port_info 3 /INPUT 64 "height";
P_0x15b626e60 .param/real "ISF" 0 4 12, Cr<m7d00000000000000gfcb>; value=1000.00
P_0x15b626ea0 .param/l "N" 0 4 10, +C4<00000000000000000000000001000000>;
P_0x15b626ee0 .param/real "SF" 0 4 11, Cr<m4189374bc6a7f000gfb8>; value=0.00100000
P_0x15b626f20 .param/l "radian" 1 4 23, +C4<00000000000000101101111001100000>;
v0x15b627140_0 .var "angularVelocity", 63 0;
v0x15b6271f0_0 .net "clk", 0 0, v0x15b628200_0;  alias, 1 drivers
v0x15b627290_0 .var "gimbalEnable", 0 0;
v0x15b627320_0 .net "height", 63 0, L_0x15b629580;  1 drivers
v0x15b6273b0_0 .net "resetb", 0 0, v0x15b6284c0_0;  alias, 1 drivers
v0x15b627440_0 .net "velocity", 63 0, v0x15b626b80_0;  alias, 1 drivers
S_0x15b627540 .scope module, "integration_1" "numericalIntegral" 2 14, 5 1 0, S_0x15b614870;
 .timescale 0 0;
    .port_info 0 /INPUT 1 "clk";
    .port_info 1 /INPUT 1 "resetb";
    .port_info 2 /INPUT 64 "signal_input";
    .port_info 3 /INPUT 1 "start_integration";
    .port_info 4 /OUTPUT 64 "integral_result";
P_0x15b627700 .param/l "N" 0 5 2, +C4<00000000000000000000000001000000>;
P_0x15b627740 .param/l "PERIOD" 0 5 3, +C4<00000000000000000000000000001010>;
L_0x15b629380 .functor NOT 1, v0x15b6284c0_0, C4<0>, C4<0>, C4<0>;
L_0x15b629470 .functor NOT 1, v0x15b6284c0_0, C4<0>, C4<0>, C4<0>;
v0x15b627970_0 .net *"_ivl_2", 0 0, L_0x15b629380;  1 drivers
v0x15b627a30_0 .net *"_ivl_7", 0 0, L_0x15b629470;  1 drivers
v0x15b627ae0_0 .net "clk", 0 0, v0x15b628200_0;  alias, 1 drivers
v0x15b627bd0_0 .var "integral_result", 63 0;
v0x15b627c70_0 .var "next_signal", 63 0;
v0x15b627d40_0 .net "resetb", 0 0, v0x15b6284c0_0;  alias, 1 drivers
v0x15b627e10_0 .var "signal", 63 0;
v0x15b627ea0_0 .net "signal_input", 63 0, v0x15b626b80_0;  alias, 1 drivers
v0x15b627f80_0 .net "start_integration", 0 0, v0x15b628730_0;  1 drivers
E_0x15b6278f0/0 .event negedge, L_0x15b629470;
E_0x15b6278f0/1 .event posedge, v0x15b626350_0;
E_0x15b6278f0 .event/or E_0x15b6278f0/0, E_0x15b6278f0/1;
E_0x15b627930/0 .event negedge, L_0x15b629380;
E_0x15b627930/1 .event posedge, v0x15b626350_0;
E_0x15b627930 .event/or E_0x15b627930/0, E_0x15b627930/1;
    .scope S_0x15b60f120;
T_0 ;
    %wait E_0x15b6129d0;
    %load/vec4 v0x15b6264a0_0;
    %load/vec4 v0x15b626790_0;
    %sub;
    %assign/vec4 v0x15b6261f0_0, 0;
    %load/vec4 v0x15b626a20_0;
    %pushi/vec4 2, 0, 64;
    %load/vec4 v0x15b6263f0_0;
    %pow;
    %add;
    %assign/vec4 v0x15b626a20_0, 0;
    %load/vec4 v0x15b626a20_0;
    %cvt/rv;
    %pushi/real 1099511627, 4056; load=0.00100000
    %pushi/real 3254780, 4034; load=0.00100000
    %add/wr;
    %mul/wr;
    %cvt/vr 64;
    %assign/vec4 v0x15b626ad0_0, 0;
    %jmp T_0;
    .thread T_0;
    .scope S_0x15b60f120;
T_1 ;
    %wait E_0x15b612a40;
    %load/vec4 v0x15b6264a0_0;
    %cvt/rv;
    %pushi/real 2097152000, 4075; load=1000.00
    %mul/wr;
    %pushi/real 2097152000, 4075; load=1000.00
    %mul/wr;
    %load/vec4 v0x15b626a20_0;
    %cvt/rv;
    %sub/wr;
    %load/vec4 v0x15b6264a0_0;
    %cvt/rv;
    %div/wr;
    %cvt/vr 64;
    %assign/vec4 v0x15b626600_0, 0;
    %jmp T_1;
    .thread T_1, $push;
    .scope S_0x15b60f120;
T_2 ;
    %wait E_0x15b6129d0;
    %load/vec4 v0x15b626970_0;
    %load/vec4 v0x15b626550_0;
    %mul;
    %assign/vec4 v0x15b626b80_0, 0;
    %jmp T_2;
    .thread T_2;
    .scope S_0x15b60f120;
T_3 ;
    %pushi/vec4 0, 0, 64;
    %store/vec4 v0x15b626a20_0, 0, 64;
    %end;
    .thread T_3;
    .scope S_0x15b627540;
T_4 ;
    %wait E_0x15b627930;
    %load/vec4 v0x15b627ea0_0;
    %assign/vec4 v0x15b627c70_0, 0;
    %load/vec4 v0x15b627c70_0;
    %assign/vec4 v0x15b627e10_0, 0;
    %jmp T_4;
    .thread T_4;
    .scope S_0x15b627540;
T_5 ;
    %wait E_0x15b6278f0;
    %load/vec4 v0x15b627d40_0;
    %inv;
    %flag_set/vec4 8;
    %jmp/0xz  T_5.0, 8;
    %pushi/vec4 0, 0, 64;
    %assign/vec4 v0x15b627bd0_0, 0;
    %jmp T_5.1;
T_5.0 ;
    %load/vec4 v0x15b627f80_0;
    %flag_set/vec4 8;
    %jmp/0xz  T_5.2, 8;
    %load/vec4 v0x15b627bd0_0;
    %cvt/rv;
    %pushi/vec4 20, 0, 64;
    %cvt/rv;
    %load/vec4 v0x15b627e10_0;
    %load/vec4 v0x15b627c70_0;
    %add;
    %cvt/rv;
    %pushi/real 1073741824, 4065; load=0.500000
    %pow/wr;
    %mul/wr;
    %add/wr;
    %cvt/vr 64;
    %assign/vec4 v0x15b627bd0_0, 0;
T_5.2 ;
T_5.1 ;
    %jmp T_5;
    .thread T_5;
    .scope S_0x15b626cf0;
T_6 ;
    %wait E_0x15b6129d0;
    %pushi/vec4 30, 0, 32;
    %cvt/rv/s;
    %load/vec4 v0x15b627320_0;
    %cvt/rv;
    %pushi/real 1099511627, 4056; load=0.00100000
    %pushi/real 3254780, 4034; load=0.00100000
    %add/wr;
    %mul/wr;
    %pushi/real 1099511627, 4056; load=0.00100000
    %pushi/real 3254780, 4034; load=0.00100000
    %add/wr;
    %mul/wr;
    %pushi/real 1099511627, 4056; load=0.00100000
    %pushi/real 3254780, 4034; load=0.00100000
    %add/wr;
    %mul/wr;
    %pushi/real 1099511627, 4056; load=0.00100000
    %pushi/real 3254780, 4034; load=0.00100000
    %add/wr;
    %mul/wr;
    %cmp/wr;
    %jmp/0xz  T_6.0, 5;
    %pushi/vec4 1, 0, 1;
    %assign/vec4 v0x15b627290_0, 0;
    %jmp T_6.1;
T_6.0 ;
    %load/vec4 v0x15b6273b0_0;
    %inv;
    %flag_set/vec4 8;
    %jmp/0xz  T_6.2, 8;
    %pushi/vec4 0, 0, 1;
    %assign/vec4 v0x15b627290_0, 0;
    %jmp T_6.3;
T_6.2 ;
    %pushi/vec4 0, 0, 1;
    %assign/vec4 v0x15b627290_0, 0;
T_6.3 ;
T_6.1 ;
    %jmp T_6;
    .thread T_6;
    .scope S_0x15b626cf0;
T_7 ;
    %wait E_0x15b6129d0;
    %load/vec4 v0x15b627290_0;
    %flag_set/vec4 8;
    %jmp/0xz  T_7.0, 8;
    %load/vec4 v0x15b627320_0;
    %cvt/rv;
    %pushi/real 1099511627, 4056; load=0.00100000
    %pushi/real 3254780, 4034; load=0.00100000
    %add/wr;
    %mul/wr;
    %pushi/real 1099511627, 4056; load=0.00100000
    %pushi/real 3254780, 4034; load=0.00100000
    %add/wr;
    %mul/wr;
    %pushi/vec4 188000, 0, 32;
    %cvt/rv/s;
    %div/wr;
    %cvt/vr 64;
    %assign/vec4 v0x15b627140_0, 0;
T_7.0 ;
    %jmp T_7;
    .thread T_7;
    .scope S_0x15b626cf0;
T_8 ;
    %pushi/vec4 0, 0, 1;
    %store/vec4 v0x15b627290_0, 0, 1;
    %pushi/vec4 30, 0, 32;
    %cvt/rv/s;
    %load/vec4 v0x15b627320_0;
    %cvt/rv;
    %pushi/real 1099511627, 4056; load=0.00100000
    %pushi/real 3254780, 4034; load=0.00100000
    %add/wr;
    %mul/wr;
    %pushi/real 1099511627, 4056; load=0.00100000
    %pushi/real 3254780, 4034; load=0.00100000
    %add/wr;
    %mul/wr;
    %pushi/real 1099511627, 4056; load=0.00100000
    %pushi/real 3254780, 4034; load=0.00100000
    %add/wr;
    %mul/wr;
    %pushi/real 1099511627, 4056; load=0.00100000
    %pushi/real 3254780, 4034; load=0.00100000
    %add/wr;
    %mul/wr;
    %cmp/wr;
    %jmp/0xz  T_8.0, 5;
    %vpi_call 4 47 "$display", "saturn V reached 30km height" {0 0 0};
    %vpi_call 4 48 "$display", ">>> gimbal start..." {0 0 0};
T_8.0 ;
    %end;
    .thread T_8;
    .scope S_0x15b614870;
T_9 ;
    %pushi/vec4 263, 0, 64;
    %store/vec4 v0x15b6285f0_0, 0, 64;
    %pushi/vec4 3233500, 0, 64;
    %store/vec4 v0x15b6282b0_0, 0, 64;
    %pushi/vec4 2077000, 0, 64;
    %store/vec4 v0x15b628430_0, 0, 64;
    %pushi/vec4 168, 0, 64;
    %store/vec4 v0x15b628170_0, 0, 64;
    %pushi/vec4 0, 0, 1;
    %store/vec4 v0x15b6284c0_0, 0, 1;
    %pushi/vec4 0, 0, 1;
    %store/vec4 v0x15b628200_0, 0, 1;
    %pushi/vec4 0, 0, 2;
    %store/vec4 v0x15b628550_0, 0, 2;
    %pushi/vec4 0, 0, 1;
    %store/vec4 v0x15b628730_0, 0, 1;
    %pushi/vec4 0, 0, 64;
    %store/vec4 v0x15b6288e0_0, 0, 64;
    %end;
    .thread T_9;
    .scope S_0x15b614870;
T_10 ;
    %delay 10, 0;
    %pushi/vec4 1, 0, 1;
    %store/vec4 v0x15b6284c0_0, 0, 1;
    %pushi/vec4 1, 0, 1;
    %store/vec4 v0x15b628730_0, 0, 1;
    %end;
    .thread T_10;
    .scope S_0x15b614870;
T_11 ;
    %load/vec4 v0x15b6288e0_0;
    %addi 1, 0, 64;
    %assign/vec4 v0x15b6288e0_0, 0;
    %delay 1000000, 0;
    %vpi_call 2 76 "$display", "\354\213\234\352\260\204 : %f", v0x15b6288e0_0 {0 0 0};
    %jmp T_11;
    .thread T_11;
    .scope S_0x15b614870;
T_12 ;
    %delay 168000000, 0;
    %vpi_call 2 86 "$finish" {0 0 0};
    %end;
    .thread T_12;
    .scope S_0x15b614870;
T_13 ;
    %delay 10, 0;
    %load/vec4 v0x15b628200_0;
    %inv;
    %assign/vec4 v0x15b628200_0, 0;
    %jmp T_13;
    .thread T_13;
    .scope S_0x15b614870;
T_14 ;
    %vpi_call 2 94 "$dumpfile", "output.vcd" {0 0 0};
    %vpi_call 2 95 "$dumpvars", 32'sb00000000000000000000000000000000, S_0x15b614870 {0 0 0};
    %end;
    .thread T_14;
# The file index is used to find the file name in the following table.
:file_names 6;
    "N/A";
    "<interactive>";
    "tb.v";
    "velocity.v";
    "gimbal30km.v";
    "numericalIntegral.v";
