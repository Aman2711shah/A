#!/bin/bash

echo "🚀 Starting WAZEET Web Server..."
echo "📱 Building Flutter web app..."

# Build the web app
flutter build web

echo "🌐 Starting web server on port 8080..."

# Start the web server
cd build/web
python3 -m http.server 8080

echo "✅ WAZEET app is now running at: http://localhost:8080"
echo "📱 Open your browser and go to: http://localhost:8080"
echo "🛑 Press Ctrl+C to stop the server"
