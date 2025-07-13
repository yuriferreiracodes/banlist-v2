#!/bin/bash

echo "Select an option:"
echo "1) First build of the project"
echo "2) Say hello"
read -p "Your choice: " choice

case $choice in
  1)
    echo "🧨 Removing old MySQL data volume..."
    sudo rm -rf ./docker/mysql/dbdata

    echo "🐳 Building and starting Docker containers..."
    docker-compose down -v
    docker-compose up -d --build

    echo "⏳ Waiting for MySQL to be ready..."
    until docker exec banlist-v2_db mysql -uroot -proot -e "USE banlist-v2" &>/dev/null; do
      sleep 2
      echo "⏱️  Still waiting for database..."
    done

    echo "📦 Installing Composer dependencies..."
    docker exec -it banlist-v2 composer install

    echo "🔐 Generating Laravel app key..."
    docker exec -it banlist-v2 php artisan key:generate

    echo "🧰 Running migrations and seeders..."
    docker exec -it banlist-v2 php artisan migrate:fresh --seed

    echo "✅ Project is ready at: http://localhost:8080"
    ;;
  2)
    echo "👋 Hello, my name is Yuri!"
    ;;
  *)
    echo "❌ Invalid option"
    ;;
esac
