% Solve 3rd task
% Find a zero of the function given implicitly by an ODE
% using Newton's method.

p.f = @(x, y) [y(2,:); -x.*y(1,:)];
p.a = 0;
p.b = 10;
p.y0 = [1; 0];
p.h = 0.01;

make_RK4;
sol = RK4.solve(p.f, p.a, p.b, p.y0, p.h);
x = sol(1,:);
y = sol(2,:);

% Newtons method
x0 = 7.5;  % priblizek iz slike
y0 = p.y0;
maxsteps = 50;
delta = eps;

xp = 0;  % previous, just to know the step size and direction 
xn = x0;
x0 = Inf;
korak = 0;                    						 
while (abs(xn-x0)>delta*abs(xn)) && (korak<maxsteps)
    korak=korak+1;           						    
    x0 = xn;
    sol = RK4.solve(p.f, xp, x0, y0, p.h*sign(x0-xp));
    xp = x0;
    y0 = sol(2:end, end);
    xn = x0 - y0(1)/y0(2);
    fprintf('korak: %d, priblizek: %15.15f\n', korak, xn);
end
if korak == maxsteps, warning('Did not converge after %d iterations.', maxsteps), end

fprintf('Nicla: %.16f.\n', xn);

plot(x, y, x, zeros(size(x)), xn, 0, 'ko')