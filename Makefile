all: build gather check

CWD ?= $(strip $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))
ARCH = $(shell uname -p)

.PHONY: build
build: build/wasm-bindgen
	podman build -f containers/base/0.1.0 -t base:0.1.0
	mkdir -p "out/$(ARCH)"

	podman run --rm -ti -v $(CWD)/out/$(ARCH):/out:z base:0.1.0 /root/.cargo/bin/cargo install trunk --version "^0.14.0" --root /out

.PHONY: build/wasm-bindgen
build/wasm-bindgen:
	podman run --rm -ti -v $(CWD)/out/$(ARCH):/out:z base:0.1.0 /root/.cargo/bin/cargo install wasm-bindgen-cli --version "=0.2.79" --root /out

.PHONY: gather
gather:
	mkdir -p "binaries/$(ARCH)"

	install -m 0555 out/$(ARCH)/bin/trunk "binaries/$(ARCH)"
	xz -f "binaries/$(ARCH)/trunk"
	install -m 0555 out/$(ARCH)/bin/wasm-bindgen "binaries/$(ARCH)"
	xz -f "binaries/$(ARCH)/wasm-bindgen"

check:
	git status