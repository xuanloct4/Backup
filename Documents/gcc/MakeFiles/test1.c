#ifdef __APPLE__
#  include <OpenGL/gl.h>
#  include <OpenGL/glu.h>
#  include <GLUT/glut.h>
#else
#  include <GL/gl.h>
#  include <GL/glu.h>
#  include <GL/glut.h>
#endif

int main1(int argc, char **argv)
{
    glutInit(&argc, argv);
//    glutDisplayFunc(display);
    glutMainLoop();
}
