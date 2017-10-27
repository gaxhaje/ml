# read the training data
D = dlmread('/home/ergels/Downloads/linear-regression.train.csv');

# initialize matracies and variables
x = D(:, 1); 
y = D(:, 2);          # results matrix
m = length(y);        # no. of training examples
theta = zeros(2, 1);  # initialize
theta0=1;             # variable 1 of 2 of linear regression
theta1=1;             # variable 2 of 2 of linear regression
alpha=0.01;           # learning rate
tolerance=0.001;      # change in objectives from one iteration to next 
                      # stop the loop if less then.

for i = 1 : 100
  t=theta1*x + theta0 - y;
  temp0 = theta0 - alpha*(1/m)*sum(t);
  temp1 = theta1 - alpha*(1/m)*sum(t.*x);
  theta0 = temp0;
  theta1 = temp1;
  theta(1) = theta0;
  theta(2) = theta1; 
  t=theta1*x + theta0 - y;
  e=(1/2*m)*t'*t;
  Err(i)=e;
  if (i > 1 && abs(Err(i-1)-e) < 0.001) 
    break;
  endif
end

hold on;
plot(x, y, 'o');
z=[ones(m,1), x(:, 1)]; # make (n x m) matrix so we can multiply with theta (m x n)
plot(x, z*theta,'-');
hold off;