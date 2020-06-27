load('train_data.mat')

label_train_view1 = [label_train_cam2_view1; label_train_cam3_view1];
label_train_view2 = [label_train_cam2_view2; label_train_cam3_view2];
label_train_view3 = [label_train_cam2_view3; label_train_cam3_view3];
label_train_view4 = [label_train_cam2_view4; label_train_cam3_view4];
train_image_name_view1 = [train_image_name_cam2_view1, train_image_name_cam3_view1];
train_image_name_view2 = [train_image_name_cam2_view2, train_image_name_cam3_view2];
train_image_name_view3 = [train_image_name_cam2_view3, train_image_name_cam3_view3];
train_image_name_view4 = [train_image_name_cam2_view4, train_image_name_cam3_view4];


train_tracklets = [];
train_labels = [];
%% process view 1
label_train_view = label_train_view1;
train_image_name_view = train_image_name_view1';
ids = unique(label_train_view);

for i = 1 : length(ids)
    id = ids(i);
    train_labels(length(train_labels)+1, 1) = id;
    
    indexes = (label_train_view == id);
    train_tracklets{length(train_tracklets)+1, 1} = train_image_name_view(indexes);
    
end

%% process view 2
label_train_view = label_train_view2;
train_image_name_view = train_image_name_view2';
ids = unique(label_train_view);

for i = 1 : length(ids)
    id = ids(i);
    train_labels(length(train_labels)+1, 1) = id;
    
    indexes = (label_train_view == id);
    train_tracklets{length(train_tracklets)+1, 1} = train_image_name_view(indexes);
    
end
%% process view 3
label_train_view = label_train_view3;
train_image_name_view = train_image_name_view3';
ids = unique(label_train_view);

for i = 1 : length(ids)
    id = ids(i);
    train_labels(length(train_labels)+1, 1) = id;
    
    indexes = (label_train_view == id);
    train_tracklets{length(train_tracklets)+1, 1} = train_image_name_view(indexes);
    
end
%% process view 4
label_train_view = label_train_view4;
train_image_name_view = train_image_name_view4';
ids = unique(label_train_view);

for i = 1 : length(ids)
    id = ids(i);
    train_labels(length(train_labels)+1, 1) = id;
    
    indexes = (label_train_view == id);
    train_tracklets{length(train_tracklets)+1, 1} = train_image_name_view(indexes);
    
end

pre = 'train_';
save_path = 'train_data_tracklet_format.mat';
save(save_path,...
        strcat(pre, 'tracklets'),...
        strcat(pre, 'labels'), ...
        '-v7.3');
  
 