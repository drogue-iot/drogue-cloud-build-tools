# Build tools required by Drogue Cloud

The [drogue-cloud-build-containers](https://github.com/drogue-iot/drogue-cloud-build-containers) repository assembles
a few containers required for the build of Drogue Cloud.

For this, some binaries are required. And. some of them can easily be downloaded. However, some others need to be built.
Especially for the aarch64 architecture, some binaries don't come pre-built by projects.

Theoretically, that could all be done as part of the container build. However, especially when building non-`amd64`
images, this takes an enormous amount of time. Every time the container image is rebuilt.

In order to safe this time, this repository contains the recipes to pre-build those binaries in a manual way.
