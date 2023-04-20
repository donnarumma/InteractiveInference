% function tmp_memory
function MB=tmp_memory
[~, pid] = system('pgrep MATLAB');
npid=strtrim(pid);
[~, mem_usage] = system(['cat /proc/' npid '/status | grep VmSize']);
%  nmem_usage=strtrim(mem_usage);
%  matlab_mem=strtrim(extractAfter(extractBefore(mem_usage, ' kB'),':'));
MB=round(str2double(strtrim(extractAfter(extractBefore(mem_usage, ' kB'), ':'))) / 1000);
if ~isnan(MB)
    fprintf("%i MB\n", MB);
end