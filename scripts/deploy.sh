#!/bin/bash
IMAGE=$1

echo "Starting Docker..."
sudo systemctl start docker || true

echo "Pulling new image: $IMAGE"
sudo docker pull $IMAGE

echo "Stopping old container..."
sudo docker rm -f emc-portal || true

echo "Starting new container..."
sudo docker run -d --name emc-portal -p 80:3000 --restart unless-stopped $IMAGE

echo "Deployment successful!"
