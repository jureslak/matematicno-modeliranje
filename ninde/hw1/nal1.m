% Implementacija prve naloge, računanje dvakratnega integrala.
% Jure Slak, 27152005
% Vse damo v "namespace" p, ker so na kvizu a, b, c, d zasedene
p.f = @(x, y) exp(x+y);
p.a = -1;  %  d +---------+
p.b = 2;   %  m |         |
p.c = 1;   %  c +---------+
p.d = 3;   %    a    n    b
p.n = 7;
p.m = 6;

% enojni integrali
Ix = @(y) arrayfun(@(z) trapezoid(@(x) p.f(x, z), p.a, p.b, p.n), y);
Iy = @(x) arrayfun(@(z) simpson(@(y) p.f(z, y), p.c, p.d, p.m), x);
% dvojni integral lahko izračunamo na dva načina
I1 = trapezoid(Iy, p.a, p.b, p.n);
I2 = simpson(Ix, p.c, p.d, p.m);

if (abs(I1 - I2) > 1e-9) 
    warning('Order of integrals matters by %g!', abs(I1 - I2))
end
% točen rezultat je 1 - e^2 - e^3 + e^5
fprintf('Zunanji po x: %.16f\n', I1)
fprintf('Zunanji po y: %.16f\n', I2)
fprintf('Točen:        %.16f\n', 1 - exp(2) - exp(3) + exp(5))
