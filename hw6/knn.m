pkg load statistics;

## calculate nearest neighor
function retval = myKNN(trainSet, testSet, yTrain, k)
  retval = 0;
  M = pdist2(trainSet, testSet);
  
  for i = 1:size(testSet, 1)
    [sorted ind] = sort(M(:,i));  # sort each column.
    nn = ind(1:k);
    ytest_p(i) = mode(yTrain(nn));
  endfor
  
  retval = ytest_p;
  return;
endfunction

function retval = normalize(X)
  for i = 1:size(X,2)
    p = X(:,i);
    p = p-mean(p);
    
    # avoid divide-by-zero warnings
    if (std(p) > 0)
      p = p./std(p);
    else
      p = 0;
    endif
    
    X(:,i) = p;
  endfor
  
  retval = X;
  return;
endfunction


# load data
trainSet = dlmread('yeast_train.txt', ',');
testSet = dlmread('yeast_test.txt', ',');

# 10-fold cross-validation partition
NumTestSets = columns (trainSet);
c = cvpartition (trainSet(:,1), 'KFold', NumTestSets)
err = zeros(NumTestSets, 1);

for i = 1:NumTestSets
  yTrain = trainSet(:,i);
  yTest = testSet(:,i);
  trainSet = normalize(trainSet);   # normalize
  testSet = normalize(testSet);     # normalize
  idx1 = test (c, i);
  idx2 = training (c, i);
  yTestP = myKNN(trainSet(idx1,:), testSet(idx2,:), yTrain, 20);      # predictions
  #err(i) = sum(1 - (yTestP == yTest'))/size(testSet, 1); # error
endfor


# output
#E

# predictions

