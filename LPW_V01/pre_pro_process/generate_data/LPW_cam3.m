    
    % scene3: for train
    subdir_cam3_view1=dir(fullfile(param.file_path_cam3,'view1'));
    subdir_cam3_view2=dir(fullfile(param.file_path_cam3,'view2'));
    subdir_cam3_view3=dir(fullfile(param.file_path_cam3,'view3'));
    subdir_cam3_view4=dir(fullfile(param.file_path_cam3,'view4'));
    
    label_train_cam3_view1=[];
    train_image_name_cam3_view1={};
    label_train_cam3_view2=[];
    train_image_name_cam3_view2={};
    label_train_cam3_view3=[];
    train_image_name_cam3_view3={};
    label_train_cam3_view4=[];
    train_image_name_cam3_view4={};
    
    nameMapLabel_cam3=[];
    
    %generate data for cam3
    for i=3:(length(subdir_cam3_view3))
        nameMapLabel_cam3=[nameMapLabel_cam3;str2num(subdir_cam3_view3(i).name)];
        
        fprintf('process train data cam3 view3:%d/%d\n',i,(length(subdir_cam3_view3)));
        image_path_cam3=fullfile(param.file_path_cam3,'view3',subdir_cam3_view3(i).name);
        image_list_cam3=dir(image_path_cam3);
        for j=3:length(image_list_cam3)
            image_name=fullfile(image_path_cam3,image_list_cam3(j).name);
            label_train_cam3_view3=[label_train_cam3_view3;str2num(subdir_cam3_view3(i).name)];
            train_image_name_cam3_view3=[train_image_name_cam3_view3,image_name];
        end
    end
    for i=3:(length(subdir_cam3_view1))
        fprintf('process test data cam3 view1:%d/%d\n',i,(length(subdir_cam3_view1)));
        image_path_cam3=fullfile(param.file_path_cam3,'view1',subdir_cam3_view1(i).name);
        image_list_cam3=dir(image_path_cam3);
        for j=3:length(image_list_cam3)
            image_name=fullfile(image_path_cam3,image_list_cam3(j).name);
            label_train_cam3_view1=[label_train_cam3_view1;str2num(subdir_cam3_view1(i).name)];
            train_image_name_cam3_view1=[train_image_name_cam3_view1,image_name];
        end
    end
    for i=3:(length(subdir_cam3_view2))
        fprintf('process test data cam3 view2:%d/%d\n',i,(length(subdir_cam3_view2)));
        image_path_cam3=fullfile(param.file_path_cam3,'view2',subdir_cam3_view2(i).name);
        image_list_cam3=dir(image_path_cam3);
        for j=3:length(image_list_cam3)
            image_name=fullfile(image_path_cam3,image_list_cam3(j).name);
            label_train_cam3_view2=[label_train_cam3_view2;str2num(subdir_cam3_view2(i).name)];
            train_image_name_cam3_view2=[train_image_name_cam3_view2,image_name];
        end
    end
    for i=3:(length(subdir_cam3_view4))
        fprintf('process test data cam3 view4:%d/%d\n',i,(length(subdir_cam3_view4)));
        image_path_cam3=fullfile(param.file_path_cam3,'view4',subdir_cam3_view4(i).name);
        image_list_cam3=dir(image_path_cam3);
        for j=3:length(image_list_cam3)
            image_name=fullfile(image_path_cam3,image_list_cam3(j).name);
            label_train_cam3_view4=[label_train_cam3_view4;str2num(subdir_cam3_view4(i).name)];
            train_image_name_cam3_view4=[train_image_name_cam3_view4,image_name];
        end
    end
    
    % nameMapLabel_cam2 as anchor, it contains all the identities 
    % So that can be found in the other views 
    
    % set new label for each image
    % the label is the index of nameMapLabel_cam3
    for i=1:length(label_train_cam3_view1)
        temp=find(nameMapLabel_cam3==label_train_cam3_view1(i));
        label_train_cam3_view1(i)=temp+identity_num_cam2;
    end
    for i=1:length(label_train_cam3_view2)
        temp=find(nameMapLabel_cam3==label_train_cam3_view2(i));
        label_train_cam3_view2(i)=temp+identity_num_cam2;
    end
    for i=1:length(label_train_cam3_view3)
        temp=find(nameMapLabel_cam3==label_train_cam3_view3(i));
        label_train_cam3_view3(i)=temp+identity_num_cam2;
    end
    for i=1:length(label_train_cam3_view4)
        temp=find(nameMapLabel_cam3==label_train_cam3_view4(i));
        label_train_cam3_view4(i)=temp+identity_num_cam2;
    end
    