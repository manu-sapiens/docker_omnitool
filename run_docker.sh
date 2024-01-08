echo "-----------------"
# check if docker is installed
if ! [ -x "$(command -v docker)" ]; then
    # install docker
    echo "[WARNING] Installing docker. This will require root access."
    sudo apt-get update
    # sudo sudo apt-get upgrade
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    sudo usermod -aG docker Pi
    if ! [ -x "$(command -v docker)" ]; then
        echo '[ERROR]: FAILED to install docker'
    fi
fi


# run the raspeberry pi docker accessible on port 1688, an map the data to ./om>
echo "-----------------"
echo "updating to latest omnitool_pi container"
docker pull manusapiens/omnitool_pi

echo "Already running Docker containers:"
docker ps
containers=$(docker container ls --format='{{json .}}')
for container in $containers
do
 container_id=$(echo $container | jq -r '.Names')
 ports=$(echo $container | jq '.Ports')
 if [[ $ports == *"0.0.0.0:1688"* ]]; then
 echo "Killing container $container_id"
 docker kill $container_id
 fi
done

if [ ! -d "./omnitool.data" ]; then
   echo "Creating omnitool.data"
   mkdir ./omnitool.data
else
   if [ ! -r "./omnitool.data" ] || [ ! -w "./omnitool.data" ]; then
       echo "Directory exists but does not have read/write permissions."

       chmod u+rw ./omnitool.data
   else
        echo "omnitool.data directory exists and is accessible by the user."
   fi
fi

echo "-----------------"
echo "Starting Omnitool docker"
docker run -p 1688:4444 -i -v ./omnitool.data:/app/omnitool/packages/omni-server/data.local manusapiens/omnitool_pi

