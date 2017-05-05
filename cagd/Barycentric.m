classdef Barycentric
    % Handles conversion from and to Barycentric coordinates
    methods(Static)
        function u = ofPoint(p, T)
            [n, d] = size(T);
            assert(length(p) == d, 'Dimensions of point and triangle do not match.')
            u = [1, p] / [ones(n, 1) T];
        end
        function u = ofVector(v, T)
            [n, d] = size(T);
            assert(length(v) == d, 'Dimensions of point and triangle do not match.')
            u = [0, v] / [ones(n, 1) T];
        end
    end
end