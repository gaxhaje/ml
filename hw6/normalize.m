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