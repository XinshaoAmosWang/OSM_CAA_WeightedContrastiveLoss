function [im_data] = process_image_scale_crop_flip_cutout(img_name)
%Read image and pre-process
%   1. resize to (224,224)
%   2. permute channels
%   3. subtract mean value for each channel
img = imread( img_name );

% augmentation process
% random scale : the largest side is large_dim, without distoring the aspect ratio
large_dim = randperm(512-452,1) + 451;
img_h = size(img, 1);
img_w = size(img, 2);

ratio = single(large_dim) / single(img_h);
h_dim = large_dim;
w_dim = ceil(img_w * ratio);
img = imresize(single(img), [h_dim w_dim]);

% randomly crop 224x224
crop_h = 224;
crop_w = 224;
img = img_crop(img, crop_h, crop_w);

% randomly flip
if( randperm(5,1) == 1 )
	img = flip(img, 2);
end

% randomly cut out
if( randperm(5,1) == 1)
  min_h = 10;
  min_w = 5;
  max_h = ceil(size(img,1)/12);
  max_w = ceil(size(img,2)/6);
  img = img_cut_out(img, min_h, min_w, max_h, max_w);
end

%% Caffe input process
im_data = imresize((single(img)),[224 224]);
im_data = im_data(:,:,[3,2,1]);
im_data = permute(im_data,[2,1,3]);
        
im_data(:,:,1) = im_data(:,:,1)-104;
im_data(:,:,2) = im_data(:,:,2)-117;
im_data(:,:,3) = im_data(:,:,3)-123;

end

