hold on
x = [];
y = [];
while 1
    axis([-1, 1, -1, 1])
    [cx, cy, btn] = ginput(1);
    switch btn
        case 1 
            x = [x; cx];
            y = [y; cy];
        case 3 
            if length(x) >= 1
                x = x(1:end-1);
                y = y(1:end-1);
            end
        case 2
            break
    end
    D = [x y];
    clf
    axis([-1, 1, -1, 1])
    if length(x) >= 4
        s = Spline.cubic(Spline.params(D(1:end-2,:), 0.5), D);
        s.plot();
    end
    plot(x, y, 'ko--')
end
close