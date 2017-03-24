clear
D =  [0 0; 1 2; 3 -2; 4 2; 5 1; 7 -2; 9 4];

s1 = Spline.quad(Spline.params(D(1:end-1,:)), D);
s2 = Spline.quad(Spline.params(D(1:end-1,:), 1/2), D);
s3 = Spline.quad(Spline.params(D(1:end-1,:), 1), D);
s1.plot();
s2.plot();
s3.plot();
plot(D(:,1), D(:, 2), 'ko');
