from kinect import KinectV1
from render_engine import GLWindow
import cv2

kinect = KinectV1()
window = GLWindow()

while True:
    depth = kinect.get_depth_frame()
    processed = cv2.blur(depth, (5,5))
    window.render(processed)
