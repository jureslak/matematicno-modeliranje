format long
% PROBLEM
p.a = 0;
p.b = 5;
p.p = 3;
p.q = 7;
p.f0 = 1;
p.f1 = -4;  % Enacba: -(pu')' + qu = f0 + f1 x
p.levi = -2;  % robna pogoja
p.desni = 3;

% NUMERIKA
n.n = 10;
n.h = (p.b-p.a) / n.n;

for i = 1:5
    n.n = 10*i;
    n.h = (p.b-p.a) / n.n;

    alfa = solve_fem(p, n);
    hold on
    x = p.a:n.h:p.b;
    plot(x, alfa)
end


% HATS
hats = make_hats(p, n);
point = pi;  % lahko tudi vektor
value = get_value(alfa, hats, point)

tocna = @(x) ...
  (1/7).*((-1)+exp(1).^(10.*(7/3).^(1/2))).^(-1).*((-1)+(-15).*exp( ...
  1).^((-1).*(7/3).^(1/2).*((-10)+x))+(-40).*exp(1).^((-1).*(7/3).^( ...
  1/2).*((-5)+x))+15.*exp(1).^((7/3).^(1/2).*x)+40.*exp(1).^((7/3) ...
  .^(1/2).*(5+x))+exp(1).^(10.*(7/3).^(1/2)).*(1+(-4).*x)+4.*x);

xx = p.a:0.001:p.b;
plot(xx, tocna(xx))
legend('n = 10', 'n = 20', 'n = 30', 'n = 40', 'n = 50', 'exact')
hold off
