pkg load statistics;

d = dlmread('mnist_train.csv');
label = d(:,1); # move label to its own matrix
d(:,1)=[];      # delete label column
k = 10;         # initialize k
c = d(1:k,:);   # grab k centers from data

function mykmeans (data, centers)
  dist = pdist2 (data, centers);
  [minVal idx] = min(dist');
  class = idx'
  
  for i = i:size(centers,1)
    idxClass = find(class == i);
    centers(i,:) = mean(data(idxClass,:));
  endfor
 
endfunction

mykmeans(d, c);