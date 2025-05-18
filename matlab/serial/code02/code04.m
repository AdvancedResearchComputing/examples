% ## Switches for invoking matlab.
% ## https://stackoverflow.com/questions/8981168/running-a-matlab-program-with-arguments
% ## Example:  matlab -nodisplay -nosplash -r progName args 

% ## Invoke code02  arrayLength   numIterations

% function A = code02(varargin)
    % arrayLength = varargin{1}
    % numIterations = varargin{2}

% This function is now for CPU, not GPU.
% Slight modifications below
% to set up r and x.
% function aa = code04(arrayLength, numIterations, outfile)
function aa = code04(arrayLength, numIterations)

    % Put output file name in code; have problems passing it in.
    outfile = "mat.out"

    fprintf('arrayLength: \n');
    disp (arrayLength);
    fprintf('numIterations: \n');
    disp (numIterations);
    fprintf('outfile: \n');
    disp (outfile);

    % N = 200000;
    N = arrayLength;
    r = linspace(1,100,N);
    % x = rand(1,N);
    x = linspace(1,100,N);
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
