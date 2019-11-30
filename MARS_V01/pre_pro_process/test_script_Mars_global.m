% Workpace parameters:
% net:
% param.test_batch_size: 

% test_tracklets: 
% test_labels:
% test_cameras:
% query_IDX: 

load('query_IDX.mat');


tracklet_num = length(test_tracklets);
tracklet_features = zeros(tracklet_num, feature_dim);

for tl = 1 : tracklet_num
    tracklet = test_tracklets{tl};
    
    tracklet_features(tl,:) = process_tracklet_avg_global(net, tracklet, param.test_batch_size);
end

gallery_feature = tracklet_features;
prob_feature = tracklet_features(query_IDX, :);

%% cosine score matrix
% the higher value, the more similiar
prob_norm = bsxfun(@rdivide, prob_feature, sum(abs(prob_feature).^2,2).^(1/2));
gallery_norm = bsxfun(@rdivide, gallery_feature, sum(abs(gallery_feature).^2,2).^(1/2));
score_matrix = gallery_norm*prob_norm'; %(12180, 1980)
% the smaller, the more similiar
score_matrix = 1 - score_matrix;

%%
label_gallery = test_labels;
label_query = test_labels(query_IDX);
cam_gallery = test_cameras;
cam_query = test_cameras(query_IDX);
[CMC_arr, mAP, r1_pairwise, ap_pairwise] = evaluation_mars(score_matrix, ...
                                                  label_gallery, label_query, cam_gallery, cam_query);
[ap_CM, r1_CM] = draw_confusion_matrix(ap_pairwise, r1_pairwise, cam_query);

fprintf('average of confusion matrix :  mAP = %f, r1 precision = %f\r\n',...
        (sum(ap_CM(:))-sum(diag(ap_CM)))/30, (sum(r1_CM(:))-sum(diag(r1_CM)))/30);


fin = fopen(record_file1, 'a');
fprintf(fin, 'iter: %d, rank1: %f, rank5: %f, rank10: %f, rank20: %f, mAP: %f\n', iter, CMC_arr(1), CMC_arr(5), CMC_arr(10), CMC_arr(20), mAP);
fclose(fin);


fin = fopen(record_file2, 'a');
fprintf(fin, 'iter: %d, rank1: %f, mAP: %f\n', iter,  (sum(r1_CM(:))-sum(diag(r1_CM)))/30, (sum(ap_CM(:))-sum(diag(ap_CM)))/30);
