
if [ -z "$1" ]
  then
    echo "No argument supplied. I need an ip address of the client pc, or just localhost."
    exit 1
fi

ipclient=$1


export DOCKER_CONTAINER_NAME=icub_container
if [ ! "$(docker ps -q -f name=${DOCKER_CONTAINER_NAME})" ]; then
    if [ "$(docker ps -aq -f status=exited -f name=${DOCKER_CONTAINER_NAME})" ]; then
        echo "Cleaning up existing container named ${DOCKER_CONTAINER_NAME}"
        # cleanup
        docker rm $DOCKER_CONTAINER_NAME
    fi
    # run your container 
    docker run -it --rm \
      --name "$DOCKER_CONTAINER_NAME" \
      -e DISPLAY=$ipclient:0 \
      --env="NVIDIA_VISIBLE_DEVICES=${NVIDIA_VISIBLE_DEVICES:-all}" \
      --env="NVIDIA_DRIVER_CAPABILITIES=${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics" \
     -p10000:10000 \
      --runtime=nvidia \
      --gpus all \
      --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
      --volume="/home/guido/code:/code/:rw"  \
      guidoski/icub:tf1.12.3-gpu-py3 bash -c "
             yarpserver --ip 172.19.0.2 --socket 10000 & iCub_SIM
             "
#--volume="/home/guido/code:/code/" \
#&
#             yarp detect --write &&
#             yarprun --server /main_yarpserver "
fi


#from tensorflow.python.client import device_lib
#print(device_lib.list_local_devices())
