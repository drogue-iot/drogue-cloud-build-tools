# x86_64

```shell
podman build ../../base/0.1.0 -t base:0.1.0
mkdir -p out
podman run --rm -ti -v $PWD/out:/out:z base:0.1.0 /root/.cargo/bin/cargo install trunk --version "^0.14.0" --root /out
```

# aarch64