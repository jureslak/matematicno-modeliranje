function [hats] = make_hats(p, n)
% returns hat functions for given discretizaiton
hats = cell(n.n+1, 1);
hats{1}    = make_hat(p.a, p.a, p.a + n.h);
hats{n.n+1} = make_hat(p.b - n.h, p.b, p.b);
for i = 1:n.n-1
    hats{i+1} = make_hat(p.a + (i-1)*n.h, p.a + i*n.h, p.a + (i+1)*n.h);
end

end

