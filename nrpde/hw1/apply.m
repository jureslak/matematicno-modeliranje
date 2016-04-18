function value = apply(fn, point, shema, step)
% Apply diference schema with discretizations specified by step to fn
% at given point.
% fn: function to apply the schema to, function of n args
% point: n-dim vector where to apporximate the function
% schema: array of [multiplies, x1 offset, x2 offset, ...] of width n+1
% step: scalar h or vector of length n: dx1, dx2, ...
if nargin < 4
    error('Supply all 3 arguments: function, point, schema, step')
end
n = length(point);
if length(step) == 1, step = step*ones(1, n); end
if n ~= length(step)
    error('Step and point must be of same dimension (or step must be scalar)')
end
[~, ns] = size(shema);
if ns ~= n+1
    error('Schema has wrong dimensions, %d != %d + 1', ns, n);
end
value = 0;
for s = shema'
    m = s(1);
    value = value + m*fn(point+s(2:end)'.*step);
end
end

