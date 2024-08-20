#!/bin/bash

# Change directory to neuman/preprocess
cd /home/user/neuman/preprocess

# Clone BoostingMonocularDepth and checkout the specified commit
git clone --recurse-submodules https://github.com/compphoto/BoostingMonocularDepth.git
cd BoostingMonocularDepth
git checkout ecedd0c0cf5e1807cdab1c5154351a97168e710d
cd ..

# Clone ROMP and checkout the specified commit
git clone --recurse-submodules https://github.com/jiangwei221/ROMP.git
cd ROMP
git checkout f1aaf0c1d90435bbeabe39cf04b15e12906c6111
cd ..

# Clone detectron2 and checkout the specified commit
git clone --recurse-submodules https://github.com/jiangwei221/detectron2.git
cd detectron2
git checkout 2048058b6790869e5add8832db2c90c556c24a3e
cd ..

# Clone mmpose and checkout the specified commit
git clone --recurse-submodules https://github.com/jiangwei221/mmpose.git
cd mmpose
git checkout 8b788f93200ce6485e885da0c736f114e4de8eaf
cd ..

# Clone PHALP
git clone https://github.com/brjathu/PHALP.git

# Clone 4D-Humans
git clone https://github.com/shubham-goel/4D-Humans.git
