load('cars_annos.mat');
%% image_names
annos_cell = struct2cell(annotations);
% relative_im_path
image_names = squeeze( annos_cell(1, 1, :) );

%% class_ids
index = 6;
class_ids = cell2mat( squeeze(annos_cell(index, 1, :)) );
%%
% bounding boxes
index = 2;
bbox_x1 = cell2mat( squeeze(annos_cell(index, 1, :)) );
index = 3;
bbox_y1 = cell2mat( squeeze(annos_cell(index, 1, :)) );
index = 4;
bbox_x2 = cell2mat( squeeze(annos_cell(index, 1, :)) );
index = 5;
bbox_y2 = cell2mat( squeeze(annos_cell(index, 1, :)) );

bbox = [bbox_x1 bbox_y1 bbox_x2 bbox_y2];

%% training and testing split
train_num = 8054; % the first 98 classes
test_num = 8131; % the next 98 classes

train_image_names = image_names(1 : train_num);
test_image_names = image_names(train_num+1 : end);

train_class_ids = class_ids(1 : train_num);
test_class_ids = class_ids(train_num+1 : end);

train_bbox = bbox(1 : train_num, :);
test_bbox = bbox(train_num+1 : end, :);







%% Save image files and image boxes
data_root = '/home/xinshao/Papers_Projects/Data/CARS196';
TrainImagePathBoxCell = convert_to_imgfile_bbox(data_root, train_image_names, train_bbox);
TestImagePathBoxCell = convert_to_imgfile_bbox(data_root, test_image_names, test_bbox);
%
save_path = 'CARS196_TrainImagePathBoxCell.mat';
class_ids = train_class_ids;
save(save_path,...
        'TrainImagePathBoxCell', ...
        'class_ids', ...
        '-v7.3');
save_path = 'CARS196_TestImagePathBoxCell.mat';
class_ids = test_class_ids;
save(save_path,...
        'TestImagePathBoxCell', ...
        'class_ids', ...
        '-v7.3');


function [ image_data_cell ] = convert_to_imgfile_bbox(data_root, image_names, bboxes)
    image_data_cell = cell(length(image_names), 2);
    for img = 1 : length(image_names)
    	image_data_cell{img, 1} = fullfile(data_root, image_names{img});
        image_data_cell{img, 2} = [bboxes(img, 1), bboxes(img, 2), bboxes(img, 3), bboxes(img, 4)];
    end
end