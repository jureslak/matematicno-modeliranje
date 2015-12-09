function bern = bernstein(n, i)
% returns berstein polynomial B_i^n
  bern = 1;
  for j = 1:n-i
    bern = conv(bern, [-1, 1]);
  end
  bern = [bern zeros(1, i)];
  bern = bern * nchoosek(n, i);
end