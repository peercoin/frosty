#!/usr/bin/env bash

set -euo pipefail

script_dir=$(dirname "$(realpath "$0")")
repo_dir=$(realpath "$script_dir/..")
output_dir="$repo_dir/frosty/web/pkg"
image_name=frosty_rust_wasm_build

if command -v podman >/dev/null; then
  container_engine=podman
  volume_suffix=:Z
elif command -v docker >/dev/null; then
  container_engine=docker
  volume_suffix=
else
  echo "Podman or Docker is required" >&2
  exit 1
fi

mkdir -p "$output_dir"

"$container_engine" build \
  --file "$script_dir/build_wasm.Dockerfile" \
  --tag "$image_name" \
  "$repo_dir"

"$container_engine" run --rm \
  --volume "$output_dir:/output$volume_suffix" \
  "$image_name"
