# initialize matricies and variables
A = [2 1; 1 20; 1 5; 4 1; 1 40; 3 30];
y = [0; 0; 0; 1; 1; 1];
x1= A(:,1);
x2= A(:,2);
m = length(y);        # no. of training examples
theta=zeros(2, 1);  # initialize
theta0=0
theta1=0;             # variable 1 of 2 of linear regression
theta2=0;             # variable 2 of 2 of linear regression
alpha=0.0001;         # learning rate
tolerance=0.001;      # change in objectives from one iteration to next 
                      # stop the loop if less then.

for i = 1 : 30000
  # local variables
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
  
  # store thatas
  theta(1) = theta1;
  theta(2) = theta2; 
  
  # calculate t again based on new thata values
  t = 1./ (1 + p);
  
  # objective
  obj = -1 * sum(y.* log(t) + (1 - y).* log(1 - t));
  
  OBJ(i) = obj;
  #if (i > 1 && abs(Err(i-1)-e) < 0.001) 
  #  break;
  #endif
end

hold on;
plot(A(1:3,1),A(1:3,2),'rx',A(4:6,1),A(4:6,2),'bo','linewidth',2);
yy = (-1/theta2)*(theta1*x1+theta0);  # gradient discent algorithm. x2 = (1/theta2)(-theta1 * x1 - theta0)
plot(x1,yy,'g-');
hold off;


# evaluate probobility of class 0 and class 1.
#D = [4, 40; 1 8; 2 16];
#for i = 1 : 3
#  thetatxx = theta1*x1 + theta2*x2 + theta0;
#  p = exp(-1*thetatx);
#  t = 1./ (1+p);
#end
#t