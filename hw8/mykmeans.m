function o = mykmeans (data, centers)
  
  for i = 1:50
    dist = pdist2 (data, centers);
    [minVal idx] = min(dist');
    class = idx';
    
    for j = 1:size(centers,1)
      idxClass = find(class == j);
      centers(j,:) = mean(data(idxClass,:));
    endfor
     
    dist = pdist2 (data, centers);
    [minVal idx] = min(dist');
    
    obj(i) = sum(minVal);
    all_class(i,:)=idx'
  endfor
  
  
  [obj2 ind] = min(obj);
  cls = all_class(ind,:)
  o = obj2;
endfunction