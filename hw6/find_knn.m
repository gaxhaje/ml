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
yTest = str2num4label(y2, yTestUnique)   # get the unique vector number for each string label
