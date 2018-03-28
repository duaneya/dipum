function mu = triangmf(z, a, b, c)
%TRIANGMF Triangular membership function.
%   MU = TRIANGMF(Z, A, B, C) computes a fuzzy membership function
%   with a triangular shape. Z is the input variable and can be a
%   vector of any length. A, B, and C are scalar parameters, such
%   that B >= A and C >= B, that define the triangular shape.
%
%       MU = 0,                         Z < A
%       MU = (Z - A) ./ (B - A),        A <= Z < B
%       MU = 1 - (Z - B) ./ (C - B),    B <= Z < C
%       MU = 0,                         C <= Z

%   Copyright 2002-2009 R. C. Gonzalez, R. E. Woods, and S. L. Eddins
%   From the book Digital Image Processing Using MATLAB, 2nd ed.,
%   Gatesmark Publishing, 2009.
%
%   Book web site: http://www.imageprocessingplace.com
%   Publisher web site: http://www.gatesmark.com/DIPUM2e.htm

mu = zeros(size(z));

low_side  = (a <= z) & (z < b);
high_side = (b <= z) & (z < c);

mu(low_side)  = (z(low_side) - a) ./ (b - a);
mu(high_side) = 1 - (z(high_side) - b) ./ (c - b);

