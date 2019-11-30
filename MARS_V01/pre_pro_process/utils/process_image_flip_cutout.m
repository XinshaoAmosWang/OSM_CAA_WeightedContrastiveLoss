function [im_data] = process_image_flip_cutout(img_name)
%Read image and pre-process
%   1. resize to (224,224)
%   2. permute channels
%   3. subtract mean value for each channel
img = imread( img_name );

% augmentation process

% randomly flip
if( randperm(8,1) == 1 )
	img = flip(img, 2);
end

% randomly cut out
if( randperm(8,1) == 1)
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

