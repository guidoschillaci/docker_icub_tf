#xhost +local:root

#ipclient=192.168.1.229
#xhost +$ipclient:root

# get local ip address
#function iplocal () {
#  ip route get 8.8.8.8 | head -1 | cut -d' ' -f8
#  ip -o route get to 8.8.8.8 | sed -n 's/.*src \([0-9.]\+\).*/\1/p'
#}
# get external ip address
#function ipexternal () {
#  curl --silent http://checkip.amazonaws.com        # or:  http://ipinfo.io/ip
#}
#function ipinfo () {
#  echo "local    IP of this instance =>  $(iplocal)"
#  echo "external IP of this instance =>  $(ipexternal)"
#  echo "IP of the remote instance  =>  $ipclient"
#}


#ipinfo

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
             yarpserver --ip 172.19.0.2 --socket 10000 & yarpmanager
             "
#--volume="/home/guido/code:/code/" \
#&
#             yarp detect --write &&
#             yarprun --server /main_yarpserver "
fi


#from tensorflow.python.client import device_lib
#print(device_lib.list_local_devices())
