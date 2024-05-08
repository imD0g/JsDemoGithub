# Use a base image
FROM alpine:latest

# Set the working directory inside the container
WORKDIR /app

# Copy the script file into the container
COPY wait-for.sh /app/wait-for.sh

# Make the script executable
RUN chmod +x wait-for.sh

EXPOSE 8080

# Define the entrypoint command
ENTRYPOINT ["sh", "-c", "/app/wait-for.sh service1 8081 20 2 && echo 'Service is up and running' && exec \"$@\""]
