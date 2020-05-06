# readapated from https://blog.yadutaf.fr/2017/09/10/running-a-graphical-app-in-a-docker-container-on-a-remote-server/
# Open an SSH connection to the remote server
#ssh -X guido@192.168.1.163
export DOCKER_CONTAINER_NAME=icub_container

# Prepare target env
CONTAINER_DISPLAY="0"
CONTAINER_HOSTNAME="icub"

# Create a directory for the socket
mkdir -p display/socket
touch display/Xauthority


# Get the DISPLAY slot
DISPLAY_NUMBER=$(echo $DISPLAY | cut -d. -f1 | cut -d: -f2)

# Extract current authentication cookie
AUTH_COOKIE=$(xauth list | grep "^$(hostname)/unix:${DISPLAY_NUMBER} " | awk '{print $3}')

# Create the new X Authority file
xauth -f display/Xauthority add ${CONTAINER_HOSTNAME}/unix:${CONTAINER_DISPLAY} MIT-MAGIC-COOKIE-1 ${AUTH_COOKIE}

# Proxy with the :0 DISPLAY
socat TCP4:localhost:60${DISPLAY_NUMBER} UNIX-LISTEN:display/socket/X${CONTAINER_DISPLAY} &

export DOCKER_CONTAINER_NAME=icub_container
if [ ! "$(docker ps -q -f name=${DOCKER_CONTAINER_NAME})" ]; then
    if [ "$(docker ps -aq -f status=exited -f name=${DOCKER_CONTAINER_NAME})" ]; then
        echo "Cleaning up existing container named ${DOCKER_CONTAINER_NAME}"
        # cleanup
        docker rm $DOCKER_CONTAINER_NAME
    fi
	# Launch the container
	docker run -it --rm \
	  --name "$DOCKER_CONTAINER_NAME" \
	  -e DISPLAY=:${CONTAINER_DISPLAY} \
	  -v ${PWD}/display/socket:/tmp/.X11-unix \
	  -v ${PWD}/display/Xauthority:/home/xterm/.Xauthority \
	      --env="NVIDIA_VISIBLE_DEVICES=${NVIDIA_VISIBLE_DEVICES:-all}" \
	      --env="NVIDIA_DRIVER_CAPABILITIES=${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics" \
	  --hostname ${CONTAINER_HOSTNAME} \
	  guidoski/icub:tf1.12.3-gpu-py3 bash -c "
		     yarpserver --ip 172.19.0.2 --socket 10000 & glxgears
		     "
