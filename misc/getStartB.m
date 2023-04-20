function [startB1,startB2]=getStartB(experiment,indTrials)
%% function [startB1,startB2]=getStartB(experiment,indTrials)

NC           =size(experiment.rep{1}.results{1}.ContextBelief{1},1);
Nreps        =length(experiment.rep);
Ntrials      =length(indTrials);

startB1      =nan(Nreps,Ntrials,NC);
startB2      =nan(Nreps,Ntrials,NC);

iS           =2; %%First inference LF (% iS           =1;)

for indRepetition=1:Nreps
    for iT=1:Ntrials
        indTrial=indTrials(iT);
        startB1(indRepetition,iT,:)=squeeze(experiment.rep{indRepetition}.rjstats.ContextBelief(1,indTrial,:,iS));
        startB2(indRepetition,iT,:)=squeeze(experiment.rep{indRepetition}.rjstats.ContextBelief(2,indTrial,:,iS));
    end
end
