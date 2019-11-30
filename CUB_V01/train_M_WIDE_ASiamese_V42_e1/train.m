%matlab fix seed
%pause(1*60*60*5)

seed = 123;
rng(seed);
%% train network config
addpath('../pre_pro_process');
addpath('../pre_pro_process/utils');
load('CUB_200_2011_TrainImageDataCell.mat')
addpath ../../CaffeMex_V28/matlab/
mainDir = '../';



modelDir = 'M_WIDE_ASiamese_V42_e1';
param.gpu_id = 3;
param.fintune_model = fullfile(mainDir, 'pretrain_model', 'googlenet_bn.caffemodel');
id_num = 8;
image_per_id = 7;

param.solver_netfile = fullfile(mainDir, modelDir, 'solver.prototxt');
param.save_model_file = 'CUB';
param.save_model_name = 'CUB_iter';
%
param.save_start = 1000;
param.save_interval = 250;
param.train_maxiter = 3000;
output_interval = 20;
%
%
param.use_gpu = 1;
gpuDevice(param.gpu_id + 1);
%%
split_index = 1;

    if ~exist(strcat(param.save_model_file, num2str(split_index)),'file')
        mkdir(strcat(param.save_model_file, num2str(split_index)));
    end
    
    %% find caffe -> reset_all ->init_log -> set_mode_gpu
    cur_path = pwd;
    caffe.reset_all;

    %caffe fix seed
    caffe.set_random_seed(seed);
    if param.use_gpu
        caffe.set_mode_gpu;
        caffe.set_device(param.gpu_id);
    else
        caffe.set_mode_cpu;
    end
    caffe.init_log(fullfile(cur_path,'log'));
    
    %% caffe model init
    caffe_solver = caffe.get_solver(param.solver_netfile, param.gpu_id);
    caffe_solver.use_caffemodel(param.fintune_model);
    
    %% Train the model
    % batch data for each iteration
    input_data_shape = caffe_solver.nets{1}.blobs('data').shape;
    batch_size = input_data_shape(4);
    batch_data = zeros(input_data_shape, 'single');
    batch_label = zeros(1,1,1,batch_size, 'single');
    %
    image_attention = ones(1,1,1, batch_size, 'single');
    %
    train_x_axis=[];
    train_y_axis=[];

    iter=0;
    while iter < param.train_maxiter
        %% get and set batch data
        [batch_data, batch_label] = get_train_minibatch ( id_num, image_per_id, ...
                                        batch_data, batch_label, batch_size, ...
                                        class_ids,  CUB_200_2011_TrainImageDataCell);
        
        caffe_solver.nets{1}.blobs('data').set_data(batch_data);
        caffe_solver.nets{1}.blobs('label').set_data(batch_label);
        % attention input
        caffe_solver.nets{1}.blobs('image_attention').set_data(image_attention);
        %
        % launch one step of gradient descent
        caffe_solver.step(1);
        
        %% print && plot loss -> drawnow
        iter = caffe_solver.iter;
        if mod(iter, output_interval) == 0
            loss3 = caffe_solver.nets{1}.blobs('loss3/loss').get_data;
            loss2 = caffe_solver.nets{1}.blobs('loss2/loss').get_data;
            loss1 = caffe_solver.nets{1}.blobs('loss1/loss').get_data;
            
            WSiamese_loss_image = caffe_solver.nets{1}.blobs('WSiamese/loss_image').get_data;
            
            train_x_axis = [train_x_axis, iter];
            train_y_axis = [train_y_axis, loss3];
            plot(train_x_axis, train_y_axis);
            drawnow;
            fprintf('iter= %d, loss3= %f, WSiamese_loss_image=%f, loss1=%f, loss2=%f\n',...
                iter, loss3, WSiamese_loss_image, loss1, loss2);
            
        end

        %% save model 
        if iter >= param.save_start && mod(iter, param.save_interval) == 0
            %save
            model_name = strcat(param.save_model_file,num2str(split_index),...
                                    '/',param.save_model_name,'_',num2str(iter));
            caffe_solver.nets{1}.save(strcat(model_name, '.caffemodel'));

            % save solverstate
            caffe_solver.savestate( strcat(model_name, '_snapshot_') ); 

            mat_path = strcat('error', num2str(iter), '.mat');
            save(mat_path, 'train_x_axis', 'train_y_axis');
        end
    end

    mat_path = strcat('error', num2str(iter), '.mat');
    save(mat_path, 'train_x_axis', 'train_y_axis');




exit;
