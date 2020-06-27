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

%% Option1
%convert and save: whole images
% % % % data_root = '/media/amos/E0C4F298C4F27060/Papers_Projects/Data/CARS196';
% % % % train_data_cell = convert_to_data_cell_whole(data_root, train_image_names);
% % % % test_data_cell = convert_to_data_cell_whole(data_root, test_image_names);
% % % % %
% % % % save_path = 'train_data_cell.mat';
% % % % class_ids = train_class_ids;
% % % % save(save_path,...
% % % %         'train_data_cell', ...
% % % %         'class_ids', ...
% % % %         '-v7.3');
% % % % save_path = 'test_data_cell.mat';
% % % % class_ids = test_class_ids;
% % % % save(save_path,...
% % % %         'test_data_cell', ...
% % % %         'class_ids', ...
% % % %         '-v7.3');


%% Option2 
%convert and save: bbox images
data_root = '/media/amos/E0C4F298C4F27060/Papers_Projects/Data/CARS196';
train_data_cell = convert_to_data_cell_bbox(data_root, train_image_names, train_bbox);
test_data_cell = convert_to_data_cell_bbox(data_root, test_image_names, test_bbox);
%
save_path = 'bbox_train_data_cell.mat';
class_ids = train_class_ids;
save(save_path,...
        'train_data_cell', ...
        'class_ids', ...
        '-v7.3');
save_path = 'bbox_test_data_cell.mat';
class_ids = test_class_ids;
save(save_path,...
        'test_data_cell', ...
        'class_ids', ...
        '-v7.3');


function [ image_data_cell ] = convert_to_data_cell_whole(data_root, image_names)
    image_data_cell = cell(length(image_names), 1);
    for img = 1 : length(image_names)
    	image_data_cell{img} = process_image( fullfile(data_root, image_names{img}) );
    end
end
function [ image_data_cell ] = convert_to_data_cell_bbox(data_root, image_names, bboxes)
    image_data_cell = cell(length(image_names), 1);
    for img = 1 : length(image_names)
    	image_data_cell{img} = process_box_image_v2( fullfile(data_root, image_names{img}), ... 
    									bboxes(img, 1), bboxes(img, 2), bboxes(img, 3), bboxes(img, 4)  );
    end
end