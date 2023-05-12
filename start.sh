#!/bin/bash

# Set the desired port number
port=${PORT:-1300}

# Check if PHP is installed
if ! command -v php >/dev/null 2>&1; then
    echo "PHP is not installed. Please install PHP and try again."
    exit 1
fi

# Determine the IP address of the container
ip=$(hostname -i)

# Check if the PHP file exists
file='/app/SelfSign/site/index.php'
if [ ! -f "$file" ]; then
    echo "The provided PHP file does not exist."
    exit 1
fi

# Grant permissions to the target directory for file uploads
target_directory='/app/SelfSign/site/data'
chmod 777 "$target_directory"

# Start the PHP built-in web server
echo "Starting PHP built-in web server on $ip:$port..."
php -d post_max_size=-1 -d upload_max_filesize=-1 -S "$ip":"$port" -t "$(dirname "$file")"
