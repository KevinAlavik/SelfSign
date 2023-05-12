#!/bin/bash

# Set the desired port number
port=1300

# Check if PHP is installed
if ! command -v php >/dev/null 2>&1; then
    echo "PHP is not installed. Please install PHP and try again."
    exit 1
fi

file='SelfSign/site/index.php'

# Check if the PHP file exists
if [ ! -f "$file" ]; then
    echo "The provided PHP file does not exist."
    exit 1
fi

# Determine the platform
platform=$(uname)

# Get the computer's IP address based on the platform
if [[ "$platform" == "Darwin" ]]; then
    ip=$(ipconfig getifaddr en0)
elif [[ "$platform" == "Linux" ]]; then
    ip=$(hostname -I | awk '{print $1}')
else
    echo "Unsupported platform: $platform"
    exit 1
fi

# Start the PHP built-in web server
echo "Starting PHP built-in web server on $ip:$port..."
sudo php -S "$ip":"$port" -t "$(dirname "$file")"
