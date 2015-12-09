function appr = approximate(f, n)
% returns bernstein polynomial approximation for f
  appr = zeros(1, n+1);
  for i = 0:n
    appr = appr + f(i/n) * bernstein(n, i);
  end
end
