#!/usr/bin/env bash

docker buildx build \
  --platform=linux/arm64,linux/amd64 \
  -t kodereaderapp:latest \
  -t kodereaderapp:0.0.1 \
  .
