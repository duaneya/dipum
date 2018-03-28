function v = showmo(cv, i)
%SHOWMO Displays the motion vectors of a compressed image sequence.
%   SHOWMO(CV, I) displayes the motion vectors for frame I of a
%   TIFS2CV compressed sequence of images.
%
%   See also TIFS2CV and CV2TIFS.

%   Copyright 2002-2009 R. C. Gonzalez, R. E. Woods, and S. L. Eddins
%   From the book Digital Image Processing Using MATLAB, 2nd ed.,
%   Gatesmark Publishing, 2009.
%
%   Book web site: http://www.imageprocessingplace.com
%   Publisher web site: http://www.gatesmark.com/DIPUM2e.htm

frms = double(cv.frames);
m = double(cv.blksz);
q = double(cv.quality);

if q == 0
    ref = double(huff2mat(cv.video(1)));
else
    ref = double(jpeg2im(cv.video(1)));
end

fsz = size(ref);
mvsz = [fsz/m 2 frms];
mv = int16(huff2mat(cv.motion));
mv = reshape(mv, mvsz);
v = zeros(fsz, 'uint8') + 128;

% Create motion vector image.    
for j = 1:mvsz(1) * mvsz(2)
        
	x1 = 1 + mod(m * (j - 1), fsz(1));
	y1 = 1 + m * floor((j - 1) * m / fsz(1));
        
	x2 = x1 - mv(1 + floor((x1 - 1) / m), ...
       1 + floor((y1 - 1) / m), 1, i);
	y2 = y1 - mv(1 + floor((x1 - 1) / m), ...
       1 + floor((y1 - 1) / m), 2, i);
        
    [x, y] = intline(x1, double(x2), y1, double(y2));
    for k = 1:length(x) - 1
        v(x(k), y(k)) = 255;
    end
    v(x(end), y(end)) = 0;
end

imshow(v);
