#!/usr/bin/env bash

set -e

if [ -z "$1" ]; then
  echo "Usage: docker run <image> <image_url>"
  exit 1
fi

IMAGE_URL="$1"

cd /opt/darknet

echo "==> Downloading image from URL:"
echo "    $IMAGE_URL"

wget -O input.jpg "$IMAGE_URL"

echo "==> Running YOLOv3 detection..."
./darknet detector test cfg/coco.data cfg/yolov3.cfg yolov3.weights input.jpg -dont_show -ext_output

cp predictions.jpg /workspace/output.jpg
