# You can configure these
PREFIX ?= /usr/local
LIBDIR ?= $(PREFIX)/lib
INCLUDEDIR ?= $(PREFIX)/include
PKGCONFIGDIR ?= $(LIBDIR)/pkgconfig
DESTDIR ?= ""

VERSION=$(shell grep '^version = "4' Cargo.toml | grep -Eo "4\.[0-9.]+")
STATICLIB=libimagequant.a

CC_MAC = gcc
CC_WIN = x86_64-w64-mingw32-gcc
CC_UNIX = gcc

CFLAGS_MAC = -g -Wall
CFLAGS_WIN = -g -Wall
CFLAGS_UNIX = -g -Wall

LDFLAGS_MAC = -L/usr/local/Cellar/libimagequant/4.2.0/lib -limagequant
LDFLAGS_WIN =
LDFLAGS_UNIX =

INCLUDES_MAC = -I/usr/local/Cellar/libimagequant/4.2.0/include -Iinclude
INCLUDES_WIN =
INCLUDES_UNIX =

TARGET_MAC = main_mac
TARGET_WIN = main.exe
TARGET_UNIX = main_unix
TARGET_WIN_TEST = test.exe

all: $(TARGET_MAC) $(TARGET_UNIX)
test: $(TARGET_WIN_TEST)


$(TARGET_WIN_TEST): test.c
	$(CC_WIN) $(CFLAGS_WIN) $(INCLUDES_WIN) $(LDFLAGS_WIN) test.c -lm -o $(TARGET_WIN_TEST)

$(TARGET_WIN): main.c lodepng.h lodepng.c $(STATICLIB)
	$(CC_WIN) $(CFLAGS_WIN) $(INCLUDES_WIN) $(LDFLAGS_WIN) main.c $(STATICLIB) -lm -o $(TARGET_WIN)

$(TARGET_UNIX): main.c lodepng.h lodepng.c $(STATICLIB)
	$(CC_UNIX) $(CFLAGS_UNIX) $(INCLUDES_UNIX) $(LDFLAGS_UNIX) main.c $(STATICLIB) -lm -o $(TARGET_UNIX)

$(TARGET_MAC): main.c lodepng.h lodepng.c $(STATICLIB)
	$(CC_MAC) $(CFLAGS_MAC) $(INCLUDES_MAC) $(LDFLAGS_MAC) main.c $(STATICLIB) -lm -o $(TARGET_MAC)
	
lodepng.h:
	curl -o lodepng.h -L https://raw.githubusercontent.com/lvandeve/lodepng/master/lodepng.h

lodepng.c:
	curl -o lodepng.c -L https://raw.githubusercontent.com/lvandeve/lodepng/master/lodepng.cpp

clean:
	rm -f $(SHAREDLIBVER) $(SHAREDLIB)
	rm -f $(TARGET_MAC) $(TARGET_WIN) $(TARGET_UNIX) $(TARGET_WIN_TEST) lodepng.c lodepng.h
	rm -rf ../target

distclean: clean
	rm -f imagequant.pc

install: all $(PKGCONFIG)
	install -d $(DESTDIR)$(LIBDIR)
	install -d $(DESTDIR)$(PKGCONFIGDIR)
	install -d $(DESTDIR)$(INCLUDEDIR)
	install -m 644 $(STATICLIB) $(DESTDIR)$(LIBDIR)/$(STATICLIB)
	install -m 644 $(PKGCONFIG) $(DESTDIR)$(PKGCONFIGDIR)/$(PKGCONFIG)
	install -m 644 libimagequant.h $(DESTDIR)$(INCLUDEDIR)/libimagequant.h
	$(FIX_INSTALL_NAME)

uninstall:
	rm -f $(DESTDIR)$(LIBDIR)/$(STATICLIB)
	rm -f $(DESTDIR)$(PKGCONFIGDIR)/$(PKGCONFIG)
	rm -f $(DESTDIR)$(INCLUDEDIR)/libimagequant.h

.PHONY: all clean distclean install uninstall
.DELETE_ON_ERROR:
