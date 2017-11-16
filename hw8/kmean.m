close all; clear all;

pkg load statistics;

d = dlmread('mnist_train.csv');
label = d(:,1); # move label to its own matrix
d(:,1)=[];      # delete label column
K_all = [5 10 15 20 25]; # number of centers
CLS = zeros(10,1000);

for i = 1:numel(K_all)  # run for each k instance
  k =  K_all(i);        # assign k
  
  for j=1:10
    p=randperm(size(d,1));
    c = d(p(1:k),:);   # grab k centers from data
    [o, class] = mykmeans(d, c);
    E(j) = o;
    CLS(j,:)= class;
  endfor
  
   # get clusters based on min error
  [min_err min_err_idx] = min(E);
  clusters = CLS(min_err_idx, :);
  
  ERRK(i) = min_err;

endfor

plot(K_all, ERRK);

