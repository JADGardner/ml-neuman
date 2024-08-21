#!/bin/bash

# Activate Miniconda
source ~/miniconda3/bin/activate

# Create and set up ROMP environment
conda create -n ROMP python==3.8.8 -y
conda activate ROMP
conda install pytorch==1.13.1 torchvision==0.14.1 torchaudio==0.13.1 pytorch-cuda=11.7 -c pytorch -c nvidia -y
conda install conda-forge::cudatoolkit==11.7.1 -y
conda install -c fvcore -c iopath -c conda-forge fvcore iopath -y
conda install -c bottler nvidiacub -y
conda install pytorch3d -c pytorch3d -y

# Install ROMP requirements
cd ~/neuman/preprocess/ROMP
pip install -r requirements.txt
pip install av
git clone https://github.com/mattloper/chumpy.git
cd chumpy
pip install -e .

# Install additional packages for ROMP
cd ~/neuman/preprocess
python -m pip install -e detectron2
pip install setuptools==59.5.0
pip install pillow==9.5.0

# Create and set up open-mmlab environment
conda create -n open-mmlab python=3.8 pytorch=1.10 cudatoolkit=11.3 torchvision -c pytorch -y
conda activate open-mmlab
pip3 install openmim
mim install "mmcv>=1.3.8, <=1.5.0"
cd ~/neuman/preprocess/mmpose
pip install -v -e .

# Create and set up neuman_env environment
cd ~/neuman/preprocess
conda create -n neuman_env python=3.8.8 -y
conda activate neuman_env
conda install pytorch==1.13.1 torchvision==0.14.1 torchaudio==0.13.1 pytorch-cuda=11.7 -c pytorch -c nvidia -y
conda install conda-forge::cudatoolkit==11.7.1 -y
conda install -c fvcore -c iopath -c conda-forge fvcore iopath -y
conda install -c bottler nvidiacub -y
conda install pytorch3d -c pytorch3d -y
conda install -c conda-forge igl -y
pip install opencv-python joblib open3d imageio tensorboardX chumpy lpips scikit-image ipython matplotlib
git clone https://github.com/mattloper/chumpy.git
cd chumpy
pip install -e .

cd ~/neuman/preprocess
conda create -n phalp python=3.10 -y
conda activate phalp
conda install pytorch torchvision torchaudio pytorch-cuda=11.7 -c pytorch -c nvidia -y
cd PHALP
pip install -e .[all]
cd ~/neuman/preprocess
cd 4D-Humans
pip install -e .[all]

cd ~/neuman/preprocess
ln -s /data/ 