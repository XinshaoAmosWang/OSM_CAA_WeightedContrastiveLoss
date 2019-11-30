%%

addpath('../pre_pro_process');
addpath('../pre_pro_process/utils');
addpath('../pre_pro_process/CM_Curve');
addpath ../../CaffeMex_V28/matlab/
mainDir = '../';



modelDir = 'M_WIDE_WF_WIDE_ASiamese_V20_e2';
param.gpu_id = 0;
param.test_batch_size = 64;
param.test_net_file = fullfile(mainDir, modelDir, 'test_M.prototxt');


param.save_model_file = 'MARS';
param.save_model_name = 'MARS_iter';
param.data_path = fullfile(mainDir, 'pre_pro_process', 'generate_data');
param.testdata_filename = 'test_data.mat';
load( fullfile(param.data_path, param.testdata_filename) );
split_index = 1;
param.use_gpu = 1;
gpuDevice(param.gpu_id + 1);

iter = 60000
	cur_path = pwd;
	caffe.reset_all;
	caffe.set_mode_gpu();
	caffe.set_device(param.gpu_id);
	caffe.init_log(fullfile(cur_path, 'log'));
	
	model_path = strcat(param.save_model_file, num2str(split_index),...
						'/', param.save_model_name, '_', num2str(iter), '.caffemodel');
	net = caffe.get_net(param.test_net_file, model_path, 'test');
	test_script_Mars_global_rerank;
