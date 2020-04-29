xhost +local:root

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
      -e DISPLAY \
      --runtime=nvidia \
      --gpus all \
      --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
      guidoski/icub:tf1.12.3-gpu-py3 bash -c "
             yarpserver --ip 172.19.0.2 --socket 10000
             "
#--volume="/home/guido/code:/code/" \
#&
#             yarp detect --write &&
#             yarprun --server /main_yarpserver "
fi


#from tensorflow.python.client import device_lib
#print(device_lib.list_local_devices())
