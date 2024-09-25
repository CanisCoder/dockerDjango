# Use Amazon Linux 2 as the base image
FROM amazonlinux:2

# Install system dependencies required for building Python packages
RUN yum update -y && \
    yum groupinstall "Development Tools" -y && \
    amazon-linux-extras enable python3.8 && \
    yum install -y python3.8 python3.8-devel mariadb-devel gcc && \
    yum clean all

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set the working directory
WORKDIR /app

# Install pip
RUN python3.8 -m ensurepip --upgrade && pip3.8 install --upgrade pip

# Copy the requirements.txt file
COPY requirements.txt /app/

# Install Python dependencies from requirements.txt
RUN pip3.8 install --no-cache-dir -r requirements.txt

# Copy the project files into the container
COPY . /app/

# Expose port 8000 for Django development server
EXPOSE 8000

# Command to run the Django development server
CMD ["python3.8", "manage.py", "runserver", "0.0.0.0:8000"]
