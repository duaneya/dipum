function g = fuzzyfilt(f)
%FUZZYFILT Fuzzy edge detector.
%   G = FUZZYFILT(F) implements the rule-based fuzzy filter
%   discussed in the "Using Fuzzy Sets for Spatial Filtering"
%   section of Digital Image Processing Using MATLAB/2E. F and G are
%   the input and filtered images, respectively. 
%
%   FUZZYFILT is implemented using precomputed fuzzy system function
%   handle saved in the MAT-file fuzzyedgesys.mat.  The M-script
%   makefuzzyedgesys.m contains the code used to create the fuzzy
%   system function.

%   Copyright 2002-2009 R. C. Gonzalez, R. E. Woods, and S. L. Eddins
%   From the book Digital Image Processing Using MATLAB, 2nd ed.,
%   Gatesmark Publishing, 2009.
%
%   Book web site: http://www.imageprocessingplace.com
%   Publisher web site: http://www.gatesmark.com/DIPUM2e.htm
 
% Work in floating point.
[f, revertClass] = tofloat(f);

% The fuzzy system function has four inputs - the differences
% between the pixel and its north, east, south, and west neighbors.
% Compute these differences for every pixel in the image using
% imfilter.
z1 = imfilter(f, [0 -1 1], 'conv', 'replicate');
z2 = imfilter(f, [0; -1; 1], 'conv', 'replicate');
z3 = imfilter(f, [1; -1; 0], 'conv', 'replicate');
z4 = imfilter(f, [1 -1 0], 'conv', 'replicate');

% Load the precomputed fuzzy system function from the MAT-file and
% apply it.
s = load('fuzzyedgesys');
g = s.G(z1, z2, z3, z4);

% Convert the output image back to the class of the input image.
g = revertClass(g);
