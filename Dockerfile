# Use an official Node.js runtime as a parent image
FROM node:20.15.1-alpine3.20 as build

# Declare build arguments
ARG VITE_BASE_URL_API
ARG VITE_API_KEY_FIREBASE
ARG VITE_API_KEY_MAP_BOX
ARG VITE_BASE_URL_API_MAP_BOX

# Pass build arguments to the environment
ENV VITE_BASE_URL_API=${VITE_BASE_URL_API}
ENV VITE_API_KEY_FIREBASE=${VITE_API_KEY_FIREBASE}
ENV VITE_API_KEY_MAP_BOX=${VITE_API_KEY_MAP_BOX}
ENV VITE_BASE_URL_API_MAP_BOX=${VITE_BASE_URL_API_MAP_BOX}

# Set the working directory in the container
WORKDIR /app

# Copy the package.json and install dependencies
COPY package*.json ./
RUN npm install --verbose

# Copy the rest of the app's source code and build the app
COPY . .
RUN npm run build

# Use a lightweight web server to serve the app
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html

# Copy the custom Nginx configuration file
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80 to the outside world
EXPOSE 80

# Start the server
CMD ["nginx", "-g", "daemon off;"]
