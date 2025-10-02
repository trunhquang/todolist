# Use the official Flutter image
FROM cirrusci/flutter:3.16.0

# Set working directory
WORKDIR /app

# Copy pubspec files
COPY pubspec.yaml pubspec.lock ./

# Get dependencies
RUN flutter pub get

# Copy source code
COPY . .

# Build the app
RUN flutter build web --release

# Use nginx to serve the app
FROM nginx:alpine

# Copy built app to nginx
COPY --from=0 /app/build/web /usr/share/nginx/html

# Copy nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
