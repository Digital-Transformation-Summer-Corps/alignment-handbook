# Use CUDA 12.4.1 and Ubuntu 22.04
FROM nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04

# Set environment variables to prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Update package lists and install basic dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        wget \
        git \
        gnupg2 \
        software-properties-common \
        build-essential \
        cmake \
        python3.10 \
        python3.10-dev \
        python3-pip \
        python3.10-distutils \
        vim && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh

# Add conda to PATH
ENV PATH=/opt/conda/bin:${PATH}

# Initialize conda and create base environment
RUN conda init bash && \
    conda config --set always_yes yes --set changeps1 no && \
    conda update -q conda

# Make python3.10 the default python (Ubuntu 22.04 comes with 3.10 by default)
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.10 1

# Upgrade pip in the base conda environment
RUN /opt/conda/bin/pip install --upgrade pip

# Set working directory
WORKDIR /workspace

# Set up shell to automatically activate conda
RUN echo "source /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc

