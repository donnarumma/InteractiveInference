%% function params=loadTrialRepetition(test_name,indRepetition,indTrial,test_dir)

function params=loadTrialRepetition(test_name,indRepetition,indTrial,test_dir)

try
    test_dir;
catch
    test_dir ='~/tmp/tests_djoint/';
end
%% n

sindTrial     =fromNumToOrderedString(indTrial,100);
sindRepetition=fromNumToOrderedString(indRepetition,indRepetition*10);

sub_name      = [test_name '_TEST_' sindRepetition];
djname        = [test_dir test_name '/Djoint_' sub_name '/Djoint_' sub_name '_' sindTrial];
fprintf('Loading %s\n',djname)
cc            = load(djname);
params        = cc.params;
