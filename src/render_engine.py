import glfw
import OpenGL.GL as gl

class GLWindow:
    def __init__(self):
        glfw.init()
        self.window = glfw.create_window(640, 480, "Kinect Art", None, None)
        glfw.make_context_current(self.window)
    
    def render(self, data):
        gl.glClear(gl.GL_COLOR_BUFFER_BIT)
        # Logique de rendu simplifiée
        glfw.swap_buffers(self.window)
        glfw.poll_events()
