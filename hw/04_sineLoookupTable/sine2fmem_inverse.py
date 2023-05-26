#!/usr/bin/env python3

from math import ceil, sin, pi
import sys

# math.sin works in radians: 0-90° == π/2 radians

if (len(sys.argv) > 1):
    rows = int(sys.argv[1])
else:
    rows = 256

if (len(sys.argv) > 2):
    width = int(sys.argv[2])
else:
    width = 16

fmt_width = str(ceil(width/4))  # four bits per hex digit
fmt_string = "{:0" + fmt_width + "X}  // {:03}: isin({:.4f}) = {:.4f}"
'''
    "{:0" + fmt_width + "X}"
    {:04X} => 4자리로 16진수(X)를 표시해라.
    :0 => 0를 빈칸에 채워라
    4 => 채울 빈칸은 4자리다
    X => 16진수다
'''
'''
for i in range(rows):
    val = (pi/(2*rows)) * i     # 얘는 각도야.
    res = sin(val)              # 얘는 사인값이고.
    res_scaled = round((2**width) * res)    # 사인값은 0~1사이의 소수니까 소수를 없애줘
    if res_scaled == 2**width:  # maximum value uses too many bits
        res_scaled -= 1;        # accompanying Verilog module handles this
    print(fmt_string.format(res_scaled, i, val, res)) # 그러면 각도가 주어지면(대충256나눠서) 얘는 사인값을 출력하는거네
'''
for i in range(rows):
    val = (pi/(2*rows)) * i     # 얘는 각도야.
    res = sin(val)              # 얘는 사인값이고.
    # 출력할건 각도니까 0~90 얘를 처리하자. 소수 4째자리까지 출력하자.
    val_scaled = round(val * 10**4)
    # if val_scaled == sin(pi/2) * 10**4:
    #     val_scaled -= 1; #얘는 여기서는 overflow가 안 나니까 필요는 없다.
    print(fmt_string.format(val_scaled, i, res, val))
    # 3D1F = 15647 이다. 얘는 pi/2 에 근사값이다.
    # 061D = 1565 이다. 얘도 pi/2 에 근사값이다. 진짜 베릴로그 말고 파이썬으로 짜라하면 좋겠다.