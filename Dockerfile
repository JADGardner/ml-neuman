FROM jadgardner/nerfstudio:3.0

ARG CUDA_ARCHITECTURES=90;89;86
ENV CUDA_ARCHITECTURES=${CUDA_ARCHITECTURES}
ENV TCNN_CUDA_ARCHITECTURES=${CUDA_ARCHITECTURES}

RUN sudo apt-get update && sudo apt-get install -y \
    git \
    cmake \
    vim \
    wget \
    unzip \
    build-essential \
    libboost-program-options-dev \
    libboost-filesystem-dev \
    libboost-graph-dev \
    libboost-system-dev \
    libboost-test-dev \
    libeigen3-dev \
    libsuitesparse-dev \
    libfreeimage-dev \
    libgoogle-glog-dev \
    libgflags-dev \
    libglew-dev \
    qtbase5-dev \
    libqt5opengl5-dev \
    libcgal-dev \
    libcgal-qt5-dev

RUN mkdir -p ~/miniconda3
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
RUN bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
RUN rm -rf ~/miniconda3/miniconda.sh

ENV PATH="/home/user/miniconda3/bin:${PATH}"

RUN /bin/bash -c "source ~/miniconda3/bin/activate && conda init bash && source ~/.bashrc && conda activate base && conda info"