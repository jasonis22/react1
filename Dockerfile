# Build stage base image
FROM node:lts-alpine AS build-stage

# Make the 'app' folder the current working directory
WORKDIR /app

# Copy both 'package.json' and 'package-lock.json' (if available)
COPY package*.json package-lock.json ./

# Install project dependencies
RUN npm install

# Copy project files and folders to the working directory
COPY . /app

# Build app for production with minification
RUN npm run build

# Production stage base image
FROM nginx:stable-alpine AS production-stage

# Replace Nginx configuration
RUN rm -rf /etc/nginx/conf.d
COPY conf /etc/nginx

# Copy artifact from previous build to /usr/share/nginx/html
COPY --from=build-stage /app/public /usr/share/nginx/html

# Expose application on port 80
EXPOSE 80

# Start up command for the application
CMD ["nginx", "-g", "daemon off;"]
