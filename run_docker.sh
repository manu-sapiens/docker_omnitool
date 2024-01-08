# run the raspeberry pi docker accessible on port 1688, an map the data to ./om>
echo "-----------------"
echo "Already running Docker containers:"
docker ps
echo "-----------------"
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

echo "Starting Omnitool docker"
docker run -p 1688:4444 -i -v ./omnitool.data:/app/omnitool/packages/omni-server/data.local manusapiens/omnitool_pi

