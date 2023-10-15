#!/usr/bin/env bash

if [ -d "vendor" ]; then
    echo "Sulu is already installed!"
    exit 0
fi

# Add github to the list of known hosts
ssh-keyscan -H github.com >> ~/.ssh/known_hosts

# Clone the sulu demo repo
git clone https://github.com/sulu/sulu-demo.git

# Move all sulu files/folders to the main dir and delete the demo folder
rm -rf sulu-demo/.git
rm -rf sulu-demo/.github
rm -rf sulu-demo/README.md
rm -rf sulu-demo/docker-compose.yml
rm -rf sulu-demo/docker-compose.override.yml
mv sulu-demo/* sulu-demo/.[!.]* .
rm -rf sulu-demo/

# Add the values for Database etc. to the .env.local
echo 'DATABASE_URL="mysql://root:gitpod@127.0.0.1:3306/demo?serverVersion=8.0.27&charset=utf8mb4"' >> .env.local

# Install all packages
composer install

# Populate the database
bin/adminconsole sulu:build dev -n