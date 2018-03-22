CC=clang # or gcc (tested with clang 3.2 and gcc 4.7.1)

LIBRARIES:= -lobjc
HEADERS:= -I/path/to/libobjc/headers

SOURCE=main.m

CFLAGS=-Wall -Werror -g -v $(HEADERS) $(SOURCE)
LDFLAGS=$(LIBRARIES)
OUT=-o main

all:
$(CC) $(CFLAGS) $(LDFLAGS) $(OUT)
