function  mean = localmean(f, nhood)
%LOCALMEAN Computes an array of local means.
%  MEAN = LOCALMEAN(F, NHOOD) computes the mean at the center of
%  every neighborhood of F defined by NHOOD, an array of zeros and
%  ones where the nonzero elements specify the neighbors used in the
%  computation of the local means. The size of NHOOD must be odd in
%  each dimension; the default is ones(3). Output MEAN is an array
%  the same size as F containing the local mean at each point.

%   Copyright 2002-2009 R. C. Gonzalez, R. E. Woods, and S. L. Eddins
%   From the book Digital Image Processing Using MATLAB, 2nd ed.,
%   Gatesmark Publishing, 2009.
%
%   Book web site: http://www.imageprocessingplace.com
%   Publisher web site: http://www.gatesmark.com/DIPUM2e.htm

if nargin == 1
   nhood = ones(3) / 9;
else
   nhood = nhood / sum(nhood(:));
end
mean = imfilter(tofloat(f), nhood, 'replicate');
