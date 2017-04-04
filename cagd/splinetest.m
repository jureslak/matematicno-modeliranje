clear
D =  [0 0; 1 2; 3 -2; 4 2; 5 1; 7 -2; 9 4];

s1 = Spline.quad(Spline.params(D(1:end-1,:)), D);
s2 = Spline.quad(Spline.params(D(1:end-1,:), 1/2), D);
s3 = Spline.quad(Spline.params(D(1:end-1,:), 1), D);
% s1.plot();
% s2.plot();
% s3.plot();
% plot(D(:,1), D(:, 2), 'ko');
D = [0 0; 1 1; 3 -1; 5 4]; % ; 6 2; 4 0; -1 5];
% u = Spline.params(D([1 3 4 5 7], :), 0.5);
s = Spline.cubic(0:1, D);
s.curves{1}.B
s.curves{2}.B
s.curves{3}.B
s.curves{4}.B