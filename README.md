# docker-ruby

This repository provides Rocky Linux-based Ruby Docker images.

## Build

Create a builder:

```bash
docker buildx create --use --name builder
```

Build for `linux/amd64` and export images to the default image store (`docker images`):

```bash
docker buildx bake --load
```

Build for a different or multiple architectures:

```bash
docker buildx bake --load --set="*.platform=linux/amd64,linux/arm64"
```

Note that building images for multiple architectures requires one of the following:

* [Containerd image store](https://docs.docker.com/storage/containerd/) for the `--load` flag to work
* Pushing directly to a registry, e.g. `docker buildx bake --push --set="*.platform=linux/amd64,linux/arm64"`
* Using other [output types](https://docs.docker.com/reference/cli/docker/buildx/build/#output) or omitting output flags to keep build cache only

