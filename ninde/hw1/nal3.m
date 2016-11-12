% Implementacija tretje naloge, računanje integralov po monte carlo
% Jure Slak, 27152005
p.n = 10.^[2, 3, 4, 5, 6];
p.f = @(x) 1 / (3 * x(1) + x(2) + 9 * x(3) + 1);
p.a = [0, 0, 0];
p.b = [1, 1, 1];

tocno = 1 / 54 * (332 * log(2) + 75 * log(5) + 196 * log(7) - 121 * log(11) - 169 * log(13));
fprintf('Točen:           I = %.16f\n', tocno);
for n = p.n
    I = montecarlo(p.f, p.a, p.b, n);
    fprintf('Pri n = %7d, I = %.16f, err = %.16f\n', n, I, abs(I-tocno));
end