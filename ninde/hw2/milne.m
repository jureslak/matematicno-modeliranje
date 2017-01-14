function M=milne(f,T,Y,n)

%Input    - f is the function 
%            - T is the vector of abscissas
%            - Y is the vector of ordinates
%Remark.  The first four coordinates of T and Y must
%               have starting values obtained with RK4
%Output - M=[T' Y'] where T is the vector of abscissas and
%              Y is the vector of ordinates

% If f is an M-file function call M=milne(@f,T,Y).
% If f is an anonymous function call M=milne(f,T,Y).

%  NUMERICAL METHODS: Matlab Programs
% (c) 2004 by John H. Mathews and Kurtis D. Fink
%  Complementary Software to accompany the textbook:
%  NUMERICAL METHODS: Using Matlab, Fourth Edition
%  ISBN: 0-13-065248-2
%  Prentice-Hall Pub. Inc.
%  One Lake Street
%  Upper Saddle River, NJ 07458

F=f(T(1:4),Y(:, 1:4));
F'
h=T(2)-T(1);

for k=4:n-1
   %Predictor
   pnew=Y(:, k-3)+(4*h/3)*(F(:, 2:4)*[2 -1 2]')
   %Modifier
   % pmod=pnew+28*(yold-pold)/29;
   T(k+1)=T(1)+h*k;
   F=[F(:, 2) F(:, 3) F(:, 4) f(T(k+1),pnew)];
   %Corrector
   Y(:, k+1)=Y(:, k-1)+(h/3)*(F(:, 2:4)*[1 4 1]');
   F(:, 4)=f(T(k+1),Y(:, k+1));
   F'
end

M=[T' Y'];

end