FROM nginx:alpine

# Install Node.js and npm
RUN apk add --no-cache nodejs npm

# Copy your application files
COPY . /usr/share/nginx/html

# Expose the port
EXPOSE 80
