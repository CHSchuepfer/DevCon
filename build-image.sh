#!/bin/bash

cd build

# Check if the .env file exists
if [ ! -f .env ]; then
  echo "Error: .env file not found. Please create an .env file with USER_NAME and USER_PASSWORD variables."
  exit 1
fi

# Load variables from .env file
USER_NAME=$(grep USER_NAME .env | cut -d '=' -f2)
USER_PASSWORD=$(grep USER_PASSWORD .env | cut -d '=' -f2)
IMAGE_NAME=$(grep IMAGE_NAME .env | cut -d '=' -f2)
IMAGE_TAG=$(grep IMAGE_TAG .env | cut -d '=' -f2)
# Check if USER_NAME and USER_PASSWORD are not empty
if [ -z "$USER_NAME" ] || [ -z "$USER_PASSWORD" ]; then
  echo "Error: USER_NAME and USER_PASSWORD must be set in the .env file."
  exit 1
fi

cd build
# Build the Docker image with build arguments
docker build -t $IMAGE_NAME:$IMAGE_TAG \
  --build-arg USER_NAME="$USER_NAME" \
  --build-arg USER_PASSWORD="$USER_PASSWORD" \
  .

# Check if the build was successful
if [ $? -eq 0 ]; then
  echo "Docker image build successful."
else
  echo "Error: Docker image build failed."
fi
