all: build
build:
	zig build

.PHONY: run
run:
	zig build run

.PHONY: test
test:
	zig test src/wls.zig

.PHONY: style-fix
style-fix:
	zig fmt .

.PHONY: clean
clean:
	rm -rf zig-out
	rm -rf .zig-cache
