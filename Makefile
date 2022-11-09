all: build check

CWD ?= $(strip $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))
ARCH = $(shell uname -p)

.PHONY: setup
setup:
	mkdir -p "out/$(ARCH)"
	mkdir -p "binaries/$(ARCH)"

.PHONY: build
build: setup
build: build/base/0.2.0
build: build/trunk/0.16.0
build: build/wasm-bindgen/0.2.82
build: build/diesel/1.4.1
build: build/diesel/2.0.1

.PHONY: build/base/%
build/base/%:
	podman build -f containers/base/$*/Dockerfile -t base:$*

.PHONY: build/trunk/%
build/trunk/%:
	podman run --rm -ti -v $(CWD)/out/$(ARCH):/out:z base:0.2.0 /root/.cargo/bin/cargo install trunk --version "=$*" --root /out
	mkdir -p "binaries/$(ARCH)/trunk/$*"
	install -m 0555 out/$(ARCH)/bin/trunk "binaries/$(ARCH)/trunk/$*/"
	xz -f "binaries/$(ARCH)/trunk/$*/trunk"

.PHONY: build/wasm-bindgen/%
build/wasm-bindgen/%:
	podman run --rm -ti -v $(CWD)/out/$(ARCH):/out:z base:0.2.0 /root/.cargo/bin/cargo install wasm-bindgen-cli --version "=$*" --root /out
	mkdir -p "binaries/$(ARCH)/wasm-bindgen/$*"
	install -m 0555 out/$(ARCH)/bin/wasm-bindgen "binaries/$(ARCH)/wasm-bindgen/$*/"
	xz -f "binaries/$(ARCH)/wasm-bindgen/$*/wasm-bindgen"

.PHONY: build/diesel/%
build/diesel/%:
	podman run --rm -ti -v $(CWD)/out/$(ARCH):/out:z base:0.2.0 /root/.cargo/bin/cargo install diesel_cli --no-default-features --features postgres --version "=$*" --root /out
	mkdir -p "binaries/$(ARCH)/diesel/$*"
	install -m 0555 out/$(ARCH)/bin/diesel "binaries/$(ARCH)/diesel/$*/"
	xz -f "binaries/$(ARCH)/diesel/$*/diesel"

check:
	git status
