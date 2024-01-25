#!/bin/bash

echo "Read '.env' file"
# Check if the .env file exists
if [ ! -f .env ]; then
  echo "Error: .env file not found. Please create an .env file with USER_NAME and USER_PASSWORD variables."
  exit 1
fi


echo "Which "
# Load variables from .env file
USER_NAME=$(grep USER_NAME .env | cut -d '=' -f2)
USER_PASSWORD=$(grep USER_PASSWORD .env | cut -d '=' -f2)
IMAGE_NAME=$(grep IMAGE_NAME .env | cut -d '=' -f2)
IMAGE_TAG=$(grep IMAGE_TAG .env | cut -d '=' -f2)

cd build
# Check if USER_NAME and USER_PASSWORD are not empty
if [ -z "$USER_NAME" ] || [ -z "$USER_PASSWORD" ]; then
  echo "Error: USER_NAME and USER_PASSWORD must be set in the .env file."
  exit 1
fi
# Array to hold the names of the Dockerfiles
dockerfiles=()

# Iterate over files starting with Dockerfile_ in the subfolder
for file in Dockerfile_*; do
    if [ -f "$file" ]; then
        dockerfiles+=("$file")
    fi
done
# Display the Dockerfiles to the user
echo "Please select a Dockerfile (or type 'all' for all files):"
for i in "${!dockerfiles[@]}"; do
    echo "$i) ${dockerfiles[$i]}"
done
echo "'all') All files"

# Ask the user to choose a Dockerfile
read -p "Enter your choice: " choice



echo "Export images after creation?"
echo "Y(es)"
echo "N(o)"

read -p "Enter your choice: " exporter


exporter=${exporter^^}

# Function to process Dockerfile
process_dockerfile() {
    
    echo "Processing $1..."

    file_name="$1"
    trimmed_image_name="${IMAGE_NAME#\{}" 
    trimmed_image_name="${trimmed_image_name%\}}"
    echo "Trimmed Image: $trimmed_image_name"
    suffix="${file_name#Dockerfile_}"
    echo "suffix: $suffix"
    conc_img_name="${trimmed_image_name}_${suffix}"
    # Build the Docker image with build arguments
    docker build -t $conc_img_name:$IMAGE_TAG \
      -f $1 \
      --build-arg USER_NAME="$USER_NAME" \
      --build-arg USER_PASSWORD="$USER_PASSWORD" \
      .
    # Check if the build was successful
    if [ $? -eq 0 ]; then
      echo "Docker image build successful."
      if [ $exporter = "Y" ]; then
          echo "Beginning export of Image"
      docker image save $conc_img_name:$IMAGE_TAG \
          -o $conc_img_name-$IMAGE_TAG.tar
      else
          echo "Export Function not selected"
      fi
    else
      echo "Error: Docker image build failed."
    fi
}

# Handle user selection
if [ "$choice" == "all" ]; then
    # Process all Dockerfiles
    for file in "${dockerfiles[@]}"; do
        process_dockerfile "$file"
    done
else
    # Validate numeric input
    if [[ ! $choice =~ ^[0-9]+$ ]] || [ $choice -ge ${#dockerfiles[@]} ]; then
        echo "Invalid selection."
        exit 1
    fi

    # Process selected Dockerfile
    selected_dockerfile="${dockerfiles[$choice]}"
    echo "You have selected: $selected_dockerfile"
    process_dockerfile "$selected_dockerfile"
fi


