function [r, R, S] = imnoise3(M, N, C, A, B)
%IMNOISE3 Generates periodic noise.
%	[r, R, S] = IMNOISE3(M, N, C, A, B), generates a spatial
%	sinusoidal noise pattern, r, of size M-by-N, its Fourier
%	transform, R, and spectrum, S.  The remaining parameters are:
%
%	C is a K-by-2 matrix with K pairs of frequency domain
%	coordinates (u, v) that define the locations of impulses in the
%	frequency domain. The locations are with respect to the
%	frequency rectangle center at [floor(M/2) + 1, floor(N/2) + 1],
%	where the use of function floor is necessary to guarantee that
%	all values of (u, v) are integers, as required by all Fourier
%	formulations in the book. The impulse locations are specified as
%	integer increments with respect to the center. For example, if M
%	= N = 512, then the center is at (257, 257). To specify an
%	impulse at (280, 300) we specify the pair (23, 43); i.e., 257 +
%	23 = 280, and 257 + 43 = 300. Only one pair of coordinates is
%	required for each impulse. The conjugate pairs are generated
%	automatically.  
%
%	A is a 1-by-K vector that contains the amplitude of each of the
%	K impulse pairs. If A is not included in the argument, the
%	default used is A = ONES(1, K).  B is then automatically set to
%	its default values (see next paragraph).  The value specified
%	for A(j) is associated with the coordinates in C(j, :). 
%
%	B is a K-by-2 matrix containing the Bx and By phase components
%	for each impulse pair.  The default value for B is zeros(K, 2).

%   Copyright 2002-2009 R. C. Gonzalez, R. E. Woods, and S. L. Eddins
%   From the book Digital Image Processing Using MATLAB, 2nd ed.,
%   Gatesmark Publishing, 2009.
%
%   Book web site: http://www.imageprocessingplace.com
%   Publisher web site: http://www.gatesmark.com/DIPUM2e.htm

% Process input parameters.
K = size(C, 1);
if nargin < 4
   A = ones(1, K);
end
if nargin < 5
   B = zeros(K, 2);
end

% Generate R.
R = zeros(M, N);
for j = 1:K
   % Based on the equation for R(u, v), we know that the first term
   % of R(u, v) associated with a sinusoid is 0 unless u = -u0 and
   % v = -v0:
   u1 = floor(M/2) + 1 - C(j, 1); 
   v1 = floor(N/2) + 1 - C(j, 2);
   R(u1, v1) = i*M*N*(A(j)/2) * exp(-i*2*pi*(C(j, 1)*B(j, 1)/M ...
					+ C(j, 2)*B(j, 2)/N));
   % Conjugate. The second term is zero unless u = u0 and v = v0:
   u2 = floor(M/2) + 1 + C(j, 1); 
   v2 = floor(N/2) + 1 + C(j, 2);
   R(u2, v2) = -i*M*N*(A(j)/2) * exp(i*2*pi*(C(j, 1)*B(j, 1)/M ...
					+ C(j, 2)*B(j, 2)/N));
end

% Compute spectrum and spatial sinusoidal pattern.
S = abs(R);
r = real(ifft2(ifftshift(R)));
