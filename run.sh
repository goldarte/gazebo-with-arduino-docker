#!/usr/bin/env bash
xhost +local:docker

# check gpu access
GPU_DOCKER_ARG="--gpus all"
if ! nvidia-smi > /dev/null 2>&1; then
    echo "No NVIDIA GPU detected. Running without GPU support."
    GPU_DOCKER_ARG=""
fi  

docker run -it --rm \
    --device /dev/dri:/dev/dri \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v arduino_cache:/home/ubuntu/.config/arduino \
    -v arduino_data:/home/ubuntu/.arduino15 \
    -v arduino_home:/home/ubuntu/Arduino \
    --network host \
    --name gazebo_with_arduino \
    $GPU_DOCKER_ARG \
    goldarte/gazebo-with-arduino \
    bash
