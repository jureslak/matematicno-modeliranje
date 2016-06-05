format long
% PROBLEM
p.ta = 0;  % casovni interval [ta, tb]
p.tb = 1;
p.xa = 0;  % interval [xa, xb]
p.xb = 3;
p.f = @(x) x .* cos(pi/2*x); % zacetni pogoj
p.levi = @(t) t.^2;          % levi robni pogoj
p.desni = @(t) -t;           % desni robni pogoj
p.kappa = 1/4; % specificna toplotna prevodnost u_t = kappa lap(u)
 
% NUMERIKA
n.dx = 1/10;
n.lambda = 1/2;                   % lam = kappa dt / dx^2
n.theta = 1/2;

xx = p.xa+n.dx : n.dx : p.xb-n.dx;

% EXPLICIT
n.theta = 0;
ue = solve_heat(p, n);
fprintf('Done explicit\n');

% IMPLICIT
n.theta = 1;
ui = solve_heat(p, n);
fprintf('Done implicit\n');

% CRANK NICOLSON
n.theta = 1/2;
uc = solve_heat(p, n);
fprintf('Done CN\n');

% PRECISE CN
n.dx = 1/100;
n.theta = 1/2;
usol = solve_heat(p, n);
fprintf('Done precise\n');

xfine = p.xa+n.dx : n.dx : p.xb-n.dx;
plot(xx, ue', xx, ui', xx, uc', xfine, usol)
axis([0, 3, -2, 1])
legend('exp', 'imp', 'cn', 'fine')

point = 1;
idx =  round((point - p.xa) / n.dx);
if ~(1 <= idx && idx <= length(usol)), error('Point out of range'), end
fprintf('u(%.2f) = %.6f\n', p.xa+idx*n.dx, usol(idx))
