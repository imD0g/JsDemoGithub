# Use a base image
FROM python:3-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the server script into the container
COPY server.py /app/server.py

# Expose the port the app runs on
EXPOSE 8081

# Define the entrypoint command
ENTRYPOINT ["sh", "-c", "sleep 5 && python /app/server.py && echo 'pyServer is up and running'"]