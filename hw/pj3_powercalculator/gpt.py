def power(base, exponent):
    result = 1

    if exponent < 0:
        base = 1 / base
        exponent = -exponent

    # Calculate the integer part of the exponent
    int_part = int(exponent)
    result = iterative_power(base, int_part)

    # Calculate the fractional part of the exponent using natural logarithm
    frac_part = exponent - int_part
    result *= exponential(base, frac_part)

    return result

def iterative_power(base, exponent):
    result = 1
    for _ in range(exponent):
        result *= base
    return result

def exponential(base, exponent):
    result = 1
    term = 1
    n = 1

    while term > 1e-10:  # Adjust the threshold for desired precision
        term *= exponent / n
        result += term
        n += 1

    return result


import math
ref = math.exp(4)

# 오차가 너무 심하다.