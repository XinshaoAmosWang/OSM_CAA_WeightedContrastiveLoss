    
    % scene2: for train
    subdir_cam2_view1=dir(fullfile(param.file_path_cam2,'view1'));
    subdir_cam2_view2=dir(fullfile(param.file_path_cam2,'view2'));
    subdir_cam2_view3=dir(fullfile(param.file_path_cam2,'view3'));
    subdir_cam2_view4=dir(fullfile(param.file_path_cam2,'view4'));
    
    label_train_cam2_view1=[];
    train_image_name_cam2_view1={};
    label_train_cam2_view2=[];
    train_image_name_cam2_view2={};
    label_train_cam2_view3=[];
    train_image_name_cam2_view3={};
    label_train_cam2_view4=[];
    train_image_name_cam2_view4={};
    
    nameMapLabel_cam2=[]; % store all the id labels (str2num)
    
    for i=3:(length(subdir_cam2_view3)) % for each person identity
        nameMapLabel_cam2=[nameMapLabel_cam2;str2num(subdir_cam2_view3(i).name)];

        fprintf('process train data cam2 view3:%d/%d\n',i,(length(subdir_cam2_view3)));
        image_path_cam2=fullfile(param.file_path_cam2,'view3',subdir_cam2_view3(i).name);
        image_list_cam2=dir(image_path_cam2);
        for j=3:length(image_list_cam2) % for each person images list
            image_name=fullfile(image_path_cam2,image_list_cam2(j).name);
            label_train_cam2_view3=[label_train_cam2_view3;str2num(subdir_cam2_view3(i).name)];
            train_image_name_cam2_view3=[train_image_name_cam2_view3,image_name];
        end
    end
    for i=3:(length(subdir_cam2_view1))
        fprintf('process test data cam2 view1:%d/%d\n',i,(length(subdir_cam2_view1)));
        image_path_cam2=fullfile(param.file_path_cam2,'view1',subdir_cam2_view1(i).name);
        image_list_cam2=dir(image_path_cam2);
        for j=3:length(image_list_cam2)
            image_name=fullfile(image_path_cam2,image_list_cam2(j).name);
            label_train_cam2_view1=[label_train_cam2_view1;str2num(subdir_cam2_view1(i).name)];
            train_image_name_cam2_view1=[train_image_name_cam2_view1,image_name];
        end
    end
    for i=3:(length(subdir_cam2_view2))
        fprintf('process test data cam2 view2:%d/%d\n',i,(length(subdir_cam2_view2)));
        image_path_cam2=fullfile(param.file_path_cam2,'view2',subdir_cam2_view2(i).name);
        image_list_cam2=dir(image_path_cam2);
        for j=3:length(image_list_cam2)
            image_name=fullfile(image_path_cam2,image_list_cam2(j).name);
            label_train_cam2_view2=[label_train_cam2_view2;str2num(subdir_cam2_view2(i).name)];
            train_image_name_cam2_view2=[train_image_name_cam2_view2,image_name];
        end
    end
    for i=3:(length(subdir_cam2_view4))
        fprintf('process test data cam2 view2:%d/%d\n',i,(length(subdir_cam2_view4)));
        image_path_cam2=fullfile(param.file_path_cam2,'view4',subdir_cam2_view4(i).name);
        image_list_cam2=dir(image_path_cam2);
        for j=3:length(image_list_cam2)
            image_name=fullfile(image_path_cam2,image_list_cam2(j).name);
            label_train_cam2_view4=[label_train_cam2_view4;str2num(subdir_cam2_view4(i).name)];
            train_image_name_cam2_view4=[train_image_name_cam2_view4,image_name];
        end
    end
    
    
    % nameMapLabel_cam2 as anchor, it contains all the identities 
    
    % set new label for each image
    % the label is the index of nameMapLabel_cam2
    for i=1:length(label_train_cam2_view1)
        % temp is the index of nameMapLabel_cam2
        temp=find(nameMapLabel_cam2==label_train_cam2_view1(i));
        label_train_cam2_view1(i)=temp;
    end
    for i=1:length(label_train_cam2_view2)
        temp=find(nameMapLabel_cam2==label_train_cam2_view2(i));
        label_train_cam2_view2(i)=temp;
    end
    for i=1:length(label_train_cam2_view3)
        temp=find(nameMapLabel_cam2==label_train_cam2_view3(i));
        label_train_cam2_view3(i)=temp;
    end
    for i=1:length(label_train_cam2_view4)
        temp=find(nameMapLabel_cam2==label_train_cam2_view4(i));
        label_train_cam2_view4(i)=temp;
    end
    
    