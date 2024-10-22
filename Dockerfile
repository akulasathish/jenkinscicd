# Use Nginx as the base image
FROM nginx:alpine

# Copy HTML files to the Nginx web directory
COPY . /usr/share/nginx/html

# Expose port 80
EXPOSE 80
