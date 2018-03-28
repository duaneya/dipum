function [t, measurement_overhead] = timeit(f)
%TIMEIT Measure time required to run function.
%   T = TIMEIT(F) measures the time (in seconds) required to run F, which is a
%   function handle. 
%
%   TIMEIT handles automatically the usual benchmarking procedures of "warming
%   up" F, figuring out how many times to repeat F in a timing loop, etc.
%   TIMEIT also compensates for the estimated time-measurement overhead
%   associated with tic/toc and with calling function handles.  TIMEIT returns
%   the median of several repeated measurements.
%
%   If nargout(F) == 0, TIMEIT calls F with no output arguments,
%   like this:
%
%       F()
%
%   If nargout(F) > 0, TIMEIT calls F with a single output argument, like this:
%
%       OUT = F()
%
%   If nargout(F) < 0, which can occur when F uses varargout or is an
%   anonymous function, TIMEIT uses try/catch to determine whether to call F
%   with one or zero output arguments.
%
%   Examples
%   --------
%   How much time does it take to compute sum(A.' .* B, 1), where A is
%   12000-by-400 and B is 400-by-12000?
%
%       A = rand(12000, 400);
%       B = rand(400, 12000);
%       f = @() sum(A.' .* B, 1);
%       timeit(f)
%
%   How much time does it take to dilate the text.png image with
%   a 25-by-25 all-ones structuring element? (This example uses Image Processing
%   Toolbox functions.)
%
%       bw = imread('text.png');
%       se = strel(ones(25, 25));
%       g = @() imdilate(bw, se);
%       timeit(g)
%

%   Steve Eddins
%   Copyright 2008-2009 The MathWorks, Inc.

num_f_outputs = numOutputs(f);
t_rough = roughEstimate(f, num_f_outputs);

% Calculate the number of inner-loop repetitions so that the inner for-loop
% takes at least about 1ms to execute.
desired_inner_loop_time = 0.001;
num_inner_iterations = max(ceil(desired_inner_loop_time / t_rough), 1);

% Run the outer loop enough times to give a reasonable set of inputs to median.
num_outer_iterations = 11;

% If the estimated running time for the timing loops is too long,
% reduce the number of outer loop iterations.
estimated_running_time = num_outer_iterations * num_inner_iterations * t_rough;
long_time = 15;
min_outer_iterations = 3;
if estimated_running_time > long_time
    num_outer_iterations = ceil(long_time / (num_inner_iterations * t_rough));
    num_outer_iterations = max(num_outer_iterations, min_outer_iterations);
end

times = zeros(num_outer_iterations, 1);

for k = 1:num_outer_iterations
    % Coding note: An earlier version of this code constructed an "outputs" cell
    % array, which was used in comma-separated form for the left-hand side of
    % the call to f().  It turned out, though, that the comma-separated output
    % argument added significant measurement overhead.  Therefore, the
    % zero-output-arg and one-output-arg cases were hard-coded into the separate
    % branches of the following if-statement.
    if num_f_outputs >= 1
        t1 = tic;
        for p = 1:num_inner_iterations
            output = f();
        end
        times(k) = toc(t1);
    else
        t1 = tic;
        for p = 1:num_inner_iterations
            f();
        end
        times(k) = toc(t1);
    end
end

t = median(times) / num_inner_iterations;
measurement_overhead = (tictocCallTime() / num_inner_iterations) + ...
    functionHandleCallOverhead(f);

t = max(t - measurement_overhead, 0);

if t < (5 * measurement_overhead)
    warning('timeit:HighOverhead', ...
        ['The measured time for F may be inaccurate because it is close ', ...
        'to the estimated time-measurement overhead (%.1e seconds).  Try ', ...
        'measuring something that takes longer.'], measurement_overhead);
end

function t = roughEstimate(f, num_f_outputs)
%   Return rough estimate of time required for one execution of
%   f().  Basic warmups are done, but no fancy looping, medians,
%   etc.

% Warm up tic/toc.
t1 = tic();
elapsed = toc(t1);
t1 = tic();
elapsed = toc(t1);

% Warm up f().  If the first call to f() takes more than a few seconds to run,
% then just use the result from that call.  The assumption is that first-time
% effects are negligible compared to the running time for f().  Otherwise,
% record the result of the third call as the rough estimate.
time_threshold = 3;
if num_f_outputs >= 1
    t1 = tic();
    output = f();
    t = toc(t1);
    if t > time_threshold
        return;
    end
    
    output = f();
    
    t1 = tic();
    output = f();
    t = toc(t1);
else
    t1 = tic();
    f();
    t = toc(t1);
    if t > time_threshold
        return;
    end
    
    f();
    
    t1 = tic();
    f();
    t = toc(t1);
end

% If the rough estimate is less than 1 ms, refine the estimate by iterating in a
% loop.
if t < 0.001
    num_iter = ceil(0.001 / t);
    if num_f_outputs >= 1
        t1 = tic();
        for k = 1:num_iter
            output = f();
        end
        t = toc(t1) / num_iter;
        
    else
        t1 = tic();
        for k = 1:num_iter
            f();
        end
        t = toc(t1) / num_iter;
    end
end

function n = numOutputs(f)
%   Return the number of output arguments to be used when calling the function
%   handle f.  
%   * If nargout(f) > 0, return 1.
%   * If nargout(f) == 0, return 0.
%   * If nargout(f) < 0, use try/catch to determine whether to call f with one
%     or zero output arguments.
%     Note: It is not documented (as of R2008b) that nargout can return -1.
%     However, it appears to do so for functions that use varargout and for
%     anonymous function handles.  

n = nargout(f);
if n < 0
   try
      a = f();
      % If the line above doesn't throw an error, then it's OK to call f() with
      % one output argument.
      n = 1;
      
   catch %#ok<CTCH>
      % If we get here, assume it's because f() has zero output arguments.  In
      % recent versions of MATLAB we could catch the specific exception ID
      % MATLAB:maxlhs, but that would limit the use of timeit to MATLAB versions
      % since the introduction of MExceptions.
      n = 0;
   end
end

function t = tictocCallTime
% Return the estimated time required to call tic/toc.

% Warm up tic/toc.
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);

num_repeats = 11;
times = zeros(1, num_repeats);

for k = 1:num_repeats
   times(k) = tictocTimeExperiment();
end

t = min(times);

function t = tictocTimeExperiment
% Call tic/toc 100 times and return the average time required.

% Record starting time.
t1 = tic;

% Call tic/toc 100 times.
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);
temp = tic; elapsed = toc(temp);

