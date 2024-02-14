#build a docker image for t

echo "Build the two docker images"
echo "MacOs Metal and Raspberry Pi"
docker build . --no-cache --platform linux/arm64 -t manusapiens/omnitool_metal_pi

echo "Windows Intel and AMD and MacOs Intel"
# !!!!  #docker build . --platform linux/amd64 -t manusapiens/omnitool_intel_amd

#docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t manusapiens/omnitool:tag --push .
#docker buildx build --no-cache --platform linux/arm64 -t manusapiens/omnitool:tag --push .
