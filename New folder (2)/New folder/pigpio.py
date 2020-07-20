import cv2
import cv2.cv as cv
import numpy as np
import math
import time
import pigpio

ex = 100
ye = 200

pi = pigpio.pi()

if not pi.connected:
    exit(0)

h = pi.spi_open(0, 500000)

while (1):
    
    pi.spi_xfer(h, "!" + "{}".format(ex) + "|" + "@" + "{}".format(ye) + "|" + "\n")

    k = cv2.waitKey(1) & 0xFF
    if k == 27:
        break
    
pi.spi_close(h)
pi.stop()
