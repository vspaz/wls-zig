TARGET=wls

build:
	zig build

run:
	zig build run

.PHONY: test
test:
	zig test src/main.zig

.PHONY: style-fix
style-fix:
	zig fmt .
