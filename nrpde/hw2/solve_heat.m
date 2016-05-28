function [u] = solve_heat(pr, nu)
% function that solves the heat equation given model parameters
% and numeric parameters

if nargin < 2, error('Supply at least 2 arguments!'), end

dt = nu.lambda * nu.dx^2 / pr.kappa;
J = ceil((pr.xb-pr.xa) / nu.dx);
N = ceil((pr.tb-pr.ta) / dt);

xx = pr.xa:nu.dx:pr.xb; % all nodes
xint = xx(2:end-1); % interor nodes

M = make_matrix(J, nu.theta, nu.lambda);
u =  pr.f(xint);  % začetni u
%plot(xx, pr.f(xx))
%axis([0, 3, -4, 2])
%pause
for t = 0:N-1
   rhs = make_rhs(J, nu.theta, nu.lambda, pr.levi, pr.desni, ...
                  u, pr.ta+t*dt, dt);
   u = M \ rhs;
   %time = pr.ta+(t+1)*dt;
   %plot(xx, [pr.levi(time), u', pr.desni(time)])
   %axis([0, 3, -4, 2])
   %fprintf('u at time = %.4f s\n', time);
   %pause
end

end