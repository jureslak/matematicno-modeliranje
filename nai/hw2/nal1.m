clear
set(0, 'defaultLineLineWidth', 1.5)

xf = @(t) cos(2*pi*t);
yf = @(t) sin(2*pi*t);
f = @(t) [xf(t); yf(t)];

m = 10;
% appr = cell(m, 2);
% for k = 1:m
%     n = 3*k;
%     T = 0:(1/n):1;
%     L = LagrangeBasis(T);
%     px = L.interpolate_standard(xf(T));
%     py = L.interpolate_standard(yf(T));
%     appr{k, 1} = px;
%     appr{k, 2} = py;
% end

% apppr je zelo nestabilen
% raje direktno racunamo vrednosti

% colours
c = {[1 0.7 0],[0 0 0],[0 0 1],[0 1 0],[0 1 1],[1 0 0],[1 0 1],...
     [0.9412 0.4706 0],[0.251 0 0.502],[0.502 0.251 0],[0 0.251 0],...
     [0.502 0.502 0.502],[0.502 0.502 1],[0 0.502 0.502],[0.502 0 0],...
     [1 0.502 0.502]};

leg = cell(10, 1);

hold on
razmerje = zeros(m);
for k = 1:m
    n = 3*k;
    T = 0:(1/n):1;
    L = LagrangeBasis(T);
    ax = L.interpolate(xf(T));
    ay = L.interpolate(yf(T));
    
    t = 0:0.005:1;
    x = L.evaluate(ax, t);
    y = L.evaluate(ay, t);
    
    d = sqrt(x.^2 + y.^2);
    razmerje(k) = max(d) / min(d);
    
    plot(x, y, 'color', c{k})
    leg{k} = sprintf('k = %d', k);
end
legend('k = 1','k = 2','k = 3','k = 4','k = 5','k = 6','k = 7','k = 8',...
             'k = 9','k = 10')
hold off

for i = 1:m
    fprintf('Razmerje pri n = %d: %.16f\n', 3*i, razmerje(i))
end

% vim: set ft=matlab:
