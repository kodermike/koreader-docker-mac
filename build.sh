#!/usr/bin/env bash

docker buildx build \
  --platform=linux/amd64 \
  -t kodereaderapp:latest \
  -t kodereaderapp:0.0.1 \
  .
