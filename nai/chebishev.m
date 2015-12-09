function p = chebishev(n)
  % returns n-th chebishev polynomial
  if n == 0, p = 1; return
  elseif n == 1, p = [1, 0]; return
  end
  
  pp = 1;
  p = [1, 0];
  for i = 2:n
    tmp = 2 * [p 0] - [0 0 pp];
    pp = p;
    p = tmp;
  end
end