function [s, sUnit] = bsubsamp(b, gridsep)
%BSUBSAMP Subsample a boundary.
%   [S, SUNIT] = BSUBSAMP(B, GRIDSEP) subsamples the boundary B by
%   assigning each of its points to the grid node to which it is
%   closest.  The grid is specified by GRIDSEP, which is the
%   separation in pixels between the grid lines. For example, if
%   GRIDSEP = 2, there are two pixels in between grid lines. So, for
%   instance, the grid points in the first row would be at (1,1),
%   (1,4), (1,6), ..., and similarly in the y direction. The value
%   of GRIDSEP must be an integer. The boundary is specified by a
%   set of coordinates in the form of an np-by-2 array.  It is
%   assumed that the boundary is one pixel thick and that it is
%   ordered in a clockwise or counterclockwise sequence. 
%
%   Output S is the subsampled boundary. Output SUNIT is normalized
%   so that the grid separation is unity.  This is useful for
%   obtaining the Freeman chain code of the subsampled boundary. The
%   outputs are in the same order (clockwise or counterclockwise) as
%   the input. There are no duplicate points in the output.

%   Copyright 2002-2009 R. C. Gonzalez, R. E. Woods, and S. L. Eddins
%   From the book Digital Image Processing Using MATLAB, 2nd ed.,
%   Gatesmark Publishing, 2009.
%
%   Book web site: http://www.imageprocessingplace.com
%   Publisher web site: http://www.gatesmark.com/DIPUM2e.htm

% Check inputs.
[np, nc] = size(b);
if np < nc 
   error('b must be of size np-by-2.'); 
end
if isinteger(gridsep)
   error('gridsep must be an integer.')
end

% Find the maximum span of the boundary.
xmax = max(b(:, 1)) + 1;
ymax = max(b(:, 2)) + 1;

% Determine the integral number of grid lines with gridsep points in
% between them that encompass the intervals [1,xmax], [1,ymax].
GLx = ceil((xmax + gridsep)/(gridsep + 1));
GLy = ceil((ymax + gridsep)/(gridsep + 1));

% Form vector of grid coordinates.
I = 1:GLx;
J = 1:GLy;
% Vector of grid line locations intersecting x-axis.
X(I) = gridsep*I + (I - gridsep); 
% Vector of grid line locations intersecting y-axis.
Y(J) = gridsep*J + (J - gridsep);
[C, R] = meshgrid(Y, X); % See CH 02 regarding function meshgrid.
% Vector of grid all coordinates, arranged as Nunbergridpoints-by-2
% array to match the horizontal dimensions of b. This allows
% computation of distances to be vectorized and thus be much more
% efficient.
V =  [C(1:end); R(1:end)]'; 

% Compute the distance between every element of b and every element
% of the grid.  See Chapter 13 regarding distance computations.
p = np;
q = size(V, 1);
D = sqrt(sum(abs(repmat(permute(b, [1 3 2]), [1 q 1])...
        -repmat(permute(V, [3 1 2]), [p 1 1])).^2, 3));
     
% D(i, j) is the distance between the ith row of b and the jth
% row of V. Find the min between each element of b and V.
new_b = zeros(np, 2); % Preallocate memory.
for I = 1:np
   idx = find(D(I,:) == min(D(I,:)), 1); % One min in row I of D.
   new_b(I, :) = V(idx, :);
end

% Eliminate duplicates and keep same order as input.
[s, m] = unique(new_b, 'rows');
s = [s, m];
s = fliplr(s);
s = sortrows(s);
s = fliplr(s);
s = s(:, 1:2);

% Scale to unit grid so that can use directly to obtain Freeman
% chain codes.  The shape does not change.
sUnit = round(s./gridsep) + 1;
