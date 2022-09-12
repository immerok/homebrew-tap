#!/usr/bin/env bash

command -v "curl" >/dev/null || {
  echo "curl is required"
  exit 1
}

command -v "shasum" >/dev/null || {
  echo "shasum is required"
  exit 1
}

command -v "yq" >/dev/null || {
  echo "yq is required"
  exit 1
}

version="${1:-}"

config="./configs/rok.yaml"
yq -i ".version = \"${version}\"" "${config}"

for os in darwin linux; do
  for arch in amd64 arm64; do
    fn="rok-${os}-${arch}.tar.gz"

    echo "Processing ${fn}"
    checksum="$(curl -sL "https://releases.immerok.cloud/rok/v${version}/${fn}" | shasum -a 256 | cut -d ' ' -f 1)"
    yq -i ".sha256[\"${os}\"][\"${arch}\"] = \"${checksum}\"" "${config}"
  done
done
