%%

addpath('../pre_pro_process/utils');
addpath ../../CaffeMex_V28/matlab/
mainDir = '../';



modelDir = 'M_WIDE_WF_WIDE_ASiamese_V20_e5';
param.gpu_id = 3;
param.test_batch_size = 64;
param.test_net_file = fullfile(mainDir, modelDir, 'test_M.prototxt');


param.save_model_file = 'LPW';
param.save_model_name = 'LPW_iter';
param.data_path = fullfile(mainDir, 'pre_pro_process', 'generate_data');
param.testdata_filename = 'test_data_LPW1';
split_index = 1;
load(fullfile(param.data_path, param.testdata_filename,  'test_data_tracklet_format.mat'));
param.use_gpu = 1;
gpuDevice(param.gpu_id + 1);

param.result_save_file=strcat('LPW_TEST_AF', '.txt');
for iter = 60000 : 5000 : 60000
	cur_path = pwd;
	caffe.reset_all;
	caffe.set_mode_gpu();
	caffe.set_device(param.gpu_id);
	caffe.init_log(fullfile(cur_path, 'log'));
	
	model_path = strcat(param.save_model_file, num2str(split_index),...
						'/', param.save_model_name, '_', num2str(iter), '.caffemodel');
	net = caffe.get_net(param.test_net_file, model_path, 'test');
	net.blobs('data').reshape([224 224 3 param.test_batch_size]);
	
	feature_dim = 1024;
	test_script_LPW_1024_tracklet;
end


exit;
