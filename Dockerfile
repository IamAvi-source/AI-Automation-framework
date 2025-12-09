# Use an official Maven parent image
FROM maven:3.8-openjdk-11

# Set the working directory in the container
WORKDIR /app

# Copy the project files to the working directory
COPY . /app

# The command to run the tests
CMD ["mvn", "test", "-Dexecution.type=remote"]
