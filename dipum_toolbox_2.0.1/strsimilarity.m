function R = strsimilarity(a, b)
%STRSIMILARITY Computes a similarity measure between two strings.
%   R = STRSIMILARITY(A, B) computes the similarity measure, R,
%   defined in Section 13.4.2 for strings A and B. The strings do
%   not have to be of the same length, but only one of the strings
%   can have blanks, and these must be trailing blanks. Blanks are
%   not counted when computing the length of the strings for use in
%   the similarity measure.  

%   Copyright 2002-2009 R. C. Gonzalez, R. E. Woods, and S. L. Eddins
%   From the book Digital Image Processing Using MATLAB, 2nd ed.,
%   Gatesmark Publishing, 2009.
%
%   Book web site: http://www.imageprocessingplace.com
%   Publisher web site: http://www.gatesmark.com/DIPUM2e.htm

% Verify that a and b are character strings.
if ~ischar(a) || ~ischar(b)
   error('Inputs must be character strings.')
end

% Work with horizontal strings.
a = a(:)';
b = b(:)';

% Find any blank spaces.
I = find(a == ' ');
J = find(b == ' ');
LI = numel(I); % LI and LJ are used later. 
LJ = numel(J);
% Check to see if one of the strings is blank, in which case R = 0.
if LI == length(a) || LJ == length(b)
   R = 0;
   return
end
   
if (LI ~= 0 && I(1) == 1) ||(LJ ~= 0 && J(1) == 1)
   error('Strings cannot contain leading blanks.')
end

if LI ~= 0 && LJ ~= 0
   error('Only one of the strings can contain blanks.')
end

% Pad the end of the shorter string. 
La = length(a); 
Lb = length(b);
if LI == 0 && LJ == 0
   if La > Lb
      b = [b, blanks(La - Lb)];
   else 
      a = [a, blanks(Lb - La)];
   end
elseif isempty(J)
   Lb = length(b) - length(J);
   b = [b, blanks(La - Lb - LJ)];
else
   La = length(a) - length(I);
   a = [a, blanks(Lb - La - LI)];
end

% Compute the similarity measure.
I = find(a == b);
alpha = numel(I);
den = max(La, Lb) - alpha;
if den == 0 
   R = Inf;
else 
   R = alpha/den; 
end