t = toc(t1) / 100;

function emptyFunction()

function t = functionHandleCallOverhead(f)
% Return the estimated overhead, in seconds, for calling a function handle
% compared to calling a normal function.

fcns = functions(f);
if strcmp(fcns.type, 'simple')
    t = simpleFunctionHandleCallTime();
else
    t = anonFunctionHandleCallTime();
end

t = max(t - emptyFunctionCallTime(), 0);

function t = simpleFunctionHandleCallTime
% Return the estimated time required to call a simple function handle to a
% function with an empty body.
%
% A simple function handle fh has the form @foo.

num_repeats = 101;
% num_repeats chosen to take about 100 ms, assuming that
% timeFunctionHandleCall() takes about 1 ms.
times = zeros(1, num_repeats);

fh = @emptyFunction;

% Warm up fh().
fh();
fh();
fh();

for k = 1:num_repeats
   times(k) = functionHandleTimeExperiment(fh);
end

t = min(times);

function t = anonFunctionHandleCallTime
% Return the estimated time required to call an anonymous function handle that
% calls a function with an empty body.
%
% An anonymous function handle fh has the form @(arg_list) expression. For
% example:
%
%       fh = @(thetad) sin(thetad * pi / 180)

num_repeats = 101;
% num_repeats chosen to take about 100 ms, assuming that timeFunctionCall()
% takes about 1 ms.
times = zeros(1, num_repeats);

fh = @() emptyFunction();

% Warm up fh().
fh();
fh();
fh();

for k = 1:num_repeats
   times(k) = functionHandleTimeExperiment(fh);
end

t = min(times);

function t = functionHandleTimeExperiment(fh)
% Call the function handle fh 2000 times and return the average time required.

% Record starting time.
t1 = tic;

fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();

fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();

fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();

fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();

fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();

fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();

fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();

fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();

fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();

fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();

fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();

fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();

fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();

fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();

fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();

fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();

fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();

fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();

fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();

fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();
fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh(); fh();

t = toc(t1) / 2000;

function t = emptyFunctionCallTime()
% Return the estimated time required to call a function with an empty body.

% Warm up emptyFunction.
emptyFunction();
emptyFunction();
emptyFunction();

num_repeats = 101;
% num_repeats chosen to take about 100 ms, assuming that timeFunctionCall()
% takes about 1 ms.
times = zeros(1, num_repeats);

for k = 1:num_repeats
   times(k) = emptyFunctionTimeExperiment();
end

t = min(times);

function t = emptyFunctionTimeExperiment()
% Call emptyFunction() 2000 times and return the average time required.

% Record starting time.
t1 = tic;

emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();

emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();

emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();

emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();

emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();

emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();

emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();

emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();

emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();

emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();

emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();

emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();

emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();

emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();

emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();

emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();

emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();

emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();

emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();

emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();

emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();
emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction(); emptyFunction();

t = toc(t1) / 2000;


