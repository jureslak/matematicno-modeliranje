tmp.alf = [0, 0.5, 0.5, 1];
tmp.bet = diag([0.5, 0.5, 1], -1);
tmp.gam = [1/6, 2/6, 2/6, 1/6];
RK4 = RKExplicit(tmp.alf, tmp.bet, tmp.gam);