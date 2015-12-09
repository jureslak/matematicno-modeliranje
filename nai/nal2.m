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

  if (abs(max(r(E)) - val) < 1e-10)
    break
  end

%    disp('Adding point');
%    E
  extx = xx(idx(1));
  val = r(extx);
%    r(E)
  idx1 = find(E < extx);
  if isempty(idx1)
    E(1) = extx;
  else
    idx1 = idx1(end);
    idx2 = min(length(E), idx1+1);
    if sign(val) == sign(r(E(idx1)))
      E(idx1) = extx;
    else
      E(idx2) = extx;
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