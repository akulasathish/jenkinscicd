FROM nginx:alpine

# Install Node.js and npm
RUN apk add --no-cache nodejs npm

# Copy your application files including package.json
COPY . /usr/share/nginx/html

# Expose the port
EXPOSE 80
