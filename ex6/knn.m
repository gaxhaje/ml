pkg load statistics;

## calculate nearest neighor
function retval = myKNN(trainSet, testSet, yTrain, k)
  M = pdist2(trainSet, testSet);
  
  retval = 0;
  for i = 1 : size(testSet, 1)
    [sorted ind] = sort(M(:,i));  # sort each column.
    nn = ind(1:k);
    ytest_p(i) = mode(yTrain(nn));
  endfor
  
  retval = ytest_p;
  return;
endfunction

function retval = normalize(X)
  for i = 1 : size(X,2)
    p = X(:,i);
    p = p-mean(p);
    p = p./std(p);
    X(:,i) = p;
  endfor
  
  retval = X;
  return;
endfunction


# train
trainSet = dlmread('wine_train.txt', ',');
testSet = dlmread('wine_test.txt', ',');
yTrain = trainSet(:,12);
yTest = testSet(:,12);
trainSet(:,12)=[];                # remove class label
testSet(:,12)=[];                 # remove class label
trainSet = normalize(trainSet);   # normalize
testSet = normalize(testSet);     # normalize

yTestP = myKNN(trainSet, testSet, yTrain, 20);    # predictions
E = sum(1 - (yTestP == yTest'))/size(testSet, 1); # error
E
