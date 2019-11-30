
%% compute prob_feature, gallery_feature, prob_label, gallery_label

tracklet_num = length(test_tracklets);
tracklet_features = zeros(tracklet_num, feature_dim);

for tl = 1 : tracklet_num
    tracklet = test_tracklets{tl};
    
    tracklet_features(tl,:) = process_tracklet_avg_global(net, tracklet, param.test_batch_size);
end

%prob_num
cam2_num = 756;

gallery_feature = tracklet_features( (cam2_num+1) : end, :);
gallery_label = test_labels( (cam2_num+1) : end, :);

prob_feature = tracklet_features( 1 : cam2_num, :);
prob_label = test_labels( 1 : cam2_num, :);


%% cal cmc
prob_norm = bsxfun(@rdivide, prob_feature, sum(abs(prob_feature).^2, 2).^(1/2));
gallery_norm = bsxfun(@rdivide, gallery_feature, sum(abs(gallery_feature).^2, 2).^(1/2));
score_matrix = prob_norm * gallery_norm';

rank1_hit = 0;
rank5_hit = 0;
rank10_hit = 0;
rank20_hit = 0;
problen = size(prob_feature, 1);
for m = 1 : problen
    [~, location_temp] = sort(score_matrix(m,:), 2, 'descend');
    location = gallery_label(location_temp);
    if find(location(1) == prob_label(m))
        rank1_hit = rank1_hit + 1;
    end
    if find(location(1:5) == prob_label(m))
        rank5_hit = rank5_hit + 1;
    end
    if find(location(1:10) == prob_label(m))
        rank10_hit = rank10_hit+1;
    end
    if find(location(1:20) == prob_label(m))
        rank20_hit = rank20_hit+1;
    end
end
rank_acc = [rank1_hit / problen, rank5_hit / problen, rank10_hit / problen, rank20_hit / problen];

fin = fopen(param.result_save_file, 'a');
fprintf(fin, 'split_index:%d,iter:%d, rank1:%f,rank5:%f,rank10:%f,rank20:%f\n', split_index, iter, rank_acc(1), rank_acc(2), rank_acc(3), rank_acc(4));
fprintf('split_index:%d,iter:%d, rank1:%f,rank5:%f,rank10:%f,rank20:%f\n', split_index, iter, rank_acc(1), rank_acc(2), rank_acc(3), rank_acc(4));
fclose(fin);
