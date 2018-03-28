function mu = trapezmf(z, a, b, c, d)
%TRAPEZMF Trapezoidal membership function.
%   MU = TRAPEZMF(Z, A, B, C) computes a fuzzy membership function
%   with a trapezoidal shape. Z is the input variable and can be a
%   vector of any length. A, B, C, and D are scalar parameters that
%   define the trapezoidal shape. The parameters must be ordered so
%   that A <= B, B <= C, and C <= D.
%
%       MU = 0,                         Z < A
%       MU = (Z - A) ./ (B - A),        A <= Z < B
%       MU = 1,                         B <= Z < C
%       MU = 1 - (Z - C) ./ (D - C),    C <= Z < D
%       MU = 0,                         D <= Z

%   Copyright 2002-2009 R. C. Gonzalez, R. E. Woods, and S. L. Eddins
%   From the book Digital Image Processing Using MATLAB, 2nd ed.,
%   Gatesmark Publishing, 2009.
%
%   Book web site: http://www.imageprocessingplace.com
%   Publisher web site: http://www.gatesmark.com/DIPUM2e.htm

mu = zeros(size(z));

up_ramp_region = (a <= z) & (z < b);
top_region = (b <= z) & (z < c);
down_ramp_region = (c <= z) & (z < d);

mu(up_ramp_region) = 1 - (b - z(up_ramp_region)) ./ (b - a);
mu(top_region) = 1;
mu(down_ramp_region) = 1 - (z(down_ramp_region) - c) ./ (d - c);

