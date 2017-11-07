pkg load statistics;

d = dlmread('mnist_train.csv');
label = d(:,1); # move label to its own matrix
d(:,1)=[];      # delete label column
k = 10;         # number of centers
CLS = zeros(10,1000);

for i=1:10
  p=randperm(size(d,1));
  c = d(p(1:k),:);   # grab k centers from data
  #[o, class] = mykmeans(d, c);
  o = mykmeans(d, c);
  #class
  #E(i) = o;
  %CLS(i,:)= class;
endfor

#E
