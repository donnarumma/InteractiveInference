function Save_Statitical_Results(test_name,trials,indRepetitions,test_dir,results_dir)

try
    test_name;
catch
    test_name='OPEN_A15050_A25050_SIM_CA_P1';
    test_name='OPEN_LF_A15050C_A25050_SIM_CA_P1/';
    test_name='OPEN_A15050_A25050_CONTRA';
    test_name='OPEN_LF_A15050C_A25050_CONTRA';
    test_name='OPEN_A15050_A25050_SIM_CA_P2';
    test_name='OPEN_A15050_A25050_RL';
end
try
    trials;
catch
    trials=1:30;
end
% indRep   =1;
% test_dir ='~/pCloudDrive/tmp/tests_djoint/';
try
    indRepetitions;
catch
    indRepetitions=100:199;
end
try
    test_dir;
catch
    test_dir ='~/tmp/tests_djoint/';
%     test_dir ='~/tmp/tests_djoint_deb/';
end    
%test_name='OPEN_LF_A15050C_A25050_SIM_CA_P1';
try
    results_dir;
catch
    results_dir=['results_djoint/' test_name];
end
% indTrial =108;
Nrep=length(indRepetitions);
experiment.rep=cell(1,Nrep);

for indR=1:Nrep
    indRepetition=indRepetitions(indR);
    N       =length(trials);
    Ts      =nan(N,1);
    TsB     =nan(N,1);

    for indTrial=trials
        params   =loadTrialRepetition(test_name,indRepetition,indTrial,test_dir);


        ndj.results{indTrial}      =getRepetitionResults_Djoint(params);

        iT=1; t=1;
        ndj.out {indTrial}=Djoint_single_trace_style_t(params.mdp{iT}{end},1,t,5,iT);
        iT=2; t=1;
        ndj.out2{indTrial}=Djoint_single_trace_style_t(params.mdp{iT}{end},1,t,5,iT);
    end

    for n=1:N
        Ts(n)   =sum(ndj.results{n}.S{1}>0);
        TsB(n)  =sum(sum(ndj.results{n}.ContextBelief{1},1)>0.5);
    end
    T       =sum(Ts);
    TB      =sum(TsB);

    ndj.Ts =Ts;
    ndj.TsB=TsB;

    % return
    % S1=nan(N,max(Ts)); 
    % S2=nan(N,max(Ts));
    % NC=4;
    % Nagents=2;
    % ContextBelief=nan(Nagents,N,NC,max(TsB));
    ndj.jstats=getStatistics_Djoint_Plus(ndj,[0,0,0,0,0,0,0],params);

    minTsB=min(TsB);
    maxTsB=max(TsB);
    minTs=min(Ts);
    maxTs=max(Ts);
    rjstats=ndj.jstats;
    for iTs=minTs:(maxTs-1)
        rTs=iTs+1;
        rjstats.S1(ndj.Ts<rTs,rTs)=rjstats.S1(ndj.Ts<rTs,iTs);
        rjstats.S2(ndj.Ts<rTs,rTs)=rjstats.S2(ndj.Ts<rTs,iTs);
    end

    for iTsB= minTsB:(maxTsB-1)
        rTsB=iTsB+1;
        rjstats.ContextBelief(:,ndj.TsB<rTsB,:,rTsB)=rjstats.ContextBelief(:,ndj.TsB<rTsB,:,iTsB);
    end
    ndj.rjstats=rjstats;
    ndj.indRepetition=indRepetition;
    experiment.rep{indR}=ndj;
    %% save results
    nf=['experiment_' test_name];
    fprintf('Save %s (Repetition %g/%g)\n',[results_dir '/' nf],indR,Nrep);
    save([results_dir '/' nf],'experiment');
end
return
iT=1;Djoint_single_visual_trace_t(mdp{iT}{end},t,@custom_simmetric_maze);
