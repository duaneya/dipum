function [dist, angle] = signature(b, x0, y0)
%SIGNATURE Computes the signature of a boundary. 
%   [DIST, ANGLE, XC, YC] = SIGNATURE(B, X0, Y0) computes the
%   signature of a given boundary. A signature is defined as the
%   distance from (X0, Y0) to the boundary, as a function of angle
%   (ANGLE). B is an np-by-2 array (np > 2) containing the (x, y)
%   coordinates of the boundary ordered in a clockwise or
%   counterclockwise direction. If (X0, Y0) is not included in the
%   input argument, the centroid of the boundary is used by default.
%   The maximum size of arrays DIST and ANGLE is 360-by-1,
%   indicating a maximum resolution of one degree. The input must be
%   a one-pixel-thick boundary obtained, for example, by using
%   function bwboundaries. 
%   
%   If (X0, Y0) or the default centroid is outside the boundary, the
%   signature is not defined and an error is issued. 

%   Copyright 2002-2009 R. C. Gonzalez, R. E. Woods, and S. L. Eddins
%   From the book Digital Image Processing Using MATLAB, 2nd ed.,
%   Gatesmark Publishing, 2009.
%
%   Book web site: http://www.imageprocessingplace.com
%   Publisher web site: http://www.gatesmark.com/DIPUM2e.htm

% Check dimensions of b.
[np, nc] = size(b);
if (np < nc || nc ~= 2) 
   error('b must be of size np-by-2.'); 
end

% Some boundary tracing programs, such as boundaries.m, result in a
% sequence in which the coordinates of the first and last points are
% the same. If this is the case, in b, eliminate the last point.
if isequal(b(1, :), b(np, :)) 
   b = b(1:np - 1, :); 
   np = np - 1;
end
    
% Compute the origin of vector as the centroid, or use the two
% values specified. Use the same symbol (xc, yc) in case the user
% includes (xc, yc) in the output call.
if nargin == 1
   x0 = sum(b(:, 1))/np; % Coordinates of the centroid.
   y0 = sum(b(:, 2))/np; 
end

% Check to see that (xc, yc) is inside the boundary.
IN = inpolygon(x0, y0, b(:, 1), b(:, 2));
if ~IN
   error('(x0, y0) or centroid is not inside the boundary.')
end
    
% Shift origin of coordinate system to (x0, y0).
b(:, 1) = b(:, 1) - x0;
b(:, 2) = b(:, 2) - y0;

% Convert the coordinates to polar.  But first have to convert the
% given image coordinates, (x, y), to the coordinate system used by
% MATLAB for conversion between Cartesian and polar cordinates.
% Designate these coordinates by (xcart, ycart). The two coordinate
% systems are related as follows:  xcart = y and ycart = -x.
xcart = b(:, 2);
ycart = -b(:, 1);
[theta, rho] = cart2pol(xcart, ycart);

% Convert angles to degrees.
theta = theta.*(180/pi);

% Convert to all nonnegative angles.
j = theta == 0; % Store the indices of theta = 0 for use below.
theta = theta.*(0.5*abs(1 + sign(theta)))...
        - 0.5*(-1 + sign(theta)).*(360 + theta);
theta(j) = 0; % To preserve the 0 values.

% Round theta to 1 degree increments.
theta = round(theta);

% Keep theta and rho together for sorting purposes.
tr = [theta, rho]; 

% Delete duplicate angles.  The unique operation also sorts the
% input in ascending order.
[w, u] = unique(tr(:, 1)); 
tr = tr(u,:); % u identifies the rows kept by unique.

% If the last angle equals 360 degrees plus the first angle, delete
% the last angle.
if tr(end, 1) == tr(1) + 360
   tr = tr(1:end - 1, :);
end
        
% Output the angle values.
angle = tr(:, 1);

% Output the length values.
dist = tr(:, 2); 
