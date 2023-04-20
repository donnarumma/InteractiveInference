%% function pathsLoad_Djoint(spm_dir)
function p=pathsLoad_Djoint(spm_dir)
p   ='';
d       =';';
curdir  =cd;
try 
    p=[p,genpath(spm_dir)];
catch
    fprintf('Warning: spm directory not set.\n')
%     fprintf('Press a key to continue.\n'); pause;
end
p=[p, curdir '/models/'    d];
p=[p, curdir '/sim/'       d];
p=[p, curdir '/aux/'       d];
p=[p, curdir '/run/'       d];
p=[p, curdir '/mains/'     d];
p=[p, curdir '/utilities/' d];
p=[p, curdir '/show/'      d];
addpath (p);