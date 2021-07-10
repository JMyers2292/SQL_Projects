import urllib.request
import cv2
import numpy as np
import time


video = cv2.VideoCapture(0)
t0 = time.clock()
num_frames = 120

while True:
    ret, frame = video.read()
    start = time.time()

    cv2.imshow("frame", frame)

    key = cv2.waitKey(1)

    if key == ord('q'):
        t1 = time.clock() - t0
        end = time.time()
        seconds = end - start
        break

video.release()
cv2.destroyAllWindows()
fps = num_frames / seconds
print("Time elapsed: {0:.2f} seconds".format(float(t1)))
print("FPS: {0:0.2f} ".format(fps))
