%MAKEFUZZYEDGESYS Script to make MAT-file used by FUZZYFILT.

%   Copyright 2002-2009 R. C. Gonzalez, R. E. Woods, and S. L. Eddins
%   From the book Digital Image Processing Using MATLAB, 2nd ed.,
%   Gatesmark Publishing, 2009.
%
%   Book web site: http://www.imageprocessingplace.com
%   Publisher web site: http://www.gatesmark.com/DIPUM2e.htm

% Input membership functions.
zero = @(z) bellmf(z, -0.3, 0);
not_used = @(z) onemf(z);

% Output membership functions.
black = @(z) triangmf(z, 0, 0, 0.75);
white = @(z) triangmf(z, 0.25, 1, 1);

% There are four rules and four inputs, so the inmf matrix is 4x4.
% Each row of the inmf matrix corresponds to one rule.
inmf = {zero, not_used, zero, not_used
   not_used, not_used, zero, zero
   not_used, zero, not_used, zero
   zero, zero, not_used, not_used};

% The set of output membership functions has an "extra" one, which
% means that an "else rule" will automatically be used.
outmf = {white, white, white, white, black};

% Inputs to the output membership functions are in the range [0, 1].
vrange = [0 1];

F = fuzzysysfcn(inmf, outmf, vrange);

% Compute a lookup-table-based approximation to the fuzzy system
% function. Each of the four inputs is in the range [-1, 1].
G = approxfcn(F, [-1 1; -1 1; -1 1; -1 1]);

% Save the fuzzy system approximation function to a MAT-file.
save fuzzyedgesys G
