
index = 100;

data_root = '/media/amos/E0C4F298C4F27060/Papers_Projects/Data/CARS196';
im = imread( fullfile(data_root, image_names{index}) );
imshow(im);

im = im(bbox_y1(index):bbox_y2(index), bbox_x1(index):bbox_x2(index), :);
imshow(im);


