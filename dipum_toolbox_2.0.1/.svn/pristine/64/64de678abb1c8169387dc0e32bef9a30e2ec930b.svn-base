function out = defuzzify(Qa, vrange)
%DEFUZZIFY Output of fuzzy system.
%   OUT = DEFUZZIFY(QA, VRANGE) transforms the aggregation function
%   QA into a fuzzy result using the center-of-gravity method. QA is
%   a function handle as returned by AGGFCN. VRANGE is a two-element
%   vector specifying the range of input values for QA. OUT is the
%   scalar result.

%   Copyright 2002-2009 R. C. Gonzalez, R. E. Woods, and S. L. Eddins
%   From the book Digital Image Processing Using MATLAB, 2nd ed.,
%   Gatesmark Publishing, 2009.
%
%   Book web site: http://www.imageprocessingplace.com
%   Publisher web site: http://www.gatesmark.com/DIPUM2e.htm

v1 = vrange(1);
v2 = vrange(2);

v = linspace(v1, v2, 100);
Qv = Qa(v);
out = sum(v .* Qv) / sum(Qv);
if isnan(out)
   % If Qv is zero everywhere, out will be NaN. Arbitrarily choose
   % output to be the midpoint of vrange.
   out = mean(vrange);
end
