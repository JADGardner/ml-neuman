#!/bin/bash
echo ========================================
echo 1/11: Extract frames
echo ========================================
conda activate ROMP
python save_video_frames.py --video /data/CustomMLHugs/dataset/tom/tom_video.mov --save_to /data/CustomMLHugs/dataset/tom/tom_video/raw_720p  --width 1280 --height 720 --every 10 --skip=0
conda deactivate
echo ========================================
echo 2/11: Masks
echo ========================================
cd /home/user/neuman/preprocess/detectron2/demo
wget https://dl.fbaipublicfiles.com/detectron2/COCO-InstanceSegmentation/mask_rcnn_X_101_32x8d_FPN_3x/139653917/model_final_2d9806.pkl
conda activate ROMP
python demo.py --config-file ../configs/COCO-InstanceSegmentation/mask_rcnn_X_101_32x8d_FPN_3x.yaml --input /data/CustomMLHugs/dataset/tom/tom_video/raw_720p/*.png --output /data/CustomMLHugs/dataset/tom/tom_video/raw_masks  --opts MODEL.WEIGHTS ./model_final_2d9806.pkl
conda deactivate
cd /home/user/neuman/preprocess
echo ========================================
echo 3/11: Sparse scene reconstrution
echo ========================================
cd /data/CustomMLHugs/dataset/tom/tom_video
mkdir recon
colmap feature_extractor --database_path ./recon/db.db --image_path ./raw_720p --ImageReader.mask_path ./raw_masks --SiftExtraction.estimate_affine_shape=true --SiftExtraction.domain_size_pool=true --ImageReader.camera_model SIMPLE_RADIAL --ImageReader.single_camera 1
colmap exhaustive_matcher --database_path ./recon/db.db --SiftMatching.guided_matching=true
mkdir -p ./recon/sparse
colmap mapper --database_path ./recon/db.db --image_path ./raw_720p --output_path ./recon/sparse
if [ -d "./recon/sparse/1" ]; then echo "Bad reconstruction"; exit 1; else echo "Ok"; fi
mkdir -p ./recon/dense
colmap image_undistorter --image_path raw_720p --input_path ./recon/sparse/0/ --output_path ./recon/dense
colmap patch_match_stereo --workspace_path ./recon/dense
colmap model_converter --input_path ./recon/dense/sparse/ --output_path ./recon/dense/sparse --output_type=TXT
mkdir ./output
cp -r ./recon/dense/images ./output/images
cp -r ./recon/dense/stereo/depth_maps ./output/depth_maps
cp -r ./recon/dense/sparse ./output/sparse
cd /home/user/neuman/preprocess
echo ========================================
echo 4/11: Masks for rectified images
echo ========================================
cd /home/user/neuman/preprocess/detectron2/demo
conda activate ROMP
python demo.py --config-file ../configs/COCO-InstanceSegmentation/mask_rcnn_X_101_32x8d_FPN_3x.yaml --input /data/CustomMLHugs/dataset/tom/tom_video/output/images/*.png --output /data/CustomMLHugs/dataset/tom/tom_video/output/segmentations  --opts MODEL.WEIGHTS ./model_final_2d9806.pkl
conda deactivate
cd /home/user/neuman/preprocess
echo ========================================
echo 5/11: DensePose
echo ========================================
cd /home/user/neuman/preprocess/detectron2/projects/DensePose
conda activate ROMP
python apply_net.py dump configs/densepose_rcnn_R_101_FPN_DL_s1x.yaml https://dl.fbaipublicfiles.com/densepose/densepose_rcnn_R_101_FPN_DL_s1x/165712116/model_final_844d15.pkl /data/CustomMLHugs/dataset/tom/tom_video/output/images /data/CustomMLHugs/dataset/tom/tom_video/output/densepose  --output /data/CustomMLHugs/dataset/tom/tom_video/output/densepose/output.pkl -v
conda deactivate
cd /home/user/neuman/preprocess
echo ========================================
echo 6/11: 2D keypoints
echo ========================================
cd /home/user/neuman/preprocess/mmpose
conda activate open-mmlab
python demo/bottom_up_img_demo.py configs/body/2d_kpt_sview_rgb_img/associative_embedding/coco/higherhrnet_w48_coco_512x512_udp.py https://download.openmmlab.com/mmpose/bottom_up/higher_hrnet48_coco_512x512_udp-7cad61ef_20210222.pth --img-path /data/CustomMLHugs/dataset/tom/tom_video/output/images --out-img-root /data/CustomMLHugs/dataset/tom/tom_video/output/keypoints --kpt-thr=0.3 --pose-nms-thr=0.9
conda deactivate
cd /home/user/neuman/preprocess
echo ========================================
echo 7/11: Monocular depth
echo ========================================
cd /home/user/neuman/preprocess/BoostingMonocularDepth
wget https://sfu.ca/~yagiz/CVPR21/latest_net_G.pth -O /home/user/neuman/preprocess/BoostingMonocularDepth/pix2pix/checkpoints/mergemodel/latest_net_G.pth
wget https://cloudstor.aarnet.edu.au/plus/s/lTIJF4vrvHCAI31/download -O res101.pth
conda activate ROMP
python run.py --Final --data_dir /data/CustomMLHugs/dataset/tom/tom_video/output/images --output_dir /data/CustomMLHugs/dataset/tom/tom_video/output/mono_depth --depthNet 2
conda deactivate
cd /home/user/neuman/preprocess
echo ========================================
echo 8/11: SMPL parameters
echo ========================================
cd /home/user/neuman/preprocess/ROMP
wget https://github.com/jiangwei221/ROMP/releases/download/v1.1/model_data.zip
unzip model_data.zip
wget https://github.com/Arthur151/ROMP/releases/download/v1.1/trained_models_try.zip
unzip trained_models_try.zip
conda activate ROMP
python -m romp.predict.image --inputs /data/CustomMLHugs/dataset/tom/tom_video/output/images --output_dir /data/CustomMLHugs/dataset/tom/tom_video/output/smpl_pred
conda deactivate
cd /home/user/neuman/preprocess
echo ========================================
echo 9/11: Solve scale ambiguity
echo ========================================
cd /home/user/neuman/preprocess
conda activate neuman_env
python export_alignment_updated.py --scene_dir /data/CustomMLHugs/dataset/tom/tom_video/output/sparse --images_dir /data/CustomMLHugs/dataset/tom/tom_video/output/images --raw_smpl /data/CustomMLHugs/dataset/tom/tom_video/output/smpl_pred --smpl_estimator="romp"
conda deactivate
cd /home/user/neuman/preprocess
echo ========================================
echo 10/11: Optimize SMPL using silhouette
echo ========================================
cd /home/user/neuman/preprocess
conda activate neuman_env
python optimize_smpl.py --scene_dir /data/CustomMLHugs/dataset/tom/tom_video/output
conda deactivate
cd /home/user/neuman/preprocess
echo ========================================
echo 11/11: Generate smpl_optimised_aligned_scale.npz
echo ========================================
cd /home/user/neuman/preprocess
python -m images_to_jpg.py /data/CustomMLHugs/dataset/tom/tom_video/output/images /data/CustomMLHugs/dataset/tom/tom_video/output/images_jpg
cd /home/user/neuman/preprocess/4D-Humans
python track.py video.source=/data/CustomMLHugs/dataset/tom/tom_video/output/images_jpg