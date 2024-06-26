# Flask Application with PostgreSQL

This is a simple Flask application that connects to a PostgreSQL database and provides two endpoints. The first endpoint returns the reversed IP address of the client, and the second endpoint returns the version of the PostgreSQL database.

## Prerequisites

- Python 3.x
- Flask
- psycopg2
- Docker (optional for containerization)

## Setup

1. **Clone the repository:**

    ```sh
    git clone https://github.com/
    cd your-repository
    ```

2. **Install the required Python packages:**

    ```sh
    pip install flask psycopg2
    ```

3. **Set the environment variables for the database connection:**

    ```sh
    export DB_HOST='your_db_host'
    export DB_NAME='your_db_name'
    export DB_USER='your_db_user'
    export DB_PASSWORD='your_db_password'
    ```

## Running the Application

To start the Flask application, run the following command:

```sh
python app.py
```

The application will be accessible at `http://0.0.0.0:80`.

## Endpoints

- **`/`**: This endpoint returns the reversed IP address of the client.
  
    Example response:
    ```
    Your reversed IP is: 1.0.0.127
    ```

- **`/db`**: This endpoint connects to the PostgreSQL database and returns the database version.
  
    Example response:
    ```
    DB Version: ('PostgreSQL 12.3',)
    ```

## Running with Docker

1. ** `requirements.txt` file:**

    ```
    Flask
    psycopg2
    ```

2. **`Dockerfile` with the following content:**

    ```Dockerfile
    FROM python:3.8-slim

    WORKDIR /app

    COPY requirements.txt requirements.txt
    RUN pip install -r requirements.txt

    COPY app.py app.py

    CMD ["python", "app.py"]
    ```

3. **Build the Docker image:**

    ```sh
    docker build -t flask-postgres-app .
    ```

4. **Run the Docker container:**

    ```sh
    docker run -p 80:80 -e DB_HOST='your_db_host' -e DB_NAME='your_db_name' -e DB_USER='your_db_user' -e DB_PASSWORD='your_db_password' flask-postgres-app
    ```

The application will be accessible at `http://localhost:80`.

## Notes

- Ensure your PostgreSQL server is running and accessible with the provided credentials.
- The application listens on port 80. Make sure this port is available or change it as needed.
- The `psycopg2` library is used for connecting to the PostgreSQL database. Make sure it is properly installed and configured.




# Terraform AWS Infrastructure Setup

This Terraform configuration sets up an AWS infrastructure that includes a VPC, a public subnet, an internet gateway, a route table, a security group, an EC2 instance running a simple web server, and an Elastic Load Balancer (ELB).

## Resources Created

- **VPC**: A Virtual Private Cloud with CIDR block `10.0.0.0/16`.
- **Subnet**: A public subnet with CIDR block `10.0.6.0/24` in availability zone `us-east-2a`.
- **Internet Gateway**: Allows internet access for the VPC.
- **Route Table**: Routes traffic from the public subnet to the internet.
- **Security Group**: Allows HTTP traffic on port 80 from any IP address.
- **EC2 Instance**: An Amazon Linux instance running Docker and a simple web server.
- **Elastic Load Balancer (ELB)**: Distributes HTTP traffic across the EC2 instances.

## Usage

1. **Initialize Terraform:**

    ```sh
    terraform init
    ```

2. **Apply the configuration:**

    ```sh
    terraform apply
    ```

    Confirm the apply action with `yes`.

## Notes

- Ensure your AWS credentials are configured.
- The EC2 instance will run a Docker container from the `yeasy/simple-web` image.
- The ELB will balance traffic across instances running in the public subnet.


## Troubleshooting

- **Database Connection Errors**: Ensure the database credentials and host are correct. Check if the PostgreSQL server is running and accessible from your network.
- **Port Conflicts**: If port 80 is already in use, change the port number in the `app.run` call or Docker command.
