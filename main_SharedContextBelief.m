%% function main_SharedContextBelief()

%% new
% (1) main_Djoint_OPEN_A15050_A25050_TEST100        FOLLOWER-FOLLOWER
% (2) main_Djoint_OPEN_LF_A15050C_A25050_TEST100    LEADER-FOLLOWER RED
% (3) main_Djoint_OPEN_LF_A15050S_A25050_TEST100    LEADER-FOLLOWER BLUE
% (4) main_Djoint_OPEN_LF_A15050C_A25050_KL_TEST100 LEADER-FOLLOWER KL ONLY
% (5) main_Djoint_OPEN_A15050_A25050_RL_TEST100     FOLLOWER-FOLLOWER RL
%% alpha
% (1) main_Djoint_OPEN_A15050_A25050_ALPHA_TEST100
% (2) main_Djoint_OPEN_LF_A15050C_A25050_ALPHA_TEST100
% (3) main_Djoint_OPEN_LF_A15050S_A25050_ALPHA_TEST100
% (4) main_Djoint_OPEN_LF_A15050C_A25050_KL_ALPHA_TEST100
% (5) main_Djoint_OPEN_A15050_A25050_RL_ALPHA_TEST100
%% original
% (1) main_Djoint_OPEN_A15050_A25050_ORIGINAL_TEST100
% (2) main_Djoint_OPEN_LF_A15050C_A25050_ORIGINAL_TEST100
% (3) main_Djoint_OPEN_LF_A15050S_A25050_ORIGINAL_TEST100
% (4) main_Djoint_OPEN_LF_A15050C_A25050_KL_ORIGINAL_TEST100
% (5) main_Djoint_OPEN_A15050_A25050_RL_ORIGINAL_TEST100 
%%
% main_Djoint_OPEN_A15050_A25050_SHOW_TEST3;  % show changing belief on 100 trials
% main_Djoint_OPEN_LF_A15050C_A25050_SIM_CA_P1_TEST100;  % leader (circle) follower 
% main_Djoint_OPEN_LF_A15050S_A25050_SIM_CA_P1_TEST100;  % leader (square) follower 
% main_Djoint_OPEN_A15050_A25050_SIM_CA_P1_TEST100;      % follower follower
% main_Djoint_OPEN_LF_A15050C_A25050_CONTRA_TEST100;     % only KL
% main_Djoint_OPEN_A15050_A25050_RL_TEST100;             % Reinforcement Learning A{2} 

%% Follower Follower F-F
test_name='OPEN_A15050_A25050_SIM_CA_P1';

%% Leader-Follower red (circle in the code)
test_name='OPEN_LF_A15050C_A25050_SIM_CA_P1/';
%% Leader-Follower blue (square in the code)
test_name='OPEN_LF_A15050S_A25050_SIM_CA_P1/';

%% Leader-Follower red - only KL
test_name='OPEN_LF_A15050C_A25050_CONTRA';

%% Follower-Follower - RL mode without saliency and context update 
test_name='OPEN_A15050_A25050_RL';

Save_Statitical_Results(test_name);

indRepetition=100;indTrial=1;
params=loadTrialRepetition(test_name,indRepetition,indTrial);

ecode   = StatsFEvsEntropy(1000,params);
save_Policy(KL(test_name);%tmp_PolicyKL(test_name,test_dir);

save_Entropy_figures(test_name,ecode,[false,true,false,false,false,true]);

paperFigures (test_name);  


