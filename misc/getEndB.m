function [endB1,endB2]=getEndB(experiment,indTrials)
%% function [endB1,endB2]=getEndB(experiment,indTrials)

NC           =size(experiment.rep{1}.results{1}.ContextBelief{1},1);
Nreps        =length(experiment.rep);
Ntrials      =length(indTrials);
% Ntrials      =length(experiment.rep{1}.results);
% indTrials    =1:5;


endB1        =nan(Nreps,Ntrials,NC);
endB2        =nan(Nreps,Ntrials,NC);
% indTrials    =1:Ntrials;
for indRepetition=1:Nreps
    for iT=1:Ntrials
        indTrial=indTrials(iT);
        endB1(indRepetition,iT,:)=squeeze(experiment.rep{indRepetition}.rjstats.ContextBelief(1,indTrial,:,end));
        endB2(indRepetition,iT,:)=squeeze(experiment.rep{indRepetition}.rjstats.ContextBelief(2,indTrial,:,end));
    end
end
