# docker-ruby

This repository provides Rocky Linux-based Ruby Docker images.

## Building

Build for the current architecture:

```bash
docker buildx create --use --name builder
docker buildx bake --pull --load
```
