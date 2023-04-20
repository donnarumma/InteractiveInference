function KL_T1T2=getKL_T1T2(B1,B2)
[Nreps,Ntrials,~] = size(B1);
KL_T1T2=nan(Nreps,Ntrials);
for indRepetition=1:Nreps
    for iT=1:Ntrials
%             indTrial=indTrials(iT);
        h=squeeze(B1(indRepetition,iT,:));
        g=squeeze(B2(indRepetition,iT,:));
        KL_T1T2(indRepetition,iT) = -sum( h.*log(g./h) );
    end
end
