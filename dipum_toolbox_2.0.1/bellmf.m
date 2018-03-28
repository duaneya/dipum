function mu = bellmf(z, a, b)
%BELLMF Bell-shaped membership function.
%   MU = BELLMF(Z, A, B) computes the bell-shaped fuzzy membership
%   function. Z is the input variable and can be a vector of any
%   length. A and B are scalar shape parameters, ordered such that
%   A <= B.
%
%       MU = SMF(Z, A, B),        Z < B
%       MU = SMF(2*B - Z, A, B),  B <= Z

%   Copyright 2002-2009 R. C. Gonzalez, R. E. Woods, and S. L. Eddins
%   From the book Digital Image Processing Using MATLAB, 2nd ed.,
%   Gatesmark Publishing, 2009.
%
%   Book web site: http://www.imageprocessingplace.com
%   Publisher web site: http://www.gatesmark.com/DIPUM2e.htm

mu = zeros(size(z));

left_side = z < b;
mu(left_side) = smf(z(left_side), a, b);

right_side = z >= b;
mu(right_side) = smf(2*b - z(right_side), a, b);

