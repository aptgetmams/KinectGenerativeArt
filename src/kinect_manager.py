import freenect
import cv2
import numpy as np

class KinectManager:
    def __init__(self):
        self.prev_depth = None
        self.running = True

    def get_depth(self):
        depth, _ = freenect.sync_get_depth()
        return cv2.resize(depth, (320, 240))

    def detect_motion(self, current_depth):
        if self.prev_depth is None:
            self.prev_depth = current_depth
            return 0
            
        diff = cv2.absdiff(current_depth, self.prev_depth)
        motion_intensity = np.mean(diff)
        self.prev_depth = current_depth
        
        return motion_intensity
