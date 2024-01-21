#!/bin/bash
# Start zsh in the background
su - $USER_NAME -c "zsh" &

# Keep the container running
tail -f /dev/null
