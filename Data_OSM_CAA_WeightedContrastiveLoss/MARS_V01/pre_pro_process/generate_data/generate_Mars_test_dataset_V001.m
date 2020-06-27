%% Data Format & Save the struct array
% Each struct: image path cell for each tracklet, person_id, cam_id

root = '/media/amos/E0C4F298C4F27060/Papers_Projects/Data/Mars';
bbox_data = fullfile(root, 'bbox_test');
save_path = 'test_data.mat';
pre = 'test_';

tracklet_num = 12180;
test_tracklets = cell(tracklet_num,1);
test_labels = zeros(tracklet_num,1);
test_cameras = zeros(tracklet_num,1);

%%
count = 1;
person_dirs = dir(bbox_data);
% for each person directory
for dir_index = 3 : length(person_dirs)
%for dir_index = 4 : 4
    cur_dir = fullfile(bbox_data, person_dirs(dir_index).name);
    
    cur_images = dir(cur_dir);
    cur_images = cur_images(3:end);
    image_names = {cur_images.name};
    
    [cam_ids, tracklet_ids] = extract_names(image_names);
    tracklet_ids_uni = unique(tracklet_ids);
    
    for i = 1 : length(tracklet_ids_uni)
        t_id = tracklet_ids_uni(i);
        inds = find(tracklet_ids == t_id);
        
        test_tracklets{count} = extract_tracklet(cur_dir,image_names, inds);
        test_labels(count) = dir_index-3;
        test_cameras(count) = cam_ids( inds(1) );
        
        count = count + 1
    end
end

%%
save(save_path,...
        strcat(pre, 'tracklets'),...
        strcat(pre, 'labels'), ...
        strcat(pre, 'cameras'), ...
        '-v7.3');


%% inds specify the indexes for img_names
function [tracklet] = extract_tracklet(cur_dir, img_names, inds)
    img_num = length(inds);
    tracklet = cell(img_num,1);
    
    for i = 1 : img_num
        tracklet{i} = fullfile(cur_dir, img_names{ inds(i) });
    end
end


function [cam_ids, tracklet_ids] = extract_names(img_names)
    cam_ids = zeros(length(img_names),1);
    tracklet_ids = zeros(length(img_names),1);
    
    for i = 1 : length(img_names)
        [cam_ids(i),tracklet_ids(i)] = extract_name(img_names{i});
    end
    
end

function [cam_id, tracklet] = extract_name(img_name)
    cam_id = str2double( img_name(6) );
    tracklet = str2double( img_name(8:11) );
end
