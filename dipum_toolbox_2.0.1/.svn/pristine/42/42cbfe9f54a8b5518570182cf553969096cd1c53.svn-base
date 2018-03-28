function cp = cornerprocess(c, T, q)
%CORNERPROCESS Processes the output of function cornermetric.
%	CP = CORNERPROCESS(C, T, Q) postprocesses C, the output of
%	function CORNERMETRIC, with the objective of reducing the
%	number of irrelevant corner points (with respect to threshold T)
%	and the number of multiple corners in a neighborhood of size
%	Q-by-Q. If there are multiple corner points contained within
%	that neighborhood, they are eroded morphologically to one corner
%	point.
%
%   A corner point is said to have been found at coordinates (I, J)
%   if C(I,J) > T. 
%
%	A good practice is to normalize the values of C to the range [0
%	1], in im2double format before inputting C into this function.
%	This facilitates interpretation of the results and makes
%	thresholding more intuitive.

%   Copyright 2002-2009 R. C. Gonzalez, R. E. Woods, and S. L. Eddins
%   From the book Digital Image Processing Using MATLAB, 2nd ed.,
%   Gatesmark Publishing, 2009.
%
%   Book web site: http://www.imageprocessingplace.com
%   Publisher web site: http://www.gatesmark.com/DIPUM2e.htm

% Peform thresholding.
cp = c > T;
 
% Dilate CP to incorporate close neighbors.
B = ones(q);
cp = imdilate(cp, B);

% Shrink connnected components to single points.
cp = bwmorph(cp, 'shrink','Inf');





