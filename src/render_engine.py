import glfw
import OpenGL.GL as gl

class GLWindow:
    def __init__(self):
        glfw.init()
        self.window = glfw.create_window(640, 480, "Kinect Art", None, None)
        glfw.make_context_current(self.window)

    # Chargement des shaders
    #    self.shader = self.compile_shaders()
    
    def render(self, data):
        gl.glClear(gl.GL_COLOR_BUFFER_BIT)
        # Logique de rendu simplifiée
        glfw.swap_buffers(self.window)
        glfw.poll_events()
    
#    def compile_shaders(self):
#        vertex_shader = open('shaders/vertex.glsl').read()
#        fragment_shader = open('shaders/fragment.glsl').read()
        
        # [...] Logique de compilation OpenGL
