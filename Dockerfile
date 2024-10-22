FROM nginx:alpine

# Install Node.js and npm
RUN apk add --no-cache nodejs npm

# Copy package.json and install dependencies
COPY package*.json ./
RUN npm install

# Copy application files
COPY . /usr/share/nginx/html

# Expose the port
EXPOSE 80
