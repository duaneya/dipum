function image = bound2im(b, M, N)
%BOUND2IM Converts a boundary to an image.
%   IMAGE = BOUND2IM(b) converts b, an np-by-2 array containing the
%   integer coordinates of a boundary, into a binary image with 1s
%   in the locations of the coordinates in b and 0s elsewhere. The
%   height and width of the image are equal to the Mmin + H and Nmin
%   + W, where Mmin = min(b(:,1)) - 1, N = min(b(:,2)) - 1, and H
%   and W are the height and width of the boundary. In other words,
%   the image created is the smallest image that will encompass the
%   boundary while maintaining the its original coordinate values.
%
%   IMAGE = BOUND2IM(b, M, N) places the boundary in a region of
%   size M-by-N. M and N must satisfy the following conditions:
%
%       M >= max(b(:,1)) - min(b(:,1)) + 1 
%       N >= max(b(:,2)) - min(b(:,2)) + 1 
%
%   Typically, M = size(f, 1) and N = size(f, 2), where f is the
%   image from which the boundary was extracted. In this way, the
%   coordinates of IMAGE and f are registered with respect to each
%   other.

%   Copyright 2002-2009 R. C. Gonzalez, R. E. Woods, and S. L. Eddins
%   From the book Digital Image Processing Using MATLAB, 2nd ed.,
%   Gatesmark Publishing, 2009.
%
%   Book web site: http://www.imageprocessingplace.com
%   Publisher web site: http://www.gatesmark.com/DIPUM2e.htm

% Check input.
if size(b, 2) ~= 2
   error('The boundary must be of size np-by-2')
end

% Make sure the coordinates are integers.
 b = round(b);
 
% Defaults.
if nargin == 1
   Mmin = min(b(:,1)) - 1;
   Nmin = min(b(:,2)) - 1;
   H = max(b(:,1)) - min(b(:,1)) + 1; % Height of boundary.
   W = max(b(:,2)) - min(b(:,2)) + 1; % Width of boundary.
   M = H + Mmin;
   N = W + Nmin;
end
   
% Create the image.
image = false(M, N);
linearIndex = sub2ind([M, N], b(:,1), b(:,2));
image(linearIndex) = 1;

