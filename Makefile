all: build check

CWD ?= $(strip $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))
ARCH = $(shell uname -p)

.PHONY: setup
setup:
	mkdir -p "out/$(ARCH)"
	mkdir -p "binaries/$(ARCH)"

.PHONY: build
build: setup
build: build/base/0.1.0 build/base-ubuntu/0.1.0
build: build/trunk/0.14.0 build/wasm-bindgen/0.2.79

.PHONY: build/base/0.1.0
build/base/0.1.0:
	podman build -f containers/base/0.1.0 -t base:0.1.0

.PHONY: build/base-ubuntu/0.1.0
build/base-ubuntu/0.1.0:
	podman build -f containers/base-ubuntu/0.1.0 -t base-ubuntu:0.1.0

.PHONY: build/trunk/0.14.0
build/trunk/0.14.0:
	podman run --rm -ti -v $(CWD)/out/$(ARCH):/out:z base:0.1.0 /root/.cargo/bin/cargo install trunk --version "=0.14.0" --root /out
	mkdir -p "binaries/$(ARCH)/trunk/0.14.0"
	install -m 0555 out/$(ARCH)/bin/trunk "binaries/$(ARCH)/trunk/0.14.0/"
	xz -f "binaries/$(ARCH)/trunk/0.14.0/trunk"

.PHONY: build/wasm-bindgen/0.2.79
build/wasm-bindgen/0.2.79:
	podman run --rm -ti -v $(CWD)/out/$(ARCH):/out:z base:0.1.0 /root/.cargo/bin/cargo install wasm-bindgen-cli --version "=0.2.79" --root /out
	mkdir -p "binaries/$(ARCH)/wasm-bindgen/0.2.79"
	install -m 0555 out/$(ARCH)/bin/wasm-bindgen "binaries/$(ARCH)/wasm-bindgen/0.2.79/"
	xz -f "binaries/$(ARCH)/wasm-bindgen/0.2.79/wasm-bindgen"

.PHONY: build/dart-sass/1.37.5
build/dart-sass/1.37.5:
	podman run --rm -ti -v $(CWD)/out/$(ARCH):/out:z base-ubuntu:0.1.0 bash -c 'git clone https://github.com/sass/dart-sass.git --depth 1 --branch 1.37.5 && cd dart-sass && dart pub get && dart compile exe bin/sass.dart -o /out/bin/dart-sass'
	mkdir -p "binaries/$(ARCH)/dart-sass/1.37.5"
	install -m 0555 out/$(ARCH)/bin/dart-sass "binaries/$(ARCH)/dart-sass/1.37.5/"
	xz -f "binaries/$(ARCH)/dart-sass/1.37.5/dart-sass"

check:
	git status