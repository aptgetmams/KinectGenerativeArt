import freenect

class KinectV1:
    def __init__(self):
        self.ctx = freenect.init()
        self.dev = freenect.open_device(self.ctx, 0)
    
    def get_depth_frame(self):
        return freenect.sync_get_depth()
