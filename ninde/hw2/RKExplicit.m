classdef RKExplicit
    % Class representing explicit RK solver
    properties
        alf
        bet
        gam
        n
    end
    methods
        function self = RKExplicit(alf, bet, gam)
            % Create an explicit RK solver
            % alf: a vector of dimensions n
            % bet: a n by n strictly lower triagonal matrix
            % gam: a vector of dimension n
            % representing the RK method given with Butcher's tableau
            % a |
            % l | b
            % f | e t
            % --+------
            %   | g a m
            if nargin < 3, error('Not enough arguments.'), end
            sa = size(alf);
            if (sa(2) > 1), alf = alf'; end
            if (sa(1) > 1 && sa(2) > 1), error('Alpha expected to be a vector, got dimensions: %s', mat2str(size(alf))), end
            sa = size(alf);
            self.n = sa(1);
            sg = size(gam);
            if (sg(2) > 1), gam = gam'; end
            if (sg(1) > 1 && sg(2) > 1), error('Gamma expected to be a vector, got dimensions: %s', mat2str(size(gam))), end
            if (any(size(alf) ~= size(gam))), error('Alpha and gamma must have same dimensions, got %s vs. %s.', mat2str(size(alf)), mat2str(size(gam))), end
            sb = size(bet);
            if (sb(1) ~= self.n || sb(2) ~= self.n), error('Dimensions of beta do not agree with alpha and gamma, dimensions of beta are: %s but sould be [%d, %d].', mat2str(size(bet)), self.n, self.n), end
            if (~all(all(tril(bet, -1) == bet))), error('Beta must be strictly lower triangular, but got: %s.', mat2str(bet)), end
            % all ok
            self.alf = alf;
            self.bet = bet;
            self.gam = gam;
        end
        function sol = solve(self, f, a, b, y0, h)
            % Approximate a solution to a Cauchy problem
            % y' = f(x, y),
            % y(a) = y0
            % on an interval [a, b] using the RK method with step h.
            % Returns matrix [x; y] of solutions in points a + i*h.
            if ((b-a)*h < 0), error('Value of a+h does not go towards b. a = %g, b = %g, h = %g', a, b, h), end
            if (~isvector(y0)), error('y0 is not a vector.'), end
            if (~iscolumn(y0)), y0 = y0'; end
            sfx = size(f(a, y0));
            sy = size(y0);
            d = sy(1);
            if (sfx(1) ~= d || sfx(2) > 1), error('Expected f to be a vector function of dimension %d, but got %s.', d, mat2str(sfx)), end
            N = ceil((b-a)/h)+1;
            sol = zeros(d+1, N);
            sol(:, 1) = [a; y0];
            x = a;
            y = y0;
            for i = 2:(N-1)
                y = self.getnext(f, x, y, h);
                x = x + h;
                sol(:, i) = [x ; y];
            end
            if h > 0 && x+h > b || h < 0 && x+h < b, h = b - x; end
            y = self.getnext(f, x, y, h);
            sol(:, N) = [b ; y];
        end
        function K = getk(self, f, x, y, h)
            % Returns approximations K for derivatives of y in some
            % intermediate points as prescribed by the method.
            % K is a 
            if (~isscalar(x)), error('x is not scalar.'), end
            if (~isscalar(h)), error('h is not scalar.'), end
            if (~isvector(y)), error('y is not a vector.'), end
            if (~iscolumn(y)), y = y'; end
            sy = size(y);
            d = sy(1);
            sfx = size(f(x, y));
            if (sfx(1) ~= d || sfx(2) > 1), error('Expected f to be a vector function of dimension %d, but got dimensions %s.', d, mat2str(sfx)), end
            K = zeros(d, self.n);
            for i = 1:self.n
                K(:, i) = f(x + self.alf(i)*h, y + h*K(:,1:i-1)*self.bet(i,1:i-1)');
            end
        end
        function yn = getnext(self, f, x, y, h)
            % Retuns approximation yn for the value of y(x+h), given
            % x, y(x) and the equation y' = f(x, y).
            K = self.getk(f, x, y, h);
            yn = y + h*K*self.gam;
        end
    end
end