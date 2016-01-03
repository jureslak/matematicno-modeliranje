function s = skal(fx, gx)
  % return our dot product of f and g (row vectors)
  left = -1;
  right = 1;
  x = linspace(left, right, 11);
  l = x.*fx;
  r = x.*gx;
  s = l*r'/5;
end