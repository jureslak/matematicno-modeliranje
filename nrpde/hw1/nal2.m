format compact
format long
% pravokotnik [ax, bx] * [ay, by]
ax = -1;
bx = 1;
ay = -1;
by = 1;

% diskretizacija
h = 0.02;
dx = h;
dy = h;
J = (bx-ax)/dx - 1;  % spremenljivke u_jk za j = 1...J, k = 1...K
K = (by-ay)/dy - 1;
if floor(J) ~= J, error('Discretization step in x direction does not divide interval length.'), end
if floor(K) ~= K, error('Discretization step in y direction does not divide interval length.'), end

% enacba in robni pogoji
f = @(x, y) - sin(x) .* cos(y);
up = @(x) x.*x; % u(x, 1) = x^2
down = @(x) x; % u(x, -1) = x
left = @(y) y; % u(-1, y) = y
right = @(y) ones(size(y)); % u(-1, y) = 1

% check boundary conditions for consistency
if abs(down(ax) - left(ay)) > eps
    error(['Down left corner boundary conditions are inconsistent, \n'...
           'point = (%g, %g)\n'...
           'value on down border = %.6f\n'...
           'value on left border = %.6f'],...
          ax, ay, up(ax), left(ay))
end
if abs(down(bx) - right(ay)) > eps
    error(['Down right corner boundary conditions are inconsistent, \n'...
           'point = (%g, %g)\n'...
           'value on down border = %.6f\n'...
           'value on right border = %.6f'],...
          bx, ay, up(bx), left(ay))
end
if abs(up(ax) - left(by)) > eps
    error(['Upper left corner boundary conditions are inconsistent, \n'...
           'point = (%g, %g)\n'...
           'value on up border = %.6f\n'...
           'value on left border = %.6f'],...
          ax, by, up(ax), left(by))
end
if abs(up(bx) - right(by)) > eps
    error(['Upper right corner boundary conditions are inconsistent, \n'...
           'point = (%g, %g)\n'...
           'value on up border = %.6f\n'...
           'value on right border = %.6f'],...
          bx, by, up(bx), right(by))
end

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
% po vrsticah
% u_31 u_32 u_33       u_7 u_8 u_9
% u_21 u_22 u_23  ===  u_4 u_5 u_6
% u_11 u_12 u_13       u_1 u_2 u_3
for k = 1:K
    for j = 1:J
        % za vsako spremenljivko imamo enačbo
        % shema(x, y) = f(x, y)
        x = ax + j*dx;
        y = ay + k*dy;
        % fprintf('x: %g, y: %g\n', x, y);
        idx = make_index(j, k, J);
        % fprintf('u_jk == u_%d,%d == u_%d at (%.2f %.2f)\n', j, k, idx, x, y);
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
            if kidx == 0,   bb(idx) = bb(idx) - mul * down(xoff);  end % u(x, -1)
            if kidx == K+1, bb(idx) = bb(idx) - mul * up(xoff);    end % u(x, 1)

            if 1 <= jidx && jidx <= J && 1 <= kidx && kidx <= K
                varidx = make_index(jidx, kidx, J, K);  % dejanska enacba
                M(idx, varidx) = M(idx, varidx) + mul;
            end
        end
        bb(idx) = bb(idx) + f(x, y);
    end
    %fprintf('%.2f%%\r', k/K*100)
end
toc
% full(M)
% bb

fprintf('## Direktna metoda:\n')
tic
sol_direct = M \ bb;
time_direct = toc

fprintf('## Jacobi:\n')
tic
format long
[sol_jac, iter] = jacobi(M, bb, 1e-5);
iter_jac = iter
directdiff_jac = norm(sol_jac - sol_direct)
time_jac = toc

fprintf('## Gauss Seidel:\n')
tic
[sol_gs, iter] = gauss_seidel(M, bb, 1e-5);
iter_gs = iter
directdiff_gs = norm(sol_gs - sol_direct)
time_gs = toc

fprintf('## SOR:\n')
tic
delta = dx^2 * dy^2 / (2 *(dx^2 + dy^2));
thetax = delta / dx^2;
thetay= delta / dy^2;
r = 1 - 4*(thetax*(sin(pi/(2*(J+1))))^2+thetay*(sin(pi/(2*(K+1))))^2);
% r je radij jacobijeve iteracijske matrike
omega = 2 / (1 + sqrt(1 - r^2));
[sol_sor, iter] = sor(M, bb, omega, 1e-5);
iter_sor = iter
directdiff_sor = norm(sol_sor - sol_direct)
time_sor = toc

% plot
SOL = zeros(K+2, J+2);
SOL(2:end-1, 2:end-1) = reshape(sol_direct, [J, K])';

% dostopaj kot SOL(y_k, x_j)
% ko narises s sruf ali izpises z flipud zgleda prav
for j = 0:J+1
    x = ax + j*dx;
    SOL(1, j+1) = down(x);
    SOL(end, j+1) = up(x);
end

for k = 0:K+1
    y = ay + k*dy;
    SOL(k+1, 1) = left(y);
    SOL(k+1, end) = right(y);
end

x = (ax):dx:(bx);
y = (ay):dy:(by);
[X, Y] = meshgrid(x, y);
surf(X, Y, SOL)
xlabel('x')
ylabel('y')
zlabel('z')

[px, py] = deal([0, 0]);
nicj = (px - ax) / dx;
nick = (py - ay) / dy;
if floor(nicj) ~= nicj, error('Point (%g, %g) does not coincide with a node.', px), end
if floor(nick) ~= nick, error('Point (%g, %g) does not coincide with a node.', py), end

nicidx = make_index(nicj, nick, J);
fprintf('## Errors:\n');
err_jac = abs(sol_direct(nicidx) - sol_jac(nicidx))
err_gs = abs(sol_direct(nicidx) - sol_gs(nicidx))
err_sor = abs(sol_direct(nicidx) - sol_sor(nicidx))

% check -- calculate back
LAP = zeros(K, J);
for j = 2:J+1
    for k = 2:K+1
        % SOL' ker je shema v (x, y) in SOL v (y, x)
        LAP(k-1, j-1) = apply(SOL', [j, k], shema, [1, 1]);
    end
end

x = (ax+dx):dx:(bx-dx);
y = (ay+dy):dy:(by-dy);
[X, Y] = meshgrid(x, y);
truelap = f(X, Y);
laplace_error = max(max(abs(LAP - truelap)))
% surf(X, Y, LAP)
% vim: set ft=matlab:
