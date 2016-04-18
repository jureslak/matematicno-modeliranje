format compact
format long
% pravokotnik [ax, bx] * [ay, by]
ax = -1; 
bx = 1;
ay = -1;
by = 1;

% diskretizacija
h = 0.2;
dx = h;
dy = h;
J = (bx-ax)/dx - 1;  % spremenljivke u_jk za j = 1...J, k = 1...K
K = (by-ay)/dy - 1;

% enacba in robni pogoji
f = @(x, y) - sin(x) .* cos(y);
up = @(x) x.*x; % u(x, 1) = x^2
down = @(x) x; % u(x, -1) = x
left = @(y) y; % u(-1, y) = y
right = @(y) 1; % u(-1, y) = y

% shema za laplaceov operator iz zapiskov
shema = [    
    [ 1/dx^2, -1, 0];
    [-2/dx^2,  0, 0];
    [ 1/dx^2,  1, 0];
    
    [ 1/dy^2, 0,  1];
    [-2/dy^2, 0,  0];
    [ 1/dy^2, 0, -1];
];

n = J*K;
M = sparse(n, n);
bb = zeros(n, 1);  % b je rezerviran za kviz
tic
disp('building system...')
for k = 1:K
    for j = 1:J
        % za vsako spremenljivko imamo enačbo
        % shema(x, y) = f(x, y)
        x = ax + j*dx;
        y = ay + k*dy;
        %fprintf('x: %g, y: %g\n', x, y);
        idx = make_index(j, k, J);
        for s = shema'
            mul = s(1);
            jidx = j+s(2);
            kidx = k+s(3);
            xoff = ax + jidx * dx;
            yoff = ay + kidx * dy;
            % fprintf('col: %d, row: %d\n', colidx, rowidx);
            
            % robni pogoji, nesemo na drugo stran enakosti
            if jidx == 0,   bb(idx) = bb(idx) - mul * left(yoff);  end % u(-1, y)
            if jidx == J+1, bb(idx) = bb(idx) - mul * right(yoff); end % u(1, y)
            if kidx == 0,   bb(idx) = bb(idx) - mul * down(xoff);  end  % u(x, -1)
            if kidx == K+1, bb(idx) = bb(idx) - mul * up(xoff);    end % u(x, 1)
            
            if 1 <= jidx && jidx <= J && 1 <= kidx && kidx <= K
                varidx = make_index(jidx, kidx, J, K);  % dejanska enačba
                M(idx, varidx) = M(idx, varidx) + mul;
            end
        end
        bb(idx) = bb(idx) + f(x, y);
    end
    %fprintf('%.2f%%\r', k/K*100)
end
toc
% full(M)
% b

fprintf('Direktna metoda:\n')
tic
sol_direct = M \ bb;
toc

fprintf('Jacobi:\n')
tic
[sol_jac, iter] = jacobi(M, bb, 1e-5);
iter_jac = iter
directdiff_jac = norm(sol_jac - sol_direct)
toc

fprintf('Gauss Seidel:\n')
tic
[sol_gs, iter] = gauss_seidel(M, bb, 1e-5);
iter_gs = iter
directdiff_gs = norm(sol_gs - sol_direct)
toc

fprintf('SOR:\n')
tic
delta = dx^2 * dy^2 / (2 *(dx^2 + dy^2));
r = 1 - delta^2 * pi^2 * (1/(bx-ax)^2 + 1/(by-ay)^2);
omega = 2 / (1 + sqrt(1 - r^2));
[sol_sor, iter] = sor(M, bb, 1e-5, zeros(length(bb),1), omega);
iter_sor = iter
directdiff_sor = norm(sol_sor - sol_direct)
toc

% plot
SOL = zeros(J+2, K+2);
SOL(2:end-1, 2:end-1) = reshape(sol_direct, [J, K]);

% dostopaj kot SOL(x_j, y_k)
for j = 0:J+1
    x = ax + j*dx;
    SOL(j+1, 1) = down(x);
    SOL(j+1, end) = up(x);   
end
for k = 0:K+1
    y = ay + k*dy;
    SOL(1, k+1) = left(y);
    SOL(end, k+1) = right(y);
end

x = (ax):dx:(bx); 
y = (ay):dy:(by);
[X, Y] = meshgrid(x, y);
surf(X, Y, SOL)
SOL;

% check -- calculate back
LAP = zeros(J, K);
for j = 2:J+1
    for k = 2:K+1
        LAP(j-1, k-1) = (SOL(j-1, k) + SOL(j+1, k) - 2*SOL(j, k))/dx^2 + ...
                        (SOL(j, k-1) + SOL(j, k+1) - 2*SOL(j, k))/dy^2;
    end
end

x = (ax+dx):dx:(bx-dy); 
y = (ay+dy):dy:(by-dy);
[X, Y] = meshgrid(x, y);
truelap = f(X, Y);
error = max(max(abs(LAP' - truelap)))
% surf(X, Y, LAP)