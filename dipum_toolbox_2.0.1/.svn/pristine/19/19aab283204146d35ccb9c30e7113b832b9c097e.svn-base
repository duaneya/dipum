function mu = sigmamf(z, a, b)
%SIGMAMF Sigma membership function.
%   MU = SIGMAMF(Z, A, B) computes the sigma fuzzy membership
%   function. Z is the input variable and can be a vector of
%   any length. A and B are scalar shape parameters, ordered
%   such that A <= B.
%
%       MU = 0,                         Z < A
%       MU = (Z - A) ./ (B - A),        A <= Z < B
%       MU = 1,                         B <= Z

%   Copyright 2002-2009 R. C. Gonzalez, R. E. Woods, and S. L. Eddins
%   From the book Digital Image Processing Using MATLAB, 2nd ed.,
%   Gatesmark Publishing, 2009.
%
%   Book web site: http://www.imageprocessingplace.com
%   Publisher web site: http://www.gatesmark.com/DIPUM2e.htm

mu = trapezmf(z, a, b, Inf, Inf);

