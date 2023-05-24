%% function pathsLoad_Djoint(spm_dir)
function p=pathsLoad_Djoint(spm_dir)
p   =  '';
d       = pathsep; % on linux ':', on windows ';' 
S       = filesep; % on linux '\', on windows '/' 
curdir  =cd;
try 
    p=[p,genpath(spm_dir)];
catch
    fprintf('Warning: spm directory not set.\n')
%     fprintf('Press a key to continue.\n'); pause;
end
p=[p, curdir S 'models'     S d];
p=[p, curdir S 'sim'        S d];
p=[p, curdir S 'misc'       S d];
p=[p, curdir S 'run'        S d];
p=[p, curdir S 'mains'      S d];
p=[p, curdir S 'utilities'  S d];
p=[p, curdir S 'show'       S d];
addpath (p);