function showExecution(test_name,indRepetition,indTrial,test_dir)
%% function showExecution(test_name,indRepetition,indTrial,test_dir)
% example: 
% test_name     ='OPEN_A15050_A25050';
% test_dir      ='~/tmp/DJOINT/tests_djoint/';
% indRepetition =100;
% indTrial      =1;
% showExecution(test_name,indRepetition,indTrial,test_dir);
params        =loadTrialRepetition(test_name,indRepetition,indTrial,test_dir);
params.wo     =[0,0,1,0]; % show trial execution and create hand-movie
showResults_Djoint(params);