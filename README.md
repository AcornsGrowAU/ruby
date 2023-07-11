# docker-ruby

This repository provides Fedora-based Ruby Docker images.


## How to build multiplatform images

Requires Docker desktop 24.0.2.  
You need to have containerd image storage enabled in your Docker Desktop. It's part of the experimental features.  


1. `docker buildx create --bootstrap`
2. `docker buildx bake --pull --load`