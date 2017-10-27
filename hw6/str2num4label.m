function num_label = str2num4label(str_label, u_label)
  len = size(str_label, 1);
  num_label = zeros(len, 1);
  
  for i = 1:len
    label = str_label(i){1};
    num_label(i) = find(strcmp(u_label, label));
  endfor
  
  return;
endfunction