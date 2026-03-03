#!/bin/sh
set -eu

# This is the entrypoint for the Magika Python client Docker image.
# It simply executes the magika-python-client command with any arguments passed to the container.
exec magika-python-client "$@"
