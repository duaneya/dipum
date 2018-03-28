function Qa = aggfcn(Q)
%AGGFCN Aggregation function for a fuzzy system.
%   QA = AGGFCN(Q) creates an aggregation function, QA, from a
%   set of implication functions, Q. Q is a cell array of function
%   handles as returned by IMPLFCNS. QA is a function handle that
%   can be called with a single input V using the syntax:
%
%       q = QA(V)

%   Copyright 2002-2009 R. C. Gonzalez, R. E. Woods, and S. L. Eddins
%   From the book Digital Image Processing Using MATLAB, 2nd ed.,
%   Gatesmark Publishing, 2009.
%
%   Book web site: http://www.imageprocessingplace.com
%   Publisher web site: http://www.gatesmark.com/DIPUM2e.htm

Qa = @aggregate;

    function q = aggregate(v)
        q = Q{1}(v);
        for i = 2:numel(Q)
            q = max(q, Q{i}(v));
        end
    end

end
