set(0, 'defaultLineLineWidth', 1.5)

a = -1;
b = 1;

to01 = @(x) (b - a)*x + a; % function that maps [a, b] to [0, 1]
from01 = @(x) (x - a)/(b - a); % function that maps [0, 1] to [a, b]

f = @(x) (exp(x));
der0 = approximate(@(x) f(to01(x)), 5);
der1 = 1/(b-a)^1 * polyder(der0);
der2 = 1/(b-a)^2 * polyder(der1);
der3 = 1/(b-a)^3 * polyder(der2);

x = -1:0.01:1;
y = f(x);
a1 = polyval(der0, from01(x));
a2 = polyval(der1, from01(x));
a3 = polyval(der2, from01(x));
a4 = polyval(der3, from01(x));
% plot(x, y, x, a1, x, a2, x, a3, x, a4);
% legend('actual', 'k=0', 'k=1', 'k=2', 'k=3')
% grid on
% grid minor
% pause

x = linspace(-1, 1, 200);
tres = 0.3;
err = ones(1, 4);
for k = 0:3
  n = 1;
  while err(k+1) > 0.3 && n < 40
    appr = approximate(@(x) f(to01(x)), n);
    for j = 1:k
      appr = 1/(b-a) * polyder(appr);
    end
    vals = polyval(appr, from01(x));
    newerr = max(abs(f(x) - vals));
    alfa(k+1) = log(newerr/err(k+1))/log((n+1)/n);
    fprintf('alfa_%d = %f\n', k, alfa(k+1));
    err(k+1) = newerr;
%      fprintf('error_%d (iter. %d) = %f\n', k, n, newerr);
%      plot(x, f(x), x, vals);
%      grid on
%      pause
    n = n+1;
  end
  if (n == 40)
    fprintf('Iteration diverges for k = %d!\n', k);
  else
    fprintf('For k = %d the first n = %d\n', k, n);
  end
end

% vim: set ft=matlab:
