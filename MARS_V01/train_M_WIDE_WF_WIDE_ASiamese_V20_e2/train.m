%% matlab fix seed
seed = 123;
rng(seed);

addpath('../pre_pro_process');
addpath('../pre_pro_process/utils');
addpath('../pre_pro_process/CM_Curve');
addpath ../../CaffeMex_V28/matlab/
mainDir = '../';


%% train network config
modelDir = 'M_WIDE_WF_WIDE_ASiamese_V20_e2';
param.gpu_id = 5;
param.fintune_model = fullfile(mainDir, 'pretrain_model', 'googlenet_bn.caffemodel');
tracklet_num = 6;


param.solver_netfile = fullfile(mainDir, modelDir, 'solver.prototxt');
param.data_path = fullfile(mainDir, 'pre_pro_process', 'generate_data');
param.traindata_filename = 'train_data_r.mat';
param.save_model_file = 'MARS';
param.save_model_name = 'MARS_iter';
param.test_start = 40000;
param.test_interval = 5000;
param.train_maxiter = 100000;



param.use_gpu = 1;
gpuDevice(param.gpu_id + 1);
%%
split_index = 1;


    if ~exist(strcat(param.save_model_file, num2str(split_index)), 'file')
        mkdir(strcat(param.save_model_file, num2str(split_index)));
    end

    %% Load the training data
    load( fullfile(param.data_path, param.traindata_filename) );
    % load( fullfile(param.data_path, param.testdata_filename) );

    
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
    % solver_bn.prototxt
    caffe_solver = caffe.get_solver(param.solver_netfile, param.gpu_id);
    % fine-tune from GoogleNet.caffemodel
    caffe_solver.use_caffemodel(param.fintune_model);
    %test_bn.prototxt
    % net = caffe.get_net(param.test_net_file,'test');
    
    %% Train the model
    % batch data for each iteration
    input_data_shape = caffe_solver.nets{1}.blobs('data').shape;
    batch_size = input_data_shape(4);
    batch_data = zeros(input_data_shape, 'single');
    batch_label = zeros(1,1,1,batch_size, 'single');
    
    % The difference from the baseline
    %batch_sim=ones(1,1,1,1,'single');

    assert( mod(batch_size, tracklet_num) == 0 );
    frame_per_tracklet = batch_size / tracklet_num;
    tracklet_label = zeros(1,1,1, tracklet_num,'single');
    %
    image_attention = ones(1,1,1, batch_size, 'single');
    tracklet_attention = ones(1,1,1, tracklet_num, 'single');
    %
    train_x_axis=[];
    train_y_axis=[];

    iter=0;
    while iter < param.train_maxiter
        %% get and set batch data
        [batch_data, batch_label] = get_train_minibatch_Mars_V006_even(tracklet_num, frame_per_tracklet, ...
                                            batch_data, batch_label, batch_size, ...
                                            train_tracklets, train_labels);
    
        for i = 1 : tracklet_num
            tracklet_label(:,:,:, i) = batch_label(:,:,:, 1 + (i-1)*frame_per_tracklet);
        end

        caffe_solver.nets{1}.blobs('data').set_data(batch_data);
        caffe_solver.nets{1}.blobs('label').set_data(batch_label);
        %caffe_solver.nets{1}.blobs('sim').set_data(batch_sim);
        caffe_solver.nets{1}.blobs('tracklet_label').set_data(tracklet_label);
        % attention input
        caffe_solver.nets{1}.blobs('image_attention').set_data(image_attention);
        caffe_solver.nets{1}.blobs('tracklet_attention').set_data(tracklet_attention);
        %
        
        % launch one step of gradient descent
        caffe_solver.step(1);
        
        %% print && plot loss -> drawnow
        iter = caffe_solver.iter;
        if mod(iter,200) == 0
            loss3 = caffe_solver.nets{1}.blobs('loss3/loss').get_data;
            loss2 = caffe_solver.nets{1}.blobs('loss2/loss').get_data;
            loss1 = caffe_solver.nets{1}.blobs('loss1/loss').get_data;
            
            %triplet_loss = caffe_solver.nets{1}.blobs('triplet_loss').get_data;
            %contrastive_loss = caffe_solver.nets{1}.blobs('contrastive_loss').get_data;
            tracklet_loss = caffe_solver.nets{1}.blobs('tracklet/loss').get_data;
            WSiamese_loss_tracklet = caffe_solver.nets{1}.blobs('WSiamese/loss_tracklet').get_data;
            WSiamese_loss_image = caffe_solver.nets{1}.blobs('WSiamese/loss_image').get_data;

            
            train_x_axis = [train_x_axis, iter];
            train_y_axis = [train_y_axis, loss3];
            plot(train_x_axis, train_y_axis);
            drawnow;
            fprintf('iter= %d, loss3= %f, tracklet_loss=%f, WSiamese_loss_tracklet=%f, WSiamese_loss_image=%f, loss1=%f, loss2=%f\n',...
                iter, loss3, tracklet_loss, WSiamese_loss_tracklet, WSiamese_loss_image, loss1, loss2);
            %fprintf('iter= %d, loss3= %f, tracklet_loss=%f, WSiamese_loss_tracklet=%f, loss1=%f, loss2=%f\n',...
            %    iter, loss3, tracklet_loss, WSiamese_loss_tracklet, loss1, loss2);
            
        end

        %% save model , load test data, test script
        if iter >= param.test_start && mod(iter, param.test_interval) == 0
            %save
            model_name = strcat(param.save_model_file,num2str(split_index),...
                                    '/',param.save_model_name,'_',num2str(iter));
            caffe_solver.nets{1}.save(strcat(model_name, '.caffemodel'));

            % save solverstate
            %caffe_solver.savestate( strcat(model_name, '_snapshot_') ); 

            mat_path = strcat('error', num2str(iter), '.mat');
            save(mat_path, 'train_x_axis', 'train_y_axis');
        end
    end

    mat_path = strcat('error', num2str(iter), '.mat');
    save(mat_path, 'train_x_axis', 'train_y_axis');




exit;
