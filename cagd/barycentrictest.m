T = [0, 0; 0, 3; 3, 0];
assert(norm([1, 0, 0] - Barycentric.ofPoint([0, 0], T)) < eps, 'Barycentric wrong.');
assert(norm([0, 1, 0] - Barycentric.ofPoint([0, 3], T)) < eps, 'Barycentric wrong.');
assert(norm([0, 0, 1] - Barycentric.ofPoint([3, 0], T)) < eps, 'Barycentric wrong.');