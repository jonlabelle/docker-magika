NAME := magika
ARM_NAME := magika-arm64

TAG ?= dev
ARGS ?= --help

IMAGE_NAME := $(NAME):$(TAG)
ARM_IMAGE_NAME := $(ARM_NAME):$(TAG)

# Determine if docker, podman, or nerdctl is installed
DOCKER ?= $(shell command -v docker 2> /dev/null || command -v podman 2> /dev/null || command -v nerdctl 2> /dev/null)
TTY_FLAGS := $(shell if [ -t 0 ]; then echo "--interactive --tty"; fi)

ifeq ($(strip $(DOCKER)),)
$(error No container runtime found. Install docker, podman, or nerdctl)
endif

.PHONY: default
default: help

.PHONY: all
all: ## Lints the Dockerfile and builds the image
	$(MAKE) lint
	$(MAKE) build

.PHONY: lint
lint: ## Lints the Dockerfile
	@$(DOCKER) run --rm --interactive docker.io/hadolint/hadolint:latest < Dockerfile

.PHONY: build
build: ## Builds a local dev image (magika:dev)
	@$(DOCKER) build --tag "$(IMAGE_NAME)" .

.PHONY: build-arm
build-arm: ## Builds the linux/arm64 image (magika-arm64:dev)
	@$(DOCKER) buildx create --use --name magika-builder 2>/dev/null || $(DOCKER) buildx use magika-builder
	@$(DOCKER) buildx build --platform linux/arm64 --output type=docker --tag "$(ARM_IMAGE_NAME)" .

.PHONY: run
run: ## Runs the image locally (usage: make run ARGS="--version")
	$(MAKE) build
	@$(DOCKER) run --rm $(TTY_FLAGS) -v "$(PWD):/workspace:ro" "$(IMAGE_NAME)" $(ARGS)

.PHONY: run-arm
run-arm: ## Runs the linux/arm64 image locally
	$(MAKE) build-arm
	@$(DOCKER) run --rm $(TTY_FLAGS) --platform linux/arm64 -v "$(PWD):/workspace:ro" "$(ARM_IMAGE_NAME)" $(ARGS)

.PHONY: clean
clean: ## Removes the built images
	@$(DOCKER) rmi "$(IMAGE_NAME)"; true
	@$(DOCKER) rmi "$(ARM_IMAGE_NAME)"; true
	@$(DOCKER) rmi hadolint/hadolint; true
	@$(DOCKER) buildx rm magika-builder; true
	@$(DOCKER) buildx rm --all-inactive --force; true
	@$(DOCKER) buildx prune --force; true

.PHONY: help
help: ## Shows this help message
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST)  | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
