function sol = AdamsBashSistem(f, a, b, y0, h)
% Returns a solution to a system of differential equations
% using 4 step AB method with initial values computed with RK4.
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

% B = [1];
% B = [3/2 -1/2];
% B = [23/12 -4/3 5/12];
B = [55/24 -59/24 37/24 -3/8];
%B = [1901/720 -1387/360 109/30 -637/360 251/720];
%      f_{n+4}   f_{n+3}
B = fliplr(B);
if abs(sum(B)-1) > eps, error('You messed up the AB method coefficients, they don''t sum to 1: %s, sum = %f.', mat2str(B), sum(B)), end

for i = 5:N
    y = y + h*f(sol(1, i-4:i-1), sol(2:end, i-4:i-1))*B';
    x = x + h;
    sol(:, i) = [x; y];
end

end
