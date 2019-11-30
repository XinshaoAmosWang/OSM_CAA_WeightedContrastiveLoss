function [tracklet_feature] = process_tracklet_quality_local3(net, tracklet, batch_size)
%PROCESS_TRACKLET_QUALITY_LOCAL3 Summary of this function goes here
%The fixed quality version
%   1. Input
%       net: the trained model
%       tracklet: image names cell
%       batch_size: the maximum input for each forward
%   2. Process
%       a. form batch
%       b. forward
%       c. extract output features
%   3. Output: (1, dim)
feature1 = [];
feature2 = [];
feature3 = [];
score = [];

num_img = length(tracklet);
num_batch = floor(num_img/batch_size);

net.blobs('data').reshape([224 224 3 batch_size]);

for bt = 1 : num_batch
    % form batch
    batch_data = zeros(224, 224, 3, batch_size, 'single');
    for ind = 1 : batch_size
        ind_img = (bt-1)*batch_size + ind;
        img_name = tracklet{ind_img};
        batch_data(:,:,:, ind) = process_image( img_name );
    end
    % set_data, forward
    net.blobs('data').set_data(batch_data);
    net.forward_prefilled;
    % extract features
    feature1 = [feature1; (squeeze(net.blobs('data1_p_1').get_data))'];
    feature2 = [feature2; (squeeze(net.blobs('data1_p_2').get_data))'];
    feature3 = [feature3; (squeeze(net.blobs('data1_p_3').get_data))'];
    score = [score; (squeeze(net.blobs('sig').get_data))'];
end

% remained images
if  mod(num_img, batch_size) ~= 0
    remained_images = tracklet(num_batch*batch_size + 1 : end);
    num_img_remained = length(remained_images);
    batch_data = zeros(224, 224, 3, num_img_remained, 'single');

    net.blobs('data').reshape([224 224 3 num_img_remained]);

    for ind = 1 : num_img_remained
        img_name = remained_images{ind};
        batch_data(:,:,:, ind) = process_image( img_name );
    end

    % set data, forward
    net.blobs('data').set_data(batch_data);
    net.forward_prefilled;
    % extract features
    feature1 = [feature1; (squeeze(net.blobs('data1_p_1').get_data))'];
    feature2 = [feature2; (squeeze(net.blobs('data1_p_2').get_data))'];
    feature3 = [feature3; (squeeze(net.blobs('data1_p_3').get_data))'];
    score = [score; (squeeze(net.blobs('sig').get_data))'];
end

% the quality-based fusion

feature1 = bsxfun(@times, feature1, score(:,1));
feature2 = bsxfun(@times, feature2, score(:,2));
feature3 = bsxfun(@times, feature3, score(:,3));
tracklet_feature = [sum( feature1 / sum(score(:,1)) ),...
                    sum( feature2 / sum(score(:,2)) ),...
                    sum( feature3 / sum(score(:,3)) )];


end

