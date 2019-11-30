function [img] = img_cut_out(img, min_h, min_w, max_h, max_w)
% cut out image, a large cut out
% min_h, min_w: The minimize height and width to cut out.   

% cut out
height = size(img, 1);
width = size(img, 2);

cut_h = min_h + ceil( rand(1)*(max_h - 1 - min_h) );
cut_w = min_w + ceil( rand(1)*(max_w - 1 - min_w) );

h_start = ceil( rand(1) * (height - cut_h) );
w_start = ceil( rand(1) * (width - cut_w) );

h_end = h_start + cut_h;
w_end = w_start + cut_w;

img(h_start:h_end, w_start:w_end, :) = floor( rand( size( img(h_start:h_end, w_start:w_end, :) ) ) * 256 );

end

