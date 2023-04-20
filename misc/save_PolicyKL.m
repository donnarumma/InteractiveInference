function [KL_POLICIES, GK1, GK2]=save_PolicyKL(test_name,test_dir,save_dir)
%% function [KL_POLICIES, GK1, GK2]=save_PolicyKL(test_name,test_dir,save_dir)
% test_name = 'OPEN_LF_A15050C_A25050_SIM_CA_P2';
% test_name = 'OPEN_A15050_A25050_SIM_CA_P2';
% 
try
    test_dir;
catch
    test_dir  = '~/tmp/tests_djoint/';
end
try
    save_dir;
catch
    save_dir       =['./results_djoint/' test_name '/'];
end
time            = 1;
isvisible       = 0;

Repetitions     = 100:199;
Trials          = 1:30;

% Repetitions     = 100:101;
% Trials          = 1:3;

NReps           = length(Repetitions);
NTrials         = length(Trials);
KL_POLICIES     = nan(NReps,NTrials);

params          = loadTrialRepetition(test_name,Repetitions(1),Trials(1),test_dir);
priorparams     = params.custom_maze();
Np              = length(priorparams.policy_labels);
        
GK1             = nan(NReps,NTrials,Np);
GK2             = nan(NReps,NTrials,Np);
% EXPETED_FREE    =          
for iR = 1:NReps
    indRepetition = Repetitions(iR);
% indRepetition   = 100;
% indTrial        = 1;
    for indTrial=Trials 
        params          = loadTrialRepetition(test_name,indRepetition,indTrial,test_dir);
        
        
        
%         origlabels      = priorparams.policy_labels;
        
        
        
        %% distribution of policies on Agent 1
        indAgent        = 1;
        permV           = params.(['permV' num2str(indAgent)]);
        mdp_iT          = params.mdp{indAgent}{end};
        original        = priorparams.(['V' num2str(indAgent)]);
        permutated      = params.(['V' num2str(indAgent)]);
        
        invperm         = getInvperm(original,permutated);
        out             = Djoint_single_visual_trace_t(mdp_iT,time,params.custom_maze,permV,isvisible);
        GF              = out.G(invperm);
        
        G1              = nan(Np,1);
        for k=1:Np
            G1(k)=sum(GF{k}(:));
        end
        
        %% distribution of policies on Agent 2
        indAgent        = 2;
        permV           = params.(['permV' num2str(indAgent)]);
        mdp_iT          = params.mdp{indAgent}{end};
        original        = priorparams.(['V' num2str(indAgent)]);
        permutated      = params.(['V' num2str(indAgent)]);
        
        invperm         = getInvperm(original,permutated);
        out             = Djoint_single_visual_trace_t(mdp_iT,time,params.custom_maze,permV,isvisible);
        GF              = out.G(invperm);
        
        Np              = length(GF);
        G2              = nan(Np,1);
        for k=1:Np
            G2(k)=sum(GF{k}(:));
        end
        
        h               = G1;
        g               = G2;
        KL_POLICIES(iR,indTrial) = -sum( h.*log(g./h) );
        GK1(iR,indTrial,:)     = G1;
        GK2(iR,indTrial,:)     = G2;
        
        close all;
    end
end

fn=[test_name 'KL_POLICIES'];
save([save_dir fn],'KL_POLICIES','GK1','GK2');
% labels          = out.labels(invperm);