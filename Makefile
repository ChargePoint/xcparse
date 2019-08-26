prefix ?= /usr/local
bindir = $(prefix)/bin
libdir = $(prefix)/lib

build:
	swift build -c release --disable-sandbox

install: build
ifeq ($(shell gem list \^xcpretty\$$ -i), false)
	gem install xcpretty
endif
ifeq ($(shell gem list \^xcpretty-json-formatter\$$ -i), false)
	gem install xcpretty-json-formatter
endif
	install ".build/release/xcparse" "$(bindir)"

uninstall:
	rm -rf "$(bindir)/xcparse"

clean:
	rm -rf .build

.PHONY: build install uninstall clean
