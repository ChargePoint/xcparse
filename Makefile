prefix ?= /usr/local
bindir = $(prefix)/bin
libdir = $(prefix)/lib

build:
	swift build -c release --disable-sandbox

install: build
	install ".build/release/xcparse" "$(bindir)"

uninstall:
	rm -rf "$(bindir)/xcparse"

clean:
	rm -rf .build

.PHONY: build install uninstall clean
