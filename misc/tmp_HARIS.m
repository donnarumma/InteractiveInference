nfGK=load ('OPEN_LF_A15050C_A25050_SIM_CA_P2KL_POLICIES.mat');


GK1=nfGK.GK1;
polInfo                             = DjointPolicies();

indSHORT                            = polInfo.P_INDEX(:,polInfo.COL_STRATEGY1)==polInfo.SHORT;
[NRepetitions, Ntrials, Np]         = size(GK1);
GexpSHORT                           = nan(NRepetitions, Ntrials);
GexpSIGN                            = nan(NRepetitions, Ntrials);
for indRep = 1:NRepetitions
    for indTrial = 1:Ntrials
        G                           = squeeze(GK1(indRep,indTrial,:));
        pG                          = spm_softmax(G);
        pGSHORT                     = sum(pG(indSHORT));
        pGSIGN                      = sum(pG(~indSHORT));
        GexpSHORT(indRep,indTrial)  = pGSHORT;
        GexpSIGN(indRep,indTrial)   = pGSIGN;
%         out=visual_trace_free_energy(test_name,indRep,indTrial,1,1,test_dir);
        fprintf('Rep %g/%g, Trial %g/%g',indRep,NRepetitions,indTrial,Ntrials);
        fprintf('\n');

    end
end

test_name   ='OPEN_LF_A15050C_A25050_SIM_CA_P1';

save_dir    =['~/tmp/DJOINT/' test_name];
results_dir =['results_djoint/' test_name];

nf          =['experiment_' test_name];
flexp       =load ([results_dir '/' nf]);
experiment  =flexp.experiment;

EntropyCB1  = nan(NRepetitions, Ntrials);
EntropyCB2  = nan(NRepetitions, Ntrials);
indCB       = 1;
for indRep=1:NRepetitions
    for indTrial=1:Ntrials
        CB1=experiment.rep{indRep}.results{indTrial}.ContextBelief{1}(:,indCB);
        CB2=experiment.rep{indRep}.results{indTrial}.ContextBelief{2}(:,indCB);
        EntropyCB1(indRep,indTrial) = -sum(CB1 .* log2(CB1));
        EntropyCB2(indRep,indTrial) = -sum(CB2 .* log2(CB2));
        fprintf('Repetition %g/%g, Trial %g/%g, CB=[%g, %g,%g,%g], E(CB)=%g\n', ...
                         indRep,                      ...
                         NRepetitions,                ...
                         indTrial,                    ...
                         Ntrials,                     ...
                         CB1(1),CB1(2),CB1(3),CB1(4), ...
                         EntropyCB1(indRep,indTrial));
        pause
%         Entropy = -sum(p .* log2(p);
    end
end
return
close all; 
hm=10; 
figure; hold on;
for i=1:1
    X=GexpSHORT(i,1:hm);
    Y=EntropyCB1(i,1:hm);
    plot(X,Y,'o'); 
end


