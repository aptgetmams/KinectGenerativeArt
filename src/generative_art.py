import pygame
import numpy as np
from kinect_manager import KinectManager

class GenerativeArt:
    def __init__(self):
        pygame.init()
        self.resolution = (800, 600)
        self.screen = pygame.display.set_mode(self.resolution)
        self.clock = pygame.time.Clock()
        self.km = KinectManager()
        self.motion_threshold = 1.5
        self.particles = []

    def generate_pattern(self, motion_intensity):
        color = (np.sin(motion_intensity)*127+128, 
                np.cos(motion_intensity)*127+128, 
                255 - motion_intensity%255)
                
        num_circles = int(10 + motion_intensity * 2)
        for _ in range(num_circles):
            pos = (np.random.randint(0, self.resolution[0]), 
                  np.random.randint(0, self.resolution[1]))
            size = int(5 + motion_intensity % 50)
            pygame.draw.circle(self.screen, color, pos, size, 2)

    def run(self):
        running = True
        while running:
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    running = False

            depth = self.km.get_depth()
            motion = self.km.detect_motion(depth)
            
            if motion > self.motion_threshold:
                self.screen.fill((0, 0, 0))
                self.generate_pattern(motion * 10)
                pygame.display.flip()

            self.clock.tick(30)

        pygame.quit()

if __name__ == "__main__":
    art = GenerativeArt()
    art.run()
