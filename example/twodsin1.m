function f = twodsin1(A, u0, v0, M, N)
f = zeros(M, N);
for c = 1:N
    v0y = v0 * (c - 1);
    for r = 1:M
        u0x = u0 * (r - 1);
        f(r, c) = A*sin(u0x + v0y);
    end
end