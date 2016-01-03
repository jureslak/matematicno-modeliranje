set(0, 'defaultLineLineWidth', 1.5)

left = -1;
right = 1;

f = @(x) (exp(-x).*sin(4*x));
E = linspace(-1, 1, 6)';
%  f = @(x) (abs(x));
%  E = [-2/3; -1/3; 1/3; 2/3];
%  f = @(x) (exp(x));
%  E = [0, 1/2, 1]';

while 1
  V = makematrix(E);
  coef = V \ f(E);

  m = coef(1);
  pol = fliplr(coef(2:end)');
  r = @(x) (f(x) - polyval(pol, x));

  %    xx = left:0.01:right;
  %    yy = r(xx);
  %    plot(xx, yy, 'LineWidth', 1.5, xx, m*ones(1, length(xx)), xx, -m*ones(1, length(xx)), ...
  %         E, zeros(1, length(E)), 'bo', 'MarkerFaceColor', 'black')
  %    grid on
  %    grid minor
  %    pause

  %  [ext, val] = fminbnd(@(x) (-r(x)), left, right)
  %  [ext, val] = fminbnd(@(x) (r(x)), left, right)

  xx = left:0.001:right;
  [val, idx] = max(abs(r(xx)));

  if val - m < 1e-10
    break
  end

  %    disp('Adding point');
  %    E
  y = xx(idx(1)); % extra point (x-coordinate) to add,
  ry = r(y); % val is the value
  %    r(E)
  if y >= E(end)
    if sign(ry) == sign(r(E(end)))
      E(end) = y; % enaka predznaka, ven vrzem E(end)
    else
      E = [E(2:end), y]; % razlicna predznaka, ven vrzem E(1)
    end
  elseif y <= E(1)
    if sign(ry) == sign(r(E(1)))
      E(1) = y; % enaka predznaka, ven vrzem E(1)
    else
      E = [y, E(1:(end-1))];  % razlicna predznaka, ven vrzem E(end)
    end
  else
    k = 1;
    while y >= E(k), k = k + 1; end
    % torej je y na [E(k-1), E(k)]
    if sign(ry) == sign(r(E(k-1)))
      E(k-1) = y; % y in E(k-1) imata enak predznak, torej moram E(k-1) vreci ven
    else
      E(k) = y; % y in E(k) imata enak predznak, E(k) vrzem ven
    end
  end
  %    E
  %    r(E)
  %
  %    xx = left:0.01:right;
  %    yy = r(xx);
  %    plot(xx, yy, 'LineWidth', 1.5, xx, m*ones(1, length(xx)), xx, -m*ones(1, length(xx)), ...
  %         E, zeros(1, length(E)), 'bo', 'MarkerFaceColor', 'black')
  %    grid on
  %    grid minor
  %    pause
end
enakpol = pol

razvojpol = razvoj(enakpol)
chebpol = enakpol - razvojpol(1)*chebishev(length(enakpol)-1);
chebpol = chebpol(2:end);

x = left:0.001:right;
remeznorm = max(abs(f(x) - polyval(enakpol, x)));
chebnorm = max(abs(f(x) - polyval(chebpol, x)));
fprintf('|f-p| = %f\n', remeznorm);
fprintf('|f-q| = %f\n', chebnorm);

plot(xx, f(xx), xx, polyval(enakpol, xx), xx, polyval(chebpol, xx));
grid on
legend('f', 'remes', 'cheb')

% vim: set ft=matlab:
