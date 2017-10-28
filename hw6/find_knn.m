pkg load statistics;

# load training data
[x1,x2,x3,x4,x5,x6,x7,x8,y1] = textread('yeast_train.txt', '%f,%f,%f,%f,%f,%f,%f,%f,%s');
trainSet = [x1,x2,x3,x4,x5,x6,x7,x8];     # remove label column
yTrainUnique = unique(y1);                # create a vector for unique labels
yTrain = str2num4label(y1, yTrainUnique); # get the unique vector number for each string label

# load testing data
[x1,x2,x3,x4,x5,x6,x7,x8,y2] = textread('yeast_train.txt', '%f,%f,%f,%f,%f,%f,%f,%f,%s');
testSet = [x1,x2,x3,x4,x5,x6,x7,x8];      # remove label column
yTestUnique = unique(y2);                 # create a vector for unique labels
yTest = str2num4label(y2, yTestUnique);   # get the unique vector number for each string label

# normalize data
trainSet = normalize(trainSet);
testSet  = normalize(testSet);

# k-fold partition   
CVO = cvpartition(yTrain, 'KFold', 10);
numTestSets = get(CVO, 'NumTestSets');
C = struct(CVO).inds;
E = zeros(numTestSets, 1);
k = 20;

# print the number of 'k' instances
fprintf(' K = %d\n', k);

# cross-validation
correctInstCnt = 0;   # total number of correct classfier instances
testInstCnt = 0;      # total number of test instances
for i = 1:numTestSets
  testIdx = cvotest(C, i);
  trainIdx = cvotraining(C, i);
  testSize = get(CVO, 'TestSize')(i);
  testInstCnt += testSize;
  
  for j = 1:k
    yTestP = knn(trainSet(trainIdx,:), trainSet(testIdx,:), yTrain(trainIdx,:), j); # predictions
    err(j) = sum(1 - (yTestP == yTrain(testIdx)'))./testSize;                       # average error of 'testSize'
  endfor
  
  # print predictions
  str_prediction = num2str4label(yTestP', yTrainUnique);
  #fprintf('\n   Predictions  | Actual result\n');
  for l = 1:length(str_prediction)
    predct = str_prediction(l){1};
    actual = y1(l){1};
    #fprintf('\t%s\t|\t%s\n', predct, actual);
    if (strcmp(predct, actual)) 
      correctInstCnt++;
    endif
  endfor
  
  E(i) = sum(err)/k;  # average error of 'k' iteration
endfor

fprintf('\n Total number of correct classified instances: %d', correctInstCnt);
fprintf('\n Total number of test instances: %d\n', testInstCnt); 
fprintf('\n Min error = %d\n\n', min(E));

