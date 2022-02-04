all: build gather check

.PHONY: build
build:
	podman build -f containers/base/0.1.0 -t base:0.1.0
	mkdir -p out
	podman run --rm -ti -v $PWD/out:/out:z base:0.1.0 /root/.cargo/bin/cargo install trunk --version "^0.14.0" --root /out

.PHONY: gather
gather:
	mkdir -p "binaries/$(uname -p)"
	install -m 0555 out/trunk "binaries/$(uname -p)"

check:
	git status