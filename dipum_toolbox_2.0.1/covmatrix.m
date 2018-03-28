function [C, m] = covmatrix(X)
%COVMATRIX Computes the covariance matrix and mean vector.
%   [C, M] = COVMATRIX(X) computes the covariance matrix C and the
%   mean vector M of a vector population organized as the rows of
%   matrix X. This matrix is of size K-by-N, where K is the number
%   of samples and N is their dimensionality. C is of size N-by-N
%   and M is of size N-by-1. If the population contains a single
%   sample, this function outputs M = X and C as an N-by-N matrix of
%   NaN's because the definition of an unbiased estimate of the
%   covariance matrix divides by K - 1.

%   Copyright 2002-2009 R. C. Gonzalez, R. E. Woods, and S. L. Eddins
%   From the book Digital Image Processing Using MATLAB, 2nd ed.,
%   Gatesmark Publishing, 2009.
%
%   Book web site: http://www.imageprocessingplace.com
%   Publisher web site: http://www.gatesmark.com/DIPUM2e.htm

K = size(X, 1);
X = double(X);
% Compute an unbiased estimate of m.
m = sum(X, 1)/K;
% Subtract the mean from each row of X.
X = X - m(ones(K, 1), :);
% Compute an unbiased estimate of C. Note that the product is X'*X
% because the vectors are rows of X.	
C = (X'*X)/(K - 1);
m = m'; % Convert to a column vector.	 

