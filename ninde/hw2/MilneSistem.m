function sol = MilneSistem(f, a, b, y0, h)
% Returns a solution to a system of differential equations
% using Milne method with initial values computed with RK4.
if (nargin < 4), error('Supply all arguments.'), end

if ((b-a)*h < 0), error('Value of a+h does not go towards b. a = %g, b = %g, h = %g.', a, b, h), end
if (~isvector(y0)), error('y0 is not a vector.'), end
if (~iscolumn(y0)), y0 = y0'; end
sfx = size(f(a, y0));
sy = size(y0);
d = sy(1);
if (sfx(1) ~= d || sfx(2) > 1), error('Expected f to be a vector function of dimension %d, but got %s.', d, mat2str(sfx)), end

% initial values with RK4
make_RK4;
N = ceil((b-a)/h) + 1;
sol = zeros(d+1, N);
sol(:, 1) = [a; y0];
x = a;
y = y0;
for i = 2:4
    y = RK4.getnext(f, x, y, h);
    x = x + h;
    sol(:, i) = [x ; y];
end 

% Milne method
F = f(sol(1, 1:4), sol(2:end, 1:4));
for i = 5:N
    yp = sol(2:end, i-4) + 4*h/3*(F(:, 2:4)*[2, -1, 2]');
    y = sol(2:end, i-2) + h/3*([F(:, 3:4) f(x+h, yp)]*[1, 4, 1]');
    F = [F(:,2:4) f(x+h, y)];
    x = x + h;
    sol(:, i) = [x; y];
end

end