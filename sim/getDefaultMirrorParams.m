function params=getDefaultMirrorParams
% function params=getDefaultMirrorParams

% 1 - square - blue   
% 0 - circle - red
% params.square   =true;
% params.circle   =~square;
% leader 1, follower 0
% params.leader   =true; 
% params.follower =false;                  % role code
% 
params.custom_maze                      = @custom_simmetric_maze_open;
params                                  = params.custom_maze(params);
params.T                                = params.Tt;
% params.status_certainty                 = @status_certainty;
% params.h_A=1;  params.K_A=6; params.status_certainty=@status_certainty_v2; % 0.50 (status_certainty)
params.h_A=4;  params.K_A=10;params.status_certainty=@status_certainty_v2; % 0.25
% params.h_A=1/3;params.K_A=6; params.status_certainty=@status_certainty_v2; % 0.75





params.N                                =30;  % Trials - total consecutive interactions
params.sequenceon                       =1;   % in the main, perform repetitions  until a number of params.Repetition is reached
params.Repetitions                      =100; % Repetitions (with different seeds)
params.startIndex                       =100; % default start from main 100 and end to main 199
params.ifdestroy                        =2; % 0 reload all trials found % 1 destroy and warn the destruction % 3 destroy
params.do_update_seed                   =1;   % select seeds for deterministic repetitions
params.do_update_context                =1;
params.ifshuffle                        =2;   % shuffle policies

params.belief_propagation               =1;
params.no_coactor_location_uncertainty  =0; 
params.nsplits                          =0;
params.lambda                           =0;%2.05;  % .95;  % 10
params.eta                              =0.5;
params.NoClue                           =0; % set 1 to disable A{2} matrix (RL emulation)

params.ActionList                       = getActionList(params.Nactions, params.Nagents);

params.case                             = 'FF';% sample bayesian policy
params.modality                         = 'FE'; %'FE' Free Energy | 'KL' KL diverenge only
c1=6; c2=6;
params.mirror_game                      =1;
params.forcemirrorC3                    =1;
params.cs{1}                            =[-c1; 5; c1];
params.cs{2}                            =[-c2; 5; c2];
%% verbose print
params.print                            = 1;
%% to plot 2D movie
params.sf                               = 'Step'; 
params.source_images                    = './show/';

params.default_dir                      ='~/tmp/DJOINT/';
% params.res_dir                          =[params.default_dir '/results_djoint/'];
% params.test_dir                         =[params.default_dir '/tests_djoint/'];
% params.movie_dir                        =[params.default_dir '/movie/'];
                           

%%
% initialize simulation parameters

% params.ichange                          =[1,15:params.N];   % trial of params change
params.ichange                          =[1:2:params.N];    % trial of params change

Nichanges                               =length(params.ichange);
params.whochange                        =true(Nichanges,params.Nagents);     % which agent change at ichange

params.bchange                          =false(Nichanges,params.Nagents);    % external belief change
params.bchange(1,:)                     =[1,1];                              % force agent change belief at trial 1

%%
return
