# docker-ruby

This repository provides Rocky Linux-based Ruby Docker images.

## Build

Create a builder:

```bash
docker buildx create --use --name builder
```

The bake config builds for `linux/amd64` and `linux/arm64` by default. `--load` only supports a single platform unless the [containerd image store](https://docs.docker.com/storage/containerd/) is enabled.

Load a single platform locally:

```bash
docker buildx bake --load --set="*.platforms=linux/amd64"
```

Push multi-platform to a registry:

```bash
docker buildx bake --push
```

Or omit the output flag to build into cache only:

```bash
docker buildx bake
```
