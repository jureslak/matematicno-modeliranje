format compact
format long
u = @(x, y) exp(-x.^2-y.^2);
U = @(x) u(x(1), x(2));

% zapis poljubne sheme [faktor, premik desno, premik gor]
% direktno iz zapiskov
shema_basic = [
[  1, -2, 0];
[ -4, -1, 0];
[  6,  0, 0];
[ -4,  1, 0];
[  1,  2, 0];

[  1, 0, -2];                                                                                                                                                                                                                           
[ -4, 0, -1];
[  6, 0,  0];
[ -4, 0,  1];
[  1, 0,  2];

[ 2,  1,  1];
[ 2,  1, -1];
[ 2, -1,  1];
[ 2, -1, -1];
[-4,  1,  0];
[-4,  0,  1];
[-4, -1,  0];
[-4,  0, -1];
[ 8,  0,  0];
];

% Drawing
% sp = sparse(shema(:,2)+3, shema(:,3)+3, shema(:,1));
% spy(sp)

point = [0, 0];

trials = 30;
realval = 32;
minerr = 10000;
bestj = 0;
err = zeros(trials, 1);
for j = 1:trials
    dx = 1/j^2;   % se da bolj enostavno, ampak za lažjo spremembo
    dy = 1/j^2;
    shema = shema_basic;
    
    % delimo posamezne faktorje
    shema(1:5,1) = shema(1:5,1) / dx^4;
    shema(6:10,1) = shema(6:10,1) / dy^4;
    shema(11:end,1) = shema(11:end,1) / dx^2 / dy^2;
    
    appr = apply(U, point, shema, [dx, dy]);
    err(j) = abs(appr-realval);
    if err(j) < minerr
        minerr = err(j);
        bestj = j;
    end
end
err
bestj = bestj

% vim: set ft=matlab:
