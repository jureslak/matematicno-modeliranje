classdef BezierPatchSlice
    properties
        B
        n
    end
    
    methods
        function obj = BezierPatchSlice(B)
            % n+1 x n+1 matrika katere koeficinet na mestu (i, j),
            % j <= n+2-i, doloca koeficient polinoma z indeksom
            % (n+2-i-j, j-1, i-1)
            [q, m] = size(B);
            assert(q == m, 'Matrix B must be square.')
            obj.n = q - 1;
            obj.B = B;
        end
    end
end

