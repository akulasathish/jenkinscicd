FROM nginx:alpine

# Copy HTML files into the Nginx server directory
COPY . /usr/share/nginx/html

# Expose port 80
EXPOSE 80
