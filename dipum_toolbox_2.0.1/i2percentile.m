function P = i2percentile(h, I)
%I2PERCENTILE Computes a percentile given an intensity value.
%	P = I2PERCENTILE(H, I) Given an intensity value, I, and a
%	histogram, H, this function computes the percentile, P, that I
%	represents for the population of intensities governed by
%	histogram H. I must be in the range [0, 1], independently of the
%	class of the image from which the histogram was obtained. P is
%	returned as a value in the range [0 1]. To convert it to a
%	percentile multiply it by 100. By definition, I = 0 represents
%	the 0th percentile and I = 1 represents 100th percentile.
%
%   Example:
%   
%   Suppose that h is a uniform histogram of an uint8 image. Typing
%
%       P = i2percentile(h, 127/255)
%
%   would return P = 0.5, indicating that the input intensity
%   is in the 50th percentile.
%
%   See also function percentile2i.

%   Copyright 2002-2009 R. C. Gonzalez, R. E. Woods, and S. L. Eddins
%   From the book Digital Image Processing Using MATLAB, 2nd ed.,
%   Gatesmark Publishing, 2009.
%
%   Book web site: http://www.imageprocessingplace.com
%   Publisher web site: http://www.gatesmark.com/DIPUM2e.htm

% Normalized the histogram to unit area. If it is already normalized
% the following computation has no effect.
h = h/sum(h);

% Calculations.
K = numel(h) - 1;
C = cumsum(h); % Cumulative distribution.
if I < 0 || I > 1 
    error('Input intensity must be in the range [0, 1].')
elseif I == 0
   P = 0; % Per the definition of percentile.
elseif I == 1
   P = 1; % Per the definition of percentile.
else
   idx = floor(I*K) + 1;
   P = C(idx);
end



   
   
   

   






