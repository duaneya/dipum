function f = twodsin2(A, u0, v0, M, N)
r = 0:M - 1;
c = 0:N - 1;
[C, R] = meshgrid(c, r);
f = A*sin(u0*R + v0*C);