% ## Switches for invoking matlab.
% ## https://stackoverflow.com/questions/8981168/running-a-matlab-program-with-arguments
% ## Example:  matlab -nodisplay -nosplash -r progName args 

% ## Invoke code02  arrayLength   numIterations

% function A = code02(varargin)
    % arrayLength = varargin{1}
    % numIterations = varargin{2}

function aa = code02(arrayLength, numIterations)

    fprintf('arrayLength: \n');
    disp (arrayLength);
    fprintf('numIterations: \n');
    disp (numIterations);

    % N = 200000;
    N = arrayLength;
    r = gpuArray.linspace(0,4,N);
    x = rand(1,N,"gpuArray");

    % numIterations = 1000;
    for n=1:numIterations
        x = r.*x.*(1-x);
    end

    % plot(r,x,'.',MarkerSize=1)
    % xlabel("Growth Rate")
    % ylabel("Population")

    % Return argument.
    aa="done";
end
