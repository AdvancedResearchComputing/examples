parpool('threads');
%Setting the number of workers is not supported when creating thread-based parallel pools. To do so, you need to use the ‘local’ pool.

%parpool('local',4);
tic
start = tic;
clear A
parfor i = 1:100000000
        A(i) = i;
end
pend = toc(start);
pend
fprintf('time it takes is %12.9f secs\n',pend)
toc

delete(gcp('nocreate'));
%matlabpool('close');
