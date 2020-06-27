
ids = unique(train_labels);

count_arr = zeros(length(ids), 1);
for i = 1 : length(ids)
   id = ids(i);
   
   ind = (train_labels == id);
   labels = train_labels(ind);
   
   count_arr(i) = length(labels);
end

min(count_arr)

find(count_arr == min(count_arr))

sum(count_arr)
   