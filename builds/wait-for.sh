#!/bin/sh

# Check if nc is installed, this will be used to see if the service is reachable
if ! command -v nc &> /dev/null; then
    echo "Netcat (nc) is not installed. Installing..."
    yum install -y nc
    if [ $? -ne 0 ]; then
        echo "Failed to install netcat. Exiting."
        exit 1
    fi
    echo "Netcat (nc) installed successfully."
fi

# Function to check if a host is reachable on a specific port
check_port() {
    # These are the default values for the host, port, timeout, and interval
    # They will be used if the user does not provide any values in the script arguments
    host=${1:-localhost}
    port=${2:-8080}
    timeout=${3:-10}
    interval=${4:-5}
    wait_time=${5}

    # Print the values that will be used for the scan
    echo "******************************************"
    echo "Scanning for $host:$port with timeout $timeout seconds!"
    if [ -n "$wait_time" ]; then
        echo "Will wait $wait_time seconds if the port is found"
    fi
    echo "******************************************"

    # Calculate the end time based on the timeout
    end_time=$(( $(date +%s) + timeout ))

    # Loop until the timeout is reached
    while true; do

        # Check if the host is reachable on the specified port
        if nc -z -w "$timeout" "$host" "$port" >/dev/null 2>&1; then
            echo "$host:$port is reachable"

            # If the user provided a wait time, sleep for that amount of time
            if [ -n "$wait_time" ]; then
                echo "Port found. Waiting for $wait_time seconds..."
                sleep "$wait_time"
            fi
            return 0  # Success

        # Timeout     
        elif [ "$(date +%s)" -gt "$end_time" ]; then
            echo "Timeout reached. Unable to connect to $host:$port"
            return 1  # Failure
        else
            echo "$host:$port is not reachable, trying again in $interval seconds..."
            sleep "$interval"
        fi
    done
}

# Check if the specified host and port are available
if ! check_port "$1" "$2" "$3" "$4" "$5"; then
    echo "$1:$2 is not available"
    exit 1
fi