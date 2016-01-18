function Z = evaluate2d(basis, X, Y, A)
% evaluate 2d intepolation polynomial
  if any(size(X) ~= size(X))
      error('Dimensions of X and Y must match!');
  end
  Z = zeros(size(X));
  [m, n] = size(A);
  for i = 1:m
      for j = 1:n
          Z = Z + A(i, j) .* basis.evaluate_kth_basis(j, X)...
                          .* basis.evaluate_kth_basis(i, Y);
      end
  end     
end