D=dlmread ('/home/ergels/Downloads/linear-regression.train.csv');
x=D(:,1);
y=D(:,2);
theta0=1;
theta1=1;
alpha=0.01;
m=length(y);
tolerance=0.001;

for i=1:100
  t=theta1*x + theta0 - y;
  temp0 = theta0 - alpha*(1/m)*sum(t);
  temp1 = theta1 - alpha*(1/m)*sum(t.*x);
  theta0 = temp0;
  theta1 = temp1;
  t=theta1*x + theta0 - y;
  e=(1/2*m)*t'*t;
  Err(i)=e;
  if (i > 1 && abs(Err(i-1)-e) < 0.001) 
    break;
  endif
end

theta=[theta0 theta1];
hold on;
plot(D,'o');
plot(x,x*theta,'-');
hold off;
#Err
#plot(Err);
#plot(D, 'o');