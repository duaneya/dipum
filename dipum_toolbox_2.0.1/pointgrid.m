function wz = pointgrid(corners)
%POINTGRID Points arranged on a grid.
%   WZ = POINTGRID(CORNERS) computes a set point of points on a
%   grid containing 10 horizontal and vertical lines.  Each line
%   contains 50 points.  CORNERS is a 2-by-2 matrix.  The first
%   row contains the horizontal and vertical coordinates of one
%   corner of the grid. The second row contains the coordinates
%   of the opposite corner.  Each row of the P-by-2 output
%   matrix, WZ, contains the coordinates of a point on the output
%   grid.

%   Copyright 2002-2009 R. C. Gonzalez, R. E. Woods, and S. L. Eddins
%   From the book Digital Image Processing Using MATLAB, 2nd ed.,
%   Gatesmark Publishing, 2009.
%
%   Book web site: http://www.imageprocessingplace.com
%   Publisher web site: http://www.gatesmark.com/DIPUM2e.htm

% Create 10 horizontal lines containing 50 points each.
[w1, z1] = meshgrid(linspace(corners(1,1), corners(2,1), 46), ...
    linspace(corners(1), corners(2), 10));

% Create 10 vertical lines containing 50 points each.
[w2, z2] = meshgrid(linspace(corners(1), corners(2), 10), ...
    linspace(corners(1), corners(2), 46));

% Create a P-by-2 matrix containing all the input-space points.
wz = [w1(:) z1(:); w2(:) z2(:)];

