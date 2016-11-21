f = @(x) exp(sin(x));
Df = @(x) exp(sin(x)) * cos(x);
DDf = @(x) exp(sin(x)) * ( (cos(x))^2 - sin(x) );
x1 = 0.2;
delta = 10^(-6);
tocna1 = Df(x1);
tocna2 = DDf(x1);

fprintf('Tocen rezultat za prvi odvod: %.16f\n', tocna1);
fprintf('Tocen rezultat za drugi odvod: %.16f\n', tocna2);
fprintf('----------\n');

for i=1:6
    h = 10^(-i);
    fprintf('h = %.6f\n', h);
    [D, DD] = symdifference(f, x1, h);
    err1 = abs(D-tocna1);
    fprintf('Priblizek prvega odvoda pri h = %.6f: %.16f\n', h, D);
    fprintf('Napaka prvega odvoda pri h = %.6f: %.16f\n', h, err1);
    if err1 <= delta
        fprintf('Priblizek prvega odvoda se razlikuje za manj kot %.6f.\n', delta);
    end
    err2 = abs(DD-tocna2);
    fprintf('Priblizek drugega odvoda pri h = %.6f: %.16f\n', h, DD);
    fprintf('Napaka drugega odvoda pri h = %.6f: %.16f\n', h, err2);
    if err2 <= delta
        fprintf('Priblizek drugega odvoda se razlikuje za manj kot %.6f.\n', delta);
    end
    fprintf('----------\n');
end