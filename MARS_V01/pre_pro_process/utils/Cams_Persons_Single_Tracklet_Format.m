%% The train data. Each person directory contains tracklets of all cameras
%  Transfer it to the format: cameras -> persons
%  In this format, all tracklet for each id shot by each camera are
%  combined to form one tracklet for training
%  So in training phase, the same as LPW dataset
root = '/media/amos/E0C4F298C4F27060/Papers_Projects/Data/Mars';
bbox_data = fullfile(root, 'bbox_train');

save_path = fullfile(root, 'cams_persons_train');
mkdir(save_path);

person_dirs = dir(bbox_data);
% for each person directory
for dir_index = 3 : length(person_dirs)
    cur_dir = fullfile(bbox_data, person_dirs(dir_index).name);
    
    cur_images = dir(cur_dir);
    % for each image
    for img_index = 3 : length(cur_images)
        img_name = cur_images(img_index).name;
        img_path = fullfile(cur_dir, img_name);
        
        process_img(save_path, img_name, img_path);
    end
end



function [] = process_img(save_path, img_name, img_path)
    img_id = img_name(1:4);
    cam_id = img_name(6);
    
    % the destination path
    cam_path = fullfile(save_path, strcat('view', cam_id) );
    if ~ exist(cam_path, 'dir')
        mkdir(cam_path);
    end
    person_path = fullfile(cam_path, img_id);
    if ~ exist(person_path, 'dir')
        mkdir(person_path);
    end
    
    copyfile(img_path, person_path);
end