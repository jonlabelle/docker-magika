#!/bin/sh
set -eu

# Entrypoint for the Magika Docker image.
# Prefer the Rust CLI when available; fall back to the legacy Python CLI on
# platforms where prebuilt Rust binaries are unavailable.
if command -v magika > /dev/null 2>&1; then
  if magika_probe_output="$(magika --version 2>&1)"; then
    exec magika "$@"
  fi

  case "${magika_probe_output}" in
    *"magika-python-client"*)
      if command -v magika-python-client > /dev/null 2>&1; then
        exec magika-python-client "$@"
      fi
      printf '%s\n' "${magika_probe_output}" >&2
      echo "ERROR: magika-python-client is required on this platform but was not found." >&2
      exit 127
      ;;
    *)
      printf '%s\n' "${magika_probe_output}" >&2
      exit 1
      ;;
  esac
fi

if command -v magika-python-client > /dev/null 2>&1; then
  exec magika-python-client "$@"
fi

echo "ERROR: neither 'magika' nor 'magika-python-client' is available in PATH." >&2
exit 127
