import cv2
import numpy as np
import time

video = cv2.VideoCapture("http://192.168.1.133:8080/video")

while(True):
    start = time.process_time()
    # ret = isThere a frame (T or F), frame = the video frame itself
    ret, frame = video.read()
    cv2.imshow("Livestream", frame)  # (Name of the window)
    key = cv2.waitKey(1)
    if key == ord('q'):
        end = time.process_time() - start
        break


video.release()
cv2.destroyAllWindows()
print("Total Time Recorded: {0:.2f} seconds".format(end))
