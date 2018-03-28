function flag = predicate(region)
%PREDICATE Evaluates a predicate for function splitmerge
%   FLAG = PREDICATE(REGION) evaluates a predicate for use in
%   function splitmerge for Example 11.14 in Digital Image
%   Processing Using MATLAB, 2nd edition. REGION is a subimage, and
%   FLAG is set to TRUE if the predicate evaluates to TRUE for
%   REGION; FLAG is set to FALSE otherwise.

%   Copyright 2002-2009 R. C. Gonzalez, R. E. Woods, and S. L. Eddins
%   From the book Digital Image Processing Using MATLAB, 2nd ed.,
%   Gatesmark Publishing, 2009.
%
%   Book web site: http://www.imageprocessingplace.com
%   Publisher web site: http://www.gatesmark.com/DIPUM2e.htm

% Compute the standard deviation and mean for the intensities of the
% pixels in REGION.
sd = std2(region);
m = mean2(region);

% Evaluate the predicate.
flag = (sd > 10) & (m > 0) & (m < 125); 
