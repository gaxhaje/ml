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
K_all = [10 15 20 25];

correctInstCnt = 0;     # total number of correct classfier instances

for i = 1:numel(K_all)  # run for each k instance
  k =  K_all(i)         # assign k
 
  # partition data with 'k-fold' method
  CVO = cvpartition(yTrain, 'KFold', 10);
  numTestSets = get(CVO, 'NumTestSets');
  C = struct(CVO).inds;
  E = zeros(numTestSets, 1);
   
  # cross-validation
  for j = 1:numTestSets
    testIdx = cvotest(C, j);
    trainIdx = cvotraining(C, j);
    testSize = get(CVO, 'TestSize')(j);
    
    yTestP = knn(trainSet(trainIdx,:), trainSet(testIdx,:), yTrain(trainIdx,:), k); # predictions
    err(j) = sum(1 - (yTestP == yTrain(testIdx)'))./testSize;                       # average error of 'testSize'
  endfor
  
  #{
  # print predictions
  str_prediction = num2str4label(yTestP', yTrainUnique);
  str_actual = num2str4label(yTrain, yTrainUnique);
  fprintf('\n   Predictions  | Actual result\n');
  for l = 1:length(yTestP)
    predct = str_prediction(l){1};
    actual = str_actual(l){1};
    fprintf('\t%s\t|\t%s\n', predct, actual);
    if (strcmp(predct, actual))
      correctInstCnt++;
    endif
  endfor
  fprintf('\n Correct instances: %d out of %d\n\n', correctInstCnt, length(yTestP));
  #}
  
  Err_all(i) = sum(err)/k;  # average error of 'k' iteration
endfor

[K_all' Err_all']   # error for each 'k' instance
fprintf('\n Min error = %d\n\n', min(Err_all));


##########
# part 2 #
##########

# plot test-set accuracy as a function of k, for k =1,5,10,15,20
K_part2_1 = [1 5 10 15 20];
for i = 1:numel(K_part2_1)
  k = K_part2_1(i);
  yTestP = knn(trainSet, testSet, yTrain, k); # predictions
  Err_part2_1(i) = sum(1 - (yTestP == yTest'))./length(yTest);
endfor

# plot accuracy
figure 1;
plot(K_part2_1, Err_part2_1);
title('Test-set accuracy');
xlabel('Value of k');
ylabel('Error accuracy');
legend('Error function');

# confusion-matrix
K_part2_2 = [1 15];
cm_len = length(yTestUnique);  # set confusion-matrix dimensions

for i = 1:numel(K_part2_2)
  k = K_part2_2(i);
  
  printf('\n k = %d\n', k);
    
  confusion_matrix = zeros(cm_len, cm_len);
  yTestP = knn(trainSet, testSet, yTrain, k); # predictions
  Err_part2_2(i) = sum(1 - (yTestP == yTest'))./length(yTest);
  
  for j = 1:cm_len
    accuracy = find(yTest == j);
    
    for l = 1:cm_len
      prediction = find(yTestP == l);
      confusion_matrix(j, l) = sum(ismember(accuracy, prediction'));
    endfor
  endfor
  
  disp(confusion_matrix);
endfor
  
Err_by_K = [K_part2_2' Err_part2_2']
  