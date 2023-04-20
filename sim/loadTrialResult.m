%% function dj=loadTrialResult(test_name,indTrial,res_dir)

function dj=loadTrialResult(test_name,indTrial,res_dir)

% test_name='OPEN_LF_A15050S_A25050_SIM';
try
    res_dir;
catch
    res_dir    ='./results_djoint/';
end
%% n

sindTrial=fromNumToOrderedString(indTrial,indTrial*10);

sub_name    = [test_name '_TEST_' sindTrial];
djname      = [res_dir test_name '/Djoint_' sub_name '/Djoint_' sub_name];
cc          = load(djname);
fprintf('Loading %s\n',djname)
dj      =cc.dj;
