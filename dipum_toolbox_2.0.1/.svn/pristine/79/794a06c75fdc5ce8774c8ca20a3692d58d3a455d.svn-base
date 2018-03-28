function vistform(tform, wz)
%VISTFORM Visualization transformation effect on set of points.
%   VISTFORM(TFORM, WZ) shows two plots.  On the left are the
%   points in each row of the P-by-2 matrix WZ.  On the right are
%   the spatially transformed points using TFORM.

%   Copyright 2002-2009 R. C. Gonzalez, R. E. Woods, and S. L. Eddins
%   From the book Digital Image Processing Using MATLAB, 2nd ed.,
%   Gatesmark Publishing, 2009.
%
%   Book web site: http://www.imageprocessingplace.com
%   Publisher web site: http://www.gatesmark.com/DIPUM2e.htm

% Transform the points to output space.
xy = tformfwd(tform, wz);

% Compute axes limits for both plots.  Bump the limits outward
% slightly.
minlim = min([wz; xy], [], 1);
maxlim = max([wz; xy], [], 1);
bump = max((maxlim - minlim) * 0.05, 0.1);
limits = [minlim(1)-bump(1), maxlim(1)+bump(1), ...
    minlim(2)-bump(2), maxlim(2)+bump(2)];

subplot(1,2,1)
grid_plot(wz, limits, 'w', 'z')

subplot(1,2,2)
grid_plot(xy, limits, 'x', 'y')

%-----------------------------------------------------------------%
function grid_plot(ab, limits, a_label, b_label)
plot(ab(:,1), ab(:,2), '.', 'MarkerSize', 2)
axis equal, axis ij, axis(limits);
set(gca, 'XAxisLocation', 'top')
xlabel(a_label), ylabel(b_label)

