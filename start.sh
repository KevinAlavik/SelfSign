#!/bin/bash

# Set the desired port number
port=13

# Check if PHP is installed
if ! command -v php >/dev/null 2>&1; then
    echo "PHP is not installed. Please install PHP and try again."
    exit 1
fi

# Check if a PHP file is provided as an argument
if [ $# -eq 0 ]; then
    echo "Please provide a PHP file as an argument."
    exit 1
fi

# Get the absolute path of the PHP file
file=$(realpath "$1")

# Check if the PHP file exists
if [ ! -f "$file" ]; then
    echo "The provided PHP file does not exist."
    exit 1
fi

# Start the PHP built-in web server
echo "Starting PHP built-in web server on port $port..."
php -S localhost:"$port" -t "$(dirname "$file")"