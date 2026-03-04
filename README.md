# Docker Magika

[![cd](https://github.com/jonlabelle/docker-magika/actions/workflows/cd.yml/badge.svg)](https://github.com/jonlabelle/docker-magika/actions/workflows/cd.yml)
[![docker pulls](https://img.shields.io/docker/pulls/jonlabelle/magika)](https://hub.docker.com/r/jonlabelle/magika)
[![image size](https://img.shields.io/docker/image-size/jonlabelle/magika/latest?label=image%20size)](https://hub.docker.com/r/jonlabelle/magika/tags)

> Docker image for [Magika](https://securityresearch.google/magika/introduction/overview), a novel AI-powered file type detection tool that relies on the recent advance of deep learning to provide accurate detection.

## Quick start

```bash
# Show Magika CLI help (default command)
docker run --rm jonlabelle/magika:latest

# Show version
docker run --rm jonlabelle/magika:latest --version

# Scan a file from the current directory
docker run --rm -v "$PWD:/workspace:ro" jonlabelle/magika:latest README.md

# Scan files matching a shell glob (expanded by your shell)
docker run --rm -v "$PWD:/workspace:ro" jonlabelle/magika:latest *.md

# Recursively scan all files in the current directory tree
docker run --rm -v "$PWD:/workspace:ro" jonlabelle/magika:latest --recursive .
```

## Image details

- Base image: `python:slim`
- Entrypoint: `magika-python-client` (via `entrypoint.sh`)
- Default command: `--help`
- Runtime user: non-root (`magika`)
- Working directory: `/workspace` (so mounted files can be referenced relatively)
- Magika package: latest from PyPI (`pip install magika`)
- Architectures: `linux/amd64`, `linux/arm64`

## Tags

- `latest`
- `sha-<short-commit>`

## Local development

```bash
make lint
make build
make run ARGS="--version"
make run ARGS="README.md"
```

If `docker` is unavailable, the `Makefile` also supports `podman` and `nerdctl`.

## Publishing

GitHub Actions (`.github/workflows/cd.yml`) builds and publishes multi-arch images to:

- Docker Hub: `jonlabelle/magika`
- GHCR: `ghcr.io/jonlabelle/magika`

The same workflow runs post-publish registry pruning via [`scripts/prune`](scripts/prune).
