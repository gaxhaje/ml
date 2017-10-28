function str_label = num2str4label(num_label, u_label)
  for i = 1:size(num_label, 1)
    number = num_label(i);
    str_label(i) = u_label(number);
  endfor
endfunction