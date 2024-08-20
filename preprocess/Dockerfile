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

RUN git clone https://github.com/apple/ml-neuman.git && \
    mv ml-neuman neuman

RUN cd neuman/preprocess  && \
    git clone --recurse-submodules https://github.com/compphoto/BoostingMonocularDepth.git && \
    cd BoostingMonocularDepth && \
    git checkout ecedd0c0cf5e1807cdab1c5154351a97168e710d

RUN cd neuman/preprocess  && \
    git clone --recurse-submodules https://github.com/jiangwei221/ROMP.git && \
    cd ROMP && \
    git checkout f1aaf0c1d90435bbeabe39cf04b15e12906c6111

RUN cd neuman/preprocess  && \
    git clone --recurse-submodules https://github.com/jiangwei221/detectron2.git && \
    cd detectron2 && \
    git checkout 2048058b6790869e5add8832db2c90c556c24a3e

RUN cd neuman/preprocess  && \
    git clone --recurse-submodules https://github.com/jiangwei221/mmpose.git && \
    cd mmpose && \
    git checkout 8b788f93200ce6485e885da0c736f114e4de8eaf

# RUN /bin/bash -c "source ~/miniconda3/bin/activate && \
#     conda create -n ROMP python==3.8.8 -y && \
#     conda activate ROMP && \
#     conda install pytorch torchvision torchaudio pytorch-cuda=11.8 -c pytorch -c nvidia -y && \
#     conda install cudatoolkit=11.8.0 -y && \
#     conda install -c fvcore -c iopath -c conda-forge fvcore iopath -y && \
#     conda install -c bottler nvidiacub -y && \
#     conda install pytorch3d -c pytorch3d -y"

# RUN /bin/bash -c "source ~/miniconda3/bin/activate && \
#     conda activate ROMP && \
#     cd neuman/preprocess/ROMP && \
#     pip install -r requirements.txt && \
#     pip install av"

# RUN /bin/bash -c "source ~/miniconda3/bin/activate && \
#     conda activate ROMP && \
#     cd neuman/preprocess && \
#     python -m pip install -e detectron2 && \
#     pip install setuptools==59.5.0 && \
#     pip install pillow==9.5.0"

# RUN /bin/bash -c "source ~/miniconda3/bin/activate && \
#     conda create -n open-mmlab python=3.8.8 -y && \
#     conda activate open-mmlab && \
#     conda install pytorch torchvision torchaudio pytorch-cuda=11.8 -c pytorch -c nvidia -y && \
#     conda install cudatoolkit=11.8.0 -y "

# RUN /bin/bash -c "source ~/miniconda3/bin/activate && \
#     conda activate open-mmlab && \
#     pip install -U openmim && \
#     mim install mmengine && \
#     mim install mmcv>=2.0.0 && \
#     mim install mmdet && \
#     cd neuman/preprocess/mmpose && \
#     pip install -r requirements.txt && \
#     pip install -v -e ."

# RUN /bin/bash -c "source ~/miniconda3/bin/activate && \
#     conda create -n neuman_env python=3.8.8 -y && \
#     conda activate neuman_env && \
#     conda install pytorch torchvision torchaudio pytorch-cuda=11.8 -c pytorch -c nvidia -y && \
#     conda install cudatoolkit=11.8.0 -y && \
#     conda install -c fvcore -c iopath -c conda-forge fvcore iopath -y && \
#     conda install -c bottler nvidiacub -y && \
#     conda install pytorch3d -c pytorch3d -y && \
#     conda install -c conda-forge igl -y && \
#     pip install opencv-python joblib open3d imageio tensorboardX chumpy lpips scikit-image ipython matplotlib"