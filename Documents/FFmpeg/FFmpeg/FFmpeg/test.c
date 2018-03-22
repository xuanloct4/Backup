#ifdef __APPLE__
#  include <stdio.h>
#else
#  include <GL/gl.h>
#  include <GL/glu.h>
#  include <GL/glut.h>
#endif
void display()
{
    printf("test: Helllo! \n");
}

int main1()
{
    display();
//    glutInit(&argc, argv);
//    glutDisplayFunc(display);
//    glutMainLoop();
    return 0;
}
