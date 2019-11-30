% Workspace parameters:
% net:
% param.test_batch_size: 

% test_tracklets: 
% test_labels:
% test_cameras:
% query_IDX: 

load('query_IDX.mat');

feature_dim = 1024 * 1;

tracklet_num = length(test_tracklets);
tracklet_features = zeros(tracklet_num, feature_dim);

for tl = 1 : tracklet_num
    tracklet = test_tracklets{tl};
    
    tracklet_features(tl,:) = process_tracklet_ave_global(net, tracklet, param.test_batch_size);
end

gallery_feature = tracklet_features;
prob_feature = tracklet_features(query_IDX, :);

%% cosine score matrix
% the higher value, the more similiar
prob_norm = bsxfun(@rdivide, prob_feature, sum(abs(prob_feature).^2,2).^(1/2));
gallery_norm = bsxfun(@rdivide, gallery_feature, sum(abs(gallery_feature).^2,2).^(1/2));
%score_matrix = gallery_norm*prob_norm'; %(12180, 1980)
% the smaller, the more similiar
%score_matrix = 1 - score_matrix;

%% re-ranking setting
%k1 = 20;
%k2 = 6;
%lambda = 0.3;
%k1 = 20;
%k2 = 6;
%lambda = 0.5;
k1 = 7;
k2 = 3;
lambda = 0.85;


rerank_feat = [prob_norm' gallery_norm'];
query_num = size(prob_feature, 1);
cosine_re_rank = re_ranking_cosine( rerank_feat, 1, 1, query_num, k1, k2, lambda);
size(cosine_re_rank)
%%


%%
label_gallery = test_labels;
label_query = test_labels(query_IDX);
cam_gallery = test_cameras;
cam_query = test_cameras(query_IDX);
[CMC_arr, mAP, r1_pairwise, ap_pairwise] = evaluation_mars(cosine_re_rank, ...
                                                  label_gallery, label_query, cam_gallery, cam_query);

record_file1 = 'without_minus1_rerank.txt';
fin = fopen(record_file1, 'a');
fprintf(fin, 'iter: %d, rank1: %f, rank5: %f, rank10: %f, rank20: %f, mAP: %f\n', iter, CMC_arr(1), CMC_arr(5), CMC_arr(10), CMC_arr(20), mAP);
fclose(fin);
