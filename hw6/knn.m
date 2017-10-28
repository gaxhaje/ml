## calculate nearest neighor
function retval = knn(trainSet, testSet, yTrain, k)
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



