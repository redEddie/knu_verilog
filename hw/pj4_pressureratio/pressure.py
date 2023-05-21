import math
from itertools import count

def pressureof(hegiht):
    pressure = math.pow(1-hegiht/44307.694, 5.25530)
    return pressure


for height in count():
    if pressureof(height) <= 1e-3 :
        break
    
    pressure = pressureof(height)
    print('ratio is ' + str(pressure) + ' for altitude ' + str(height) + 'm or ' + str(0.001*height) + 'km')

