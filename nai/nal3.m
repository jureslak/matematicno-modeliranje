set(0, 'defaultLineLineWidth', 1.5)

left = -1;
right = 1;
x = linspace(left, right, 11);

n = 7;
enke = ones(1, length(x));
Q = cell(n, 1);
Q{1} = [];
Q{2} = 1 / sqrt(skal(enke, enke));
alfas = zeros(n, 1);
betas = alfas;
alfas(2) = skal(enke, x);
betas(2) = 1 / Q{2};
for i = 3:n
  Q{i} = conv([1, -alfas(i-1)], Q{i-1}) - [0 0 betas(i-1)*Q{i-2}];
  betas(i) = sqrt(skal(polyval(Q{i}, x), polyval(Q{i}, x)));
  Q{i}  = Q{i} / betas(i);
  alfas(i) = skal(x.*polyval(Q{i}, x), polyval(Q{i}, x));
end

Q
alfas
betas

G = zeros(n-1, n-1);
for i = 1:n-1
  for j = 1:n-1
    G(i, j) = skal(polyval(Q{i+1}, x), polyval(Q{j+1}, x));
  end
end
fprintf('Gramova matrika: \n')
G

f = @(x) x .* cos(x);
coef = zeros(1, n);
pol = [];
for i = 1:n
  coef(i) = skal(polyval(Q{i}, x), f(x));
  pol = [0 pol] + coef(i) * Q{i};
end
pol

%  hold on
%  xx = left:0.01:right;
%  for i = 1:n-1
%    plot(xx, polyval(Q{i+1}, xx));
%  end
%  grid on
%  hold off
%  pause

napaka = abs(f(0) - pol(end))

xx = left:0.01:right;
plot(xx, f(xx), xx, polyval(pol, xx));
grid on
legend('f', 'pol');
pause

% vim: set ft=matlab:
