# Use an official Python runtime as a parent image
FROM python:3.8-slim

# Set the working directory in the container
WORKDIR /app

# install packets, Clone the repo from github, Install any needed packages specified in requirements.txt and Make port 8080 available to the world outside this container
RUN apt-get update -y && \
apt-get install git=1:2.39.5-0+deb12u2 -y --no-install-recommends && \
git clone https://github.com/scgupta/tutorial-python-microservice-tornado . && \
pip install --no-cache-dir -r requirements.txt && \
rm -rf /var/lib/apt/lists/*

EXPOSE 8080

# Define environment variable
ENV NAME=AddressBook
ENV PYTHONPATH=/app

# Run the application
CMD ["python", "addrservice/tornado/server.py", "--port", "8080", "--config", "./configs/addressbook-local.yaml", "--debug"]