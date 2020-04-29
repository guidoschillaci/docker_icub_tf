docker-compose down
xhost +local:docker
docker-compose up 
#xhost -local:docker

#docker run -it \
#    --env="DISPLAY:192.168.1.229:0" \
#    --env="NVIDIA_VISIBLE_DEVICES=${NVIDIA_VISIBLE_DEVICES:-all}" \
#    --env="NVIDIA_DRIVER_CAPABILITIES=${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics" \
#    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
#    -p10000:10000 \
#    --gpus all \
#    -v ~/code:/code \
#    guido/robotology-tdd bash

