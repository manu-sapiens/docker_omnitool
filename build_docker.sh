DOCKER_PARAMS=""

#build a docker image for the raspberry pi
docker build . $DOCKER_PARAMS --platform linux/arm64 -t manusapiens/omnitool_pi

