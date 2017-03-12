classdef Bernstein
   methods(Static)
       function pols = ber2std(polb)
           if ~isrow(polb), polb = polb'; end
           n = length(polb)-1;
           M = zeros(n+1, n+1);
           for i = 0:n
               for j = i:n
                   M(i+1, n-j+1) = (-1)^(i+j)*nchoosek(n,j)*nchoosek(j, i);
               end
           end
           pols = polb*M';
       end
       function polb = std2ber(pols)
           if ~isrow(pols), pols = pols'; end
           n = length(pols)-1;
           M = zeros(n+1, n+1);
           for i = 0:n
               for j = i:n
                   M(n-i+1, j+1) = nchoosek(j, i) / nchoosek(n, i);
               end
           end
           polb = pols*M;
       end
   end
end