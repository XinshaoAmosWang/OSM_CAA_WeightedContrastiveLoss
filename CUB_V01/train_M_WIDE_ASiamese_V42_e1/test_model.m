%%
%pause(1*60*60*4.0)

addpath('../pre_pro_process');
addpath('../pre_pro_process/utils');
addpath ../../CaffeMex_V28/matlab/
mainDir = '../';


modelDir = 'M_WIDE_ASiamese_V42_e1';
param.gpu_id = 1;
param.test_batch_size = 64;
param.test_net_file = fullfile(mainDir, modelDir, 'test_M.prototxt');


param.save_model_file = 'CUB';
param.save_model_name = 'CUB_iter';
load( 'CUB_200_2011_TestImageDataCell.mat' );
split_index = 1;
param.use_gpu = 1;
gpuDevice(param.gpu_id + 1);

for iter = 1000 : 250 : 3000
	cur_path = pwd;
	caffe.reset_all;
	caffe.set_mode_gpu();
	caffe.set_device(param.gpu_id);
	caffe.init_log(fullfile(cur_path, 'log'));
	
	model_path = strcat(param.save_model_file, num2str(split_index),...
						'/', param.save_model_name, '_', num2str(iter), '.caffemodel');
	net = caffe.get_net(param.test_net_file, model_path, 'test');

	record_file = 'CUB_Recall.txt';
	test_one_model;
end

exit;
