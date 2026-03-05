#!/bin/sh
set -eu

# Entrypoint for the Magika Docker image.
# Execute the Magika CLI directly with any arguments passed to the container.
exec magika "$@"
