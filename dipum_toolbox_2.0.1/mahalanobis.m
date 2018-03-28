function D = mahalanobis(varargin)
%MAHALANOBIS Computes the Mahalanobis distance.
%   D = MAHALANOBIS(Y, X) computes the Mahalanobis distance between
%   each vector in Y to the mean (centroid) of the vectors in X, and
%   outputs the result in vector D, whose length is size(Y, 1). The
%   vectors in X and Y are assumed to be organized as rows. The
%   input data can be real or complex. The outputs are real
%   quantities.
%
%   D = MAHALANOBIS(Y, CX, MX) computes the Mahalanobis distance
%   between each vector in Y and the given mean vector, MX. The
%   results are output in vector D, whose length is size(Y, 1). The
%   vectors in Y are assumed to be organized as the rows of this
%   array. The input data can be real or complex. The outputs are
%   real quantities. In addition to the mean vector MX, the
%   covariance matrix CX of a population of vectors X must be
%   provided also. Use function COVMATRIX (Section 12.5) to compute
%   MX and CX.

%   Copyright 2002-2009 R. C. Gonzalez, R. E. Woods, and S. L. Eddins
%   From the book Digital Image Processing Using MATLAB, 2nd ed.,
%   Gatesmark Publishing, 2009.
%
%   Book web site: http://www.imageprocessingplace.com
%   Publisher web site: http://www.gatesmark.com/DIPUM2e.htm

% Reference: Acklam, P. J. [2002]. "MATLAB Array Manipulation Tips
% and Tricks," available at
%     home.online.no/~pjacklam/matlab/doc/mtt/index.html 
% or in the Tutorials section at
%     www.imageprocessingplace.com

param = varargin; % Keep in mind that param is a cell array.
Y = param{1};

if length(param) == 2
   X = param{2};
   % Compute the mean vector and covariance matrix of the vectors
   % in X.
   [Cx, mx] = covmatrix(X);
elseif length(param) == 3 % Cov. matrix and mean vector provided.
   Cx = param{2};
   mx = param{3};
else 
   error('Wrong number of inputs.')
end
mx = mx(:)'; % Make sure that mx is a row vector for the next step.

% Subtract the mean vector from each vector in Y.
Yc = bsxfun(@minus, Y, mx);	

% Compute the Mahalanobis distances.
D = real(sum(Yc/Cx.*conj(Yc), 2));
