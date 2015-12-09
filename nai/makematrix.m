function V = makematrix(E)
  % construct a matrix for a step of remez procedure
  V = fliplr(vander(E));
  first = ones(length(E), 1);
  first(1:2:length(E)) = -1;
  V = [first V(:, 1:(length(E)-1))];
end