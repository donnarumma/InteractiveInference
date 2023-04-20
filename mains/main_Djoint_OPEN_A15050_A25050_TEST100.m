% function main_Djoint_OPEN_A15050_A25050_TEST100
clearvars -except spm_dir; close all;
VARIABLES_Djoint;

params                                  = getLFmirrorparams(FOLLOWER,FOLLOWER,nan);
mf                                      = mfilename;
file_name                               = mf(6:end);
nm                                      = strsplit(file_name,'TEST');
iRepetition                             = str2num(nm{2});
%
description                             = sprintf('%sTEST_0%g',nm{1},iRepetition);
test_name                               = nm{1}(8:end-1);
%
[params, seeds]                         =initializeParams(description,test_name,iRepetition,params);

TESTS                                   =Simulation_Djoint(params,seeds);


%% get some graphical and struct results for each N test
dj.results=cell(length(TESTS),1);
for n=1:length(TESTS)
    params=TESTS{n};
    params.wo            =[0,0,0,0]; % save graphs
%     params.wo            =[1,1,1,1]; % save graphs

    dj.results{n}              = showResults_Djoint(params);
end
save([params.save_dir '/' params.description],'dj','-v7.3');

%% group together tests results
graphics_afterTests_open(params,spm_dir);

if params.sequenceon
    dmain=params.main_dir;
    addpath(dmain);
    if params.iRepetition==params.startIndex
        copyfile(['mains/main_' file_name '.m'],[dmain '/main_' file_name '.m']);
    end
    if params.iRepetition<params.startIndex+params.Repetitions-1 %+ 6 + 10 + 10
        newfilename=['main_' nm{1} 'TEST' num2str(params.iRepetition+1)];
        copyfile([dmain 'main_' file_name '.m'],[dmain  newfilename '.m']);
        run(newfilename);
    end
    rmpath(dmain);
end