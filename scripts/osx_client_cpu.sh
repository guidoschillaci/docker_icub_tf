xhost + 127.0.0.1

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
      -e DISPLAY=docker.for.mac.host.internal:0 \
      --name "$DOCKER_CONTAINER_NAME" \
      --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
      --volume="/Users/guido/Documents/code:/code/:rw"  \
      guidoski/icub:tf2-nogpu bash -c "
            yarpserver & iCub_SIM             "
fi

