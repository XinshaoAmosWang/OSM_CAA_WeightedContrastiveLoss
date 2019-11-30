function [im_data] = process_cut_out_large(img_name)
%process_cut_out_large
%   min_h = floor( size(img, 1) / 3 );
%   min_w = floor( size(img, 2) / 3 );
img = imread( img_name );

% cut out
min_h = floor( size(img, 1) / 2 );
min_w = floor( size(img, 2) / 2 );
img = img_cut_out(img, min_h, min_w);

im_data = imresize((single(img)),[224 224]);
im_data = im_data(:,:,[3,2,1]);
im_data = permute(im_data,[2,1,3]);
        
im_data(:,:,1) = im_data(:,:,1)-104;
im_data(:,:,2) = im_data(:,:,2)-117;
im_data(:,:,3) = im_data(:,:,3)-123;

end

