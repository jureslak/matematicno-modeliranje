function [f] = make_hat(a, b, c)
% returns a hat function with peak in b
if (~(a <= b && b <= c))
    error('Order the points, got a = %.2f, b = %.2f, c = %.2f',...
          a, b, c);
end
if a == c, f = @(x) x == b; return, end
if a == b
    f = @(x) (c-x)/(c-b) .* (b < x & x < c) + (x == b);
    return
end
if b == c
    f = @(x) (x-a)/(b-a) .* (a < x & x < b) + (x == b);
    return
end
f = @(x) (x-a)/(b-a) .* (a < x & x < b) + ...
         (c-x)/(c-b) .* (b < x & x < c) + ...
         (x == b);
end

