function h = ntrop(x, n)
%NTROP Computes a first-order estimate of the entropy of a matrix.
%   H = NTROP(X, N) returns the entropy of matrix X with N
%   symbols. N = 256 if omitted but it must be larger than the
%   number of unique values in X for accurate results. The estimate
%   assumes a statistically independent source characterized by the
%   relative frequency of occurrence of the elements in X.
%   The estimate is a lower bound on the average number of bits per
%   unique value (or symbol) when coding without coding redundancy.

%   Copyright 2002-2009 R. C. Gonzalez, R. E. Woods, and S. L. Eddins
%   From the book Digital Image Processing Using MATLAB, 2nd ed.,
%   Gatesmark Publishing, 2009.
%
%   Book web site: http://www.imageprocessingplace.com
%   Publisher web site: http://www.gatesmark.com/DIPUM2e.htm

error(nargchk(1, 2, nargin));         % Check input arguments
if nargin < 2   
   n = 256;                           % Default for n.
end 

x = double(x);                        % Make input double
xh = hist(x(:), n);                   % Compute N-bin histogram
xh = xh / sum(xh(:));                 % Compute probabilities  

% Make mask to eliminate 0's since log2(0) = -inf.
i = find(xh);           

h = -sum(xh(i) .* log2(xh(i)));       % Compute entropy
