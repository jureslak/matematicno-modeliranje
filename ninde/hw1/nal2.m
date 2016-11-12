% Implementacija druge naloge, adaptivni simpson
% Jure Slak, 27152005
p.f = @(x) 1 ./ sqrt(x + 10^-6);
p.a = 0;
p.b = 1;
p.delta = 0.001;

I = adapt(p.f, p.a, p.b, p.delta);
tocna = 1/500 * (sqrt(1000001) - 1);
fprintf('I =    %.16f\n', I);
fprintf('Točen: %.16f\n', tocna);