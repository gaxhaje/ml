# initialize matrices
data = load('./hw2_data1.txt');
X = data(:, [1,2]);
y = data(:,3);
x1 = X(:,1);        # exam 1 scores
x2 = X(:,2);        # exam 2 scores
m  = length(y);     # length of data
theta0=0;
theta1=0;  
theta2=0;
alpha=0.00001;      # learning rate

# b) logistic regression                      
for i = 1:500000
  thetatx = theta1*x1 + theta2*x2 + theta0;
  p = exp(-1*thetatx);
  t = 1./ (1+p);
  
  # store thatas in temp variables
  temp1 = theta1 - alpha*sum((t - y).*x1);
  temp2 = theta2 - alpha*sum((t - y).*x2);
  temp3 = theta0 - alpha*sum(t - y);
  
  # update theta variables
  theta1 = temp1;
  theta2 = temp2;
  theta0 = temp3;
  
  # calculate t again based on new thata values
  t = 1./ (1 + p);
  
  # objective
  obj = -1 * sum(y.* log(t) + (1 - y).* log(1 - t));
  OBJ(i) = obj; # store so we can compare new to old and break if < then alpha.
  
  # break for loop if objective is less then alpha.
  if (i > 1 && abs(OBJ(i-1)-obj) < alpha)
    break;
  endif
end

figure 1;
hold on;
plot(OBJ);
hold off;

# a) Visualize the data
pos = find(y==1); # accepted score indices
neg = find(y==0); # not accepted score indices

figure 2;
hold on;
plot(X(pos,1),X(pos,2),'b+','linewidth',1);
plot(X(neg,1),X(neg,2),'ro','linewidth',1);
xlabel('Exam score 1');
ylabel('Exam score 2');
legend('y = 1', 'y = 0');

# c) final parameters theta1, theta2
theta1
theta2

yy = (-1/theta2)*(theta1*x1+theta0);  # gradient discent algorithm. x2 = (1/theta2)(-theta1 * x1 - theta0)
plot(x1,yy,'g-');
hold off;