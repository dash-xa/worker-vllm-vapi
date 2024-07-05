#!/usr/bin/env bash
set -euxo pipefail

pushd ..
model_name="${1:-sasdkafjlk/NeverSleep-Noromaid-13b-v0.3}"
image_name="${2:-shevrlex/scarlett:latest}"
docker login
docker build -t "$image_name" --build-arg MODEL_NAME="$model_name" .
docker push "$image_name"
popd
