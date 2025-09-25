% ## Switches for invoking matlab.
% ## https://stackoverflow.com/questions/8981168/running-a-matlab-program-with-arguments
% ## Example:  matlab -nodisplay -nosplash -r progName args 

% ## Invoke code02b  arrayLength   numIterations

% function A = code02b(varargin)
    % arrayLength = varargin{1}
    % numIterations = varargin{2}

function aa = code02b(arrayLength, numIterations)

    outfile="mat.02b.out";

    fprintf('arrayLength: \n');
    disp (arrayLength);
    fprintf('numIterations: \n');
    disp (numIterations);
    fprintf('outfile: \n');
    disp (outfile);

    % N = 200000;
    N = arrayLength;
    r = gpuArray.linspace(1,100,N);
    % x = rand(1,N,"gpuArray");
    x = gpuArray.linspace(1,100,N);
    x = transpose(x);

    % numIterations = 1000;
    for n=1:numIterations
        x = r.*x.*(1-x);
    end

    % Write x to file.
    fid = fopen(outfile,'w');
    fprintf(fid,'%f\n',x);
    fclose(fid);


    % plot(r,x,'.',MarkerSize=1)
    % xlabel("Growth Rate")
    % ylabel("Population")

    % Return argument.
    aa="done";
end
