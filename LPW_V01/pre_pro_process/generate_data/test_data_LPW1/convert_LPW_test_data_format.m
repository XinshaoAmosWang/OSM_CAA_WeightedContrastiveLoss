load('test_data.mat')

test_tracklets = [];
test_labels = [];
%% process cam 2 
label_test_cam = label_test_cam2;
test_image_name_cam = test_image_name_cam2';
ids = unique(label_test_cam);

for i = 1 : length(ids)
    id = ids(i);
    test_labels(length(test_labels)+1, 1) = id;
    
    indexes = (label_test_cam == id);
    test_tracklets{length(test_tracklets)+1, 1} = test_image_name_cam(indexes); 
end

%% process cam 1 
label_test_cam = label_test_cam1;
test_image_name_cam = test_image_name_cam1';
ids = unique(label_test_cam);

for i = 1 : length(ids)
    id = ids(i);
    test_labels(length(test_labels)+1, 1) = id;
    
    indexes = (label_test_cam == id);
    test_tracklets{length(test_tracklets)+1, 1} = test_image_name_cam(indexes); 
end

%% process cam 3
label_test_cam = label_test_cam3;
test_image_name_cam = test_image_name_cam3';
ids = unique(label_test_cam);

for i = 1 : length(ids)
    id = ids(i);
    test_labels(length(test_labels)+1, 1) = id;
    
    indexes = (label_test_cam == id);
    test_tracklets{length(test_tracklets)+1, 1} = test_image_name_cam(indexes); 
end


%%
pre = 'test_';
save_path = 'test_data_tracklet_format.mat';
save(save_path,...
        strcat(pre, 'tracklets'),...
        strcat(pre, 'labels'), ...
        '-v7.3');
  
 