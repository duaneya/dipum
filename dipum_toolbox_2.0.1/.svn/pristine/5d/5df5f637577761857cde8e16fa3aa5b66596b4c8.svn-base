function h = visreg(fref, f, tform, layer, alpha)
%VISREG Visualize registered images
%   VISREG(FREF, F, TFORM) displays two registered images together.
%   FREF is the reference image. F is the input image, and TFORM
%   defines the geometric transformation that aligns image F with
%   image FREF.
%
%   VISREG(FREF, F, TFORM, LAYER) displays F transparently over FREF
%   if LAYER is 'top'; otherwise it displays FREF transparently over
%   F.
%
%   VISREG(FREF, F, TFORM, LAYER, ALPHA) uses the scalar value
%   ALPHA, which ranges between 0.0 and 1.0, to control the level of
%   transparency of the top image.  If ALPHA is 1.0, the top image
%   is opaque.  If ALPHA is 0.0, the top image is invisible.
%
%   H = VISREG(...) returns a vector of handles to the two displayed
%   image objects.  H is in the form [HBOTTOM, HTOP].

%   Copyright 2002-2009 R. C. Gonzalez, R. E. Woods, and S. L. Eddins
%   From the book Digital Image Processing Using MATLAB, 2nd ed.,
%   Gatesmark Publishing, 2009.
%
%   Book web site: http://www.imageprocessingplace.com
%   Publisher web site: http://www.gatesmark.com/DIPUM2e.htm

if nargin < 5
   alpha = 0.5;
end

if nargin < 4
   layer = 'top';
end

% Transform the input image, f, recording where the result lies in
% coordinate space.
[g, g_xdata, g_ydata] = imtransform(f, tform);

[M, N] = size(fref);
fref_xdata = [1 N];
fref_ydata = [1 M];

if strcmp(layer, 'top')
   % Display the transformed input image above the reference image.
   top_image = g;
   top_xdata = g_xdata;
   top_ydata = g_ydata;
   
   % The transformed input image is likely to have regions of black
   % pixels because they correspond to "out of bounds" locations on
   % the original image.  (See Example 6.2.)  These pixels should be
   % displayed completely transparently.  To compute the appropriate
   % transparency matrix, we can start with a matrix filled with the
   % value ALPHA and then transform it with the same transformation
   % applied to the input image.  Any zeros in the result will cause
   % the black "out of bounds" pixels in g to be displayed
   % transparently.
   top_alpha = imtransform(alpha * ones(size(f)), tform);
   
   bottom_image = fref;
   bottom_xdata = fref_xdata;
   bottom_ydata = fref_ydata;
else
   % Display the reference image above the transformed input image.
   top_image = fref;
   top_xdata = fref_xdata;
   top_ydata = fref_ydata;
   top_alpha = alpha;
   
   bottom_image = g;
   bottom_xdata = g_xdata;
   bottom_ydata = g_ydata;
end

% Display the bottom image at the correct location in coordinate
% space. 
h_bottom = imshow(bottom_image, 'XData', bottom_xdata, ...
   'YData', bottom_ydata);
hold on

% Display the top image with the appropriate transparency.
h_top = imshow(top_image, 'XData', top_xdata, ...
   'YData', top_ydata);
set(h_top, 'AlphaData', top_alpha);

% The first call to imshow above has the effect of fixing the axis
% limits.  Use the axis command to let the axis limits be chosen
% automatically to fully encompass both images.
axis auto

if nargout > 0
   h = [h_bottom, h_top];
end
