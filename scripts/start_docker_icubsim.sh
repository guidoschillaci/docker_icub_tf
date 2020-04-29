xhost +local:root

export DOCKER_CONTAINER_NAME=icub_container

if [ "$(docker ps -q -f name=${DOCKER_CONTAINER_NAME})" ]; then

  docker exec -it ${DOCKER_CONTAINER_NAME} \
    bash -c "
            iCub_SIM --verbose 
            "
#            yarpmanager --from /code/docker_test/yarp_manager_conf.ini  
             
             # yarp conf --clean && \ 
             #yarp conf 172.19.0.2 10000 && \
             #yarprun --server /main_yarpmanager & \
             #yarpmanager --from /code/docker_test/yarp_manager_conf.ini  
#    --env="DISPLAY:$DISPLAY:0" \
            
#    --env="NVIDIA_VISIBLE_DEVICES=all" \
#    --env="NVIDIA_DRIVER_CAPABILITIES=all" \
#    $DOCKER_CONTAINER_NAME \

#    --runtime=nvidia \
#    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
#    --volume="/home/guido/code:/code/" \


else
   echo "There is no docker container named \"${DOCKER_CONTAINER_NAME}\". Have you executed start_docker_yarpserver.sh?"
fi
