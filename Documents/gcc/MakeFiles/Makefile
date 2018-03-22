gcc -c test.c test1.c
gcc -o output test.o test1.o -framework Carbon -framework OpenGL -framework GLUT -F /Library/Frameworks
#or
# gcc -o output1 test.c test1.c -framework Carbon -framework OpenGL -framework GLUT -F /Library/Frameworks

# link .o file
ld -r test1.o test.o -framework Carbon -framework OpenGL -framework GLUT -F /Library/Frameworks -o c.o
#.o file structure
# gcc -S test.c

#convert .o to .exe (.o file must have an entry point)
gcc c.o -o c.exe -framework Carbon -framework OpenGL -framework GLUT -F /Library/Frameworks -arch x86_64 -I/usr/local/include

# create .dylib
gcc -dynamiclib -o ltest.dylib -dy test.c

#or
gcc -dynamiclib -fPIC -o ltest1.dylib test.o test1.o -framework Carbon -framework OpenGL -framework GLUT -F /Library/Frameworks -arch x86_64  -I/usr/local/include


# create static .a Library
gcc -c example.c
ar -r libmylibrary.a  example.o
gcc main.c -lmylibrary -L. -I. #link the Library
