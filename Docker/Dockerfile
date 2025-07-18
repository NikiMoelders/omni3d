FROM ubuntu:24.04

SHELL ["/bin/bash", "-c"]

# Set timezone to US Eastern
ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install specific packages and add deadsnakes PPA and install specific Python version
RUN DEBIAN_FRONTEND=noninteractive apt update && apt upgrade -y \
    && apt install -y software-properties-common \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt update \
    && apt install -y \
    python3.11 \
    python3.11-venv \
    python3.11-dev \
    python3-pip \
    python-is-python3 \
    apt-utils \
    git \
    curl \
    sudo \
    nano \
    vim \
    tmux \
    wget \
    x11-apps \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh \
    && bash miniconda.sh -b -p /opt/conda \
    && rm miniconda.sh

# Add conda to path and initialize
ENV PATH="/opt/conda/bin:$PATH"
RUN conda init bash

RUN conda config --set always_yes yes && \
    conda config --add channels defaults && \
    conda config --set channel_priority strict && \
    conda config --set report_errors false && \
    conda config --set auto_activate_base false && \
    conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main && \
    conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r

# Create conda environment with Python 3.8
RUN conda create -n omni3d python=3.8 -y \
    && /opt/conda/bin/conda run -n omni3d conda install -c fvcore -c iopath -c conda-forge fvcore iopath -y

RUN conda install -n omni3d -c pytorch -c nvidia pytorch=2.2 torchvision torchaudio pytorch-cuda=12.1 -y


# Set up conda environment
ENV PATH="/opt/conda/envs/omni3d/bin:$PATH"
SHELL ["conda", "run", "-n", "omni3d", "/bin/bash", "-c"]  

RUN /opt/conda/bin/conda run -n omni3d /bin/bash -c "\
    conda install -c conda-forge scipy seaborn -y && \
    pip install 'git+https://github.com/facebookresearch/detectron2.git' && \
    pip install opencv-python-headless && \
    conda install pytorch3d -c pytorch3d -y"

# Set up bash environment
SHELL ["/bin/bash", "-l", "-c"]
ENV TERM=xterm-256color

# Initialize conda and add to bashrc
RUN conda init bash && \
    echo 'source /opt/conda/bin/activate omni3d' >> ~/.bashrc && \
    echo -e "PS1='\e[1m\e[93m\u\e[97m@\e[93m\h:\e[35m\w\e[0m\e[97m#\e[0m '" >> ~/.bashrc

# Copy entrypoint script
COPY ./Docker/entrypoint.sh /entrypoint.sh
ENTRYPOINT /entrypoint.sh