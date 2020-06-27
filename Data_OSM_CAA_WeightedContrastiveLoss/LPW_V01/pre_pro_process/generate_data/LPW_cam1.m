   
    % scene1: for test
    subdir_cam1_view1=dir(fullfile(param.file_path_cam1,'view1'));
    subdir_cam1_view2=dir(fullfile(param.file_path_cam1,'view2'));
    subdir_cam1_view3=dir(fullfile(param.file_path_cam1,'view3'));
    
    %generate test data
    test_data_cam1=[];
    label_test_cam1=[];
    test_image_name_cam1={};
    test_data_cam2=[];
    label_test_cam2=[];
    test_image_name_cam2={};
    test_data_cam3=[];
    label_test_cam3=[];
    test_image_name_cam3={};
    
    nameMapLabel=[];
    
    for i=3:(length(subdir_cam1_view2))
        nameMapLabel=[nameMapLabel;str2num(subdir_cam1_view2(i).name)];
        
        fprintf('process test data view2:%d/%d\n',i,(length(subdir_cam1_view2)));
        image_path_cam2=fullfile(param.file_path_cam1,'view2',subdir_cam1_view2(i).name);
        image_list_cam2=dir(image_path_cam2);
        for j=3:length(image_list_cam2)
            image_name=fullfile(image_path_cam2,image_list_cam2(j).name);
            label_test_cam2=[label_test_cam2;str2num(subdir_cam1_view2(i).name)];
            test_image_name_cam2=[test_image_name_cam2,image_name];
        end
    end
    for i=3:(length(subdir_cam1_view1))
        fprintf('process test data view1:%d/%d\n',i,(length(subdir_cam1_view1)));
        image_path_cam1=fullfile(param.file_path_cam1,'view1',subdir_cam1_view1(i).name);
        image_list_cam1=dir(image_path_cam1);
        for j=3:length(image_list_cam1)
            image_name=fullfile(image_path_cam1,image_list_cam1(j).name);
            label_test_cam1=[label_test_cam1;str2num(subdir_cam1_view1(i).name)];
            test_image_name_cam1=[test_image_name_cam1,image_name];
        end
    end
    for i=3:(length(subdir_cam1_view3))
        fprintf('process test data view3:%d/%d\n',i,(length(subdir_cam1_view3)));
        image_path_cam3=fullfile(param.file_path_cam1,'view3',subdir_cam1_view3(i).name);
        image_list_cam3=dir(image_path_cam3);
        for j=3:length(image_list_cam3)
            image_name=fullfile(image_path_cam3,image_list_cam3(j).name);
            label_test_cam3=[label_test_cam3;str2num(subdir_cam1_view3(i).name)];
            test_image_name_cam3=[test_image_name_cam3,image_name];
        end
    end
    
    
    % nameMapLabel_cam1 as anchor, it contains all the identities 
    % So that can be found in the other views 
    
    % set new label for each image
    % the label is the index of nameMapLabel_cam1
    for i=1:length(label_test_cam1)
        temp=find(nameMapLabel==label_test_cam1(i));
        label_test_cam1(i)=temp;
    end
    for i=1:length(label_test_cam2)
        temp=find(nameMapLabel==label_test_cam2(i));
        label_test_cam2(i)=temp;
    end
    for i=1:length(label_test_cam3)
        temp=find(nameMapLabel==label_test_cam3(i));
        label_test_cam3(i)=temp;
    end
    