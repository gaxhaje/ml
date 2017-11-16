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