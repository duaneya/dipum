function mu = zeromf(z)
%ZEROMF Constant membership function (zero).
%   ZEROMF(Z) returns an an array of zeros with the same size as Z.
%
%   When using the @max operator to combine rule antecedents,
%   associating this membership function with a particular input
%   means that input has no effect.

%   Copyright 2002-2009 R. C. Gonzalez, R. E. Woods, and S. L. Eddins
%   From the book Digital Image Processing Using MATLAB, 2nd ed.,
%   Gatesmark Publishing, 2009.
%
%   Book web site: http://www.imageprocessingplace.com
%   Publisher web site: http://www.gatesmark.com/DIPUM2e.htm

mu = zeros(size(z));
