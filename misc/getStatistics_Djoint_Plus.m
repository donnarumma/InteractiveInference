%% function jstats=getStatistics_Djoint_Plus(dj,wo,params)
function jstats=getStatistics_Djoint_Plus(dj,wo,params)
vis=params.sequenceon;

results =dj.results;
N       =length(results);
Ts      =nan(N,1);
TsB     =nan(N,1);
for n=1:N
    Ts(n)   =sum(dj.results{n}.S{1}>0);
    TsB(n)  =sum(sum(results{n}.ContextBelief{1},1)>0.5);
end
T  =sum(Ts);
TB =sum(TsB);
px =0.5;
% collong =[0.3,0.2,0.7]; % blue
collong =[0.2892    0.6765    0.6841];
colshort=[0.7,0.3,0.2]; % brown

S1=nan(N,max(Ts)); 
S2=nan(N,max(Ts));
NC=4;
Nagents=2;
ContextBelief=nan(Nagents,N,NC,max(TsB));
for n=1:N
    res=results{n};
    S1(n,1:Ts(n))=res.S{1}(1:Ts(n));
    S2(n,1:Ts(n))=res.S{2}(1:Ts(n));
    CB=res.ContextBelief;
    for nc=1:NC
        ContextBelief(1,n,nc,1:TsB(n))=CB{1}(nc,1:TsB(n));
        ContextBelief(2,n,nc,1:TsB(n))=CB{2}(nc,1:TsB(n));
    end
end
jstats.S1=S1;
jstats.S2=S2;
jstats.ContextBelief=ContextBelief;
jstats.Ts=Ts;

cmaps        =linspecer(NC);
cmapsw       =cmaps;
cmapsw(4,:)  =cmaps(2,:);
cmapsw(2:3,:)=cmaps(3:4,:);
cmaps        =cmapsw;
markers={'o','d','*','o'};
if wo(1)
    %% plot means
    times=1:max(TsB);
    cmapsLight=lightCmaps(cmaps);

    hfig=figure; hold on; box on; grid on;
    p=[0,0,1500,600];
    fs=16;
    %% Agent 1
    subplot(2,1,1);
    mmCB=[];
    ssCB=[];
    for i=1:NC
        mmCB=[mmCB;nanmean(squeeze(jstats.ContextBelief(1,:,i,:)))];
        ssCB=[ssCB;nanstd(squeeze(jstats.ContextBelief(1,:,i,:)))];
    end
    for ind=1:NC
        ih=plotMeanAndVariance(mmCB(ind,:),ssCB(ind,:),times,cmaps(ind,:),cmaps(ind,:),cmapsLight(ind,:));
        a(ind)=ih.h(end-2);
    end
        
    title('Agent 1 Belief on goal')
    set(gca,'xtick',times);
    
    xlabel('Step');
    ylabel('Mean Prob');
    legend(a,'(Blue, Blue)','(Blue, Red)','(Red,Blue)','(Red, Red)');
    set(gca,'fontsize',fs);
    
    %% Agent 2
    
    subplot(2,1,2);
    mmCB=[];
    ssCB=[];
    for i=1:NC
        mmCB=[mmCB;nanmean(squeeze(jstats.ContextBelief(2,:,i,:)))];
        ssCB=[ssCB;nanstd(squeeze(jstats.ContextBelief(2,:,i,:)))];
    end
    for ind=1:NC
        ih=plotMeanAndVariance(mmCB(ind,:),ssCB(ind,:),times,cmaps(ind,:),cmaps(ind,:),cmapsLight(ind,:));
        a(ind)=ih.h(end-2);
    end    
    
    title('Agent 2 Belief on goal')
    set(gca,'xtick',times);
    xlabel('Step');
    ylabel('Mean Prob');
    legend(a,'(Blue, Blue)','(Blue, Red)','(Red, Blue)','(Red, Red)');
    set(gca,'fontsize',fs);
%     set(hfig,'visible','off');
    set(hfig, 'PaperPositionMode','auto');
    set(hfig,'Position',p);
    
    sf=[dj.save_dir '/' dj.description '_MB'];
    fprintf('Saving %s\n',sf);
    print(hfig,'-depsc2',[sf '.eps']);
    savefig(hfig,[sf '.fig']);
    convertEPS2PSD_cell({dj.save_dir});
end
if wo(2)
    %% plot all
    inf_labs={'(Blue, Blue)','(Blue, Red)','(Red,Blue)','(Red, Red)'};
    CB1=nan(NC,TB);
    CB2=nan(NC,TB);
    T0=0;
    Tsum=cumsum(TsB);
    for n=1:N
        CB1(:,(T0+1):Tsum(n))=squeeze(jstats.ContextBelief(1,n,:,1:TsB(n)));
        CB2(:,(T0+1):Tsum(n))=squeeze(jstats.ContextBelief(2,n,:,1:TsB(n)));
        T0=Tsum(n);
    end
    times=1:TB;

    hfig=figure; 
    p=[0,0,1500,600];
    fs=14;
    subplot(2,1,1); hold on; box on; grid on;
    CB=CB1;

    for n=1:N
        plot([Tsum(n),Tsum(n)],[0,1],'color',0.5*[1,1,1],'linewidth',5);
    end
    
    for ind=1:NC
        a(ind)=plot(times,CB(ind,:),'marker','o','linewidth',3,'color',cmaps(ind,:));
    end
        
    title('Agent 1 Belief on goal')
    
    NTICKS=20; DX=round(times(end)/NTICKS);
    
    set(gca,'xtick',0:DX:times(end));
    
    xlabel('Step');
    ylabel('Prob');
    xlim([1,TB]);
    legend(a,inf_labs);
    set(gca,'fontsize',fs);
    
    subplot(2,1,2); hold on; box on; grid on;
    CB=CB2;

    for n=1:N
        plot([Tsum(n),Tsum(n)],[0,1],'color',0.5*[1,1,1],'linewidth',5);
    end
    
    for ind=1:NC
        a(ind)=plot(times,CB(ind,:),'marker','o','linewidth',3,'color',cmaps(ind,:));
    end
    
    title('Agent 2 Belief on goal')
    
    set(gca,'xtick',0:DX:times(end));
    xlabel('Step');
    ylabel('Prob');
    xlim([1,TB]);
    legend(a,inf_labs);
    set(gca,'fontsize',fs);
    set(hfig, 'PaperPositionMode','auto');
    set(hfig,'Position',p);
    
    sf=[dj.save_dir '/' dj.description '_TrialB'];
    fprintf('Saving %s\n',sf);
    print(hfig,'-depsc2',[sf '.eps']);
    savefig(hfig,[sf '.fig']);
    convertEPS2PSD_cell({dj.save_dir});
end


if wo(3)
    Npl=4;
    %% plot start end
    inf_labs={'(Blue, Blue)','(Blue, Red)','(Red,Blue)','(Red, Red)'};
    CB1_STR=nan(NC,N);
    CB1_END=nan(NC,N);
    CB2_STR=nan(NC,N);
    CB2_END=nan(NC,N);
    for n=1:N
        CB1_END(:,n)=squeeze(jstats.ContextBelief(1,n,:,TsB(n)));
        CB1_STR(:,n)=squeeze(jstats.ContextBelief(1,n,:,1));

        CB2_END(:,n)=squeeze(jstats.ContextBelief(2,n,:,TsB(n)));
        CB2_STR(:,n)=squeeze(jstats.ContextBelief(2,n,:,     1));    
    end
    trials=1:N;

    hfig=figure; 
    p=[0,0,1500,600];
    fs=14;
    subplot(Npl,1,1); hold on; box on; grid on;

    
    for ind=1:NC
        a(ind)=plot(trials,CB1_STR(ind,:),'marker','o','linewidth',3,'color',cmaps(ind,:));
    end
    title('Agent 1 Starting Belief on goal')
    
    NTICKS=20; DX=round(trials(end)/NTICKS);
    
    set(gca,'xtick',0:DX:trials(end));
    
    xlabel('Trial');
    ylabel('Prob');
    xlim([1,trials(end)]);
    ylim([0,1]);
    legend(a,inf_labs);
    set(gca,'fontsize',fs);
   
    subplot(Npl,1,2); hold on; box on; grid on;

    for ind=1:NC
        a(ind)=plot(trials,CB1_END(ind,:),'marker','o','linewidth',3,'color',cmaps(ind,:));
    end
    title('Agent 1 Ending Belief on goal')
    
    NTICKS=20; DX=round(trials(end)/NTICKS);
    
    set(gca,'xtick',0:DX:trials(end));
    
    xlabel('Trial');
    ylabel('Prob');
    xlim([1,trials(end)]);
    ylim([0,1]);
    legend(a,inf_labs);
    set(gca,'fontsize',fs);
    
    %% Agent 2
    subplot(Npl,1,3); hold on; box on; grid on;
    for ind=1:NC
        a(ind)=plot(trials,CB2_STR(ind,:),'marker','o','linewidth',3,'color',cmaps(ind,:));
    end
    
    title('Agent 2 Starting Belief on goal')
    
    set(gca,'xtick',0:DX:trials(end));
    xlabel('Trial');
    ylabel('Prob');
    xlim([1,trials(end)]);
    ylim([0,1]);
    legend(a,inf_labs);
    set(gca,'fontsize',fs);
    set(hfig, 'PaperPositionMode','auto');
    set(hfig,'Position',p);
    
    subplot(Npl,1,4); hold on; box on; grid on;
    for ind=1:NC
        a(ind)=plot(trials,CB2_END(ind,:),'marker','o','linewidth',3,'color',cmaps(ind,:));
    end
    
    title('Agent 2 Ending Belief on goal')
    
    set(gca,'xtick',0:DX:trials(end));
    xlabel('Trial');
    ylabel('Prob');
    xlim([1,trials(end)]);
    ylim([0,1]);
    legend(a,inf_labs);
    set(gca,'fontsize',fs);
    set(hfig, 'PaperPositionMode','auto');
    set(hfig,'Position',p);
%%    
    sf=[dj.save_dir '/' dj.description '_TrialB'];
    fprintf('Saving %s\n',sf);
    print(hfig,'-depsc2',[sf '.eps']);
    savefig(hfig,[sf '.fig']);
    convertEPS2PSD_cell({dj.save_dir});
end


if wo(4)
    Npl=5;
    %% plot start end
    inf_labs={'(Blue, Blue)','(Blue, Red)','(Red,Blue)','(Red, Red)'};
    CB1_STR=nan(NC,N);
    CB1_END=nan(NC,N);
    CB2_STR=nan(NC,N);
    CB2_END=nan(NC,N);
    for n=1:N
        CB1_END(:,n)=squeeze(jstats.ContextBelief(1,n,:,TsB(n)));
        CB1_STR(:,n)=squeeze(jstats.ContextBelief(1,n,:,1));

        CB2_END(:,n)=squeeze(jstats.ContextBelief(2,n,:,TsB(n)));
        CB2_STR(:,n)=squeeze(jstats.ContextBelief(2,n,:,     1));
    end
    trials=1:N;

    hfig=figure; 
    p=[0,0,1500,600];
    fs=14;
    subplot(Npl,1,1); hold on; box on; grid on;
    
    for ind=1:NC
        a(ind)=plot(trials,CB1_STR(ind,:),'marker','o','linewidth',3,'color',cmaps(ind,:));
    end
    title('Agent 1 Starting Belief on goal')
    
    NTICKS=20; DX=round(trials(end)/NTICKS);
    
    set(gca,'xtick',0:DX:trials(end));
    
    xlabel('Trial');
    ylabel('Prob');
    xlim([1,trials(end)]);
    ylim([0,1]);
    legend(a,inf_labs);
    set(gca,'fontsize',fs);
    
    %%
    subplot(Npl,1,5);
    SS=jstats.S1;
    Ntrials=size(SS,1);
    for ind=1:Ntrials
        Traj=SS(ind,:);
        score(ind)=Djoint_AnalyzeTraj_21MazeLong(Traj,params.cirgoal);
        if score(ind)==0
            score(ind)=Djoint_AnalyzeTraj_21MazeLong(Traj,params.squargoal);
        end
    end
    
    bar(score);
    NTICKS=20; DX=round(trials(end)/NTICKS);
    
    set(gca,'xtick',0:DX:trials(end));
    
    xlabel('Trial');
    ylabel('Strategy');
    xlim([1,trials(end)]);
    legend(a,inf_labs);
    set(gca,'fontsize',fs);
    
    subplot(Npl,1,2); hold on; box on; grid on;

    for ind=1:NC
        a(ind)=plot(trials,CB1_END(ind,:),'marker','o','linewidth',3,'color',cmaps(ind,:));
    end
    title('Agent 1 Ending Belief on goal')
    
    NTICKS=20; DX=round(trials(end)/NTICKS);
    
    set(gca,'xtick',0:DX:trials(end));
    
    xlabel('Trial');
    ylabel('Prob');
    xlim([1,trials(end)]);
    ylim([0,1]);
    legend(a,inf_labs);
    set(gca,'fontsize',fs);
    
    %% Agent 2
    subplot(Npl,1,3); hold on; box on; grid on;
    for ind=1:NC
        a(ind)=plot(trials,CB2_STR(ind,:),'marker','o','linewidth',3,'color',cmaps(ind,:));
    end
    
    title('Agent 2 Starting Belief on goal')
    
    set(gca,'xtick',0:DX:trials(end));
    xlabel('Trial');
    ylabel('Prob');
    xlim([1,trials(end)]);
    ylim([0,1]);
    legend(a,inf_labs);
    set(gca,'fontsize',fs);
    set(hfig, 'PaperPositionMode','auto');
    set(hfig,'Position',p);
    
    subplot(Npl,1,4); hold on; box on; grid on;
    for ind=1:NC
        a(ind)=plot(trials,CB2_END(ind,:),'marker','o','linewidth',3,'color',cmaps(ind,:));
    end
    
    title('Agent 2 Ending Belief on goal')
    
    set(gca,'xtick',0:DX:trials(end));
    xlabel('Trial');
    ylabel('Prob');
    xlim([1,trials(end)]);
    ylim([0,1]);
    legend(a,inf_labs);
    set(gca,'fontsize',fs);
    set(hfig, 'PaperPositionMode','auto');
    set(hfig,'Position',p);

%%    
    sf=[dj.save_dir '/' dj.description '_TrialB'];
    fprintf('Saving %s\n',sf);
    print(hfig,'-depsc2',[sf '.eps']);
    savefig(hfig,[sf '.fig']);
    convertEPS2PSD_cell({dj.save_dir});
end

if wo(5)
    Npl=3;
    %% plot start end
    inf_labs={'(Blue, Blue)','(Blue, Red)','(Red,Blue)','(Red, Red)'};
    CB1_STR=nan(NC,N);
    CB1_END=nan(NC,N);
    CB2_STR=nan(NC,N);
    CB2_END=nan(NC,N);
    for n=1:N
        CB1_END(:,n)=squeeze(jstats.ContextBelief(1,n,:,TsB(n)));
        CB1_STR(:,n)=squeeze(jstats.ContextBelief(1,n,:,1));

        CB2_END(:,n)=squeeze(jstats.ContextBelief(2,n,:,TsB(n)));
        CB2_STR(:,n)=squeeze(jstats.ContextBelief(2,n,:,     1));    
    end
    trials=1:N;

    hfig=figure('visible',vis); 
    p=[0,0,1500,600];
    fs=14;
    ddx=0.5;
    %%
    subplot(Npl,1,3); hold on; box on; grid on;
    S1=jstats.S1;
    S2=jstats.S2;
    Ntrials=size(S1,1);
    for ind=1:Ntrials
        Traj1=S1(ind,:);
        Traj2=S2(ind,:);

        score(ind)=Djoint_AnalyzeTraj_21MazeSuccess(Traj1,Traj2,params.cirgoal,params.squargoal);
    end
    indblue=score==params.squargoal;
    indred= score==params.cirgoal;
    indfail=score==0;
    failgoal=params.cirgoal-2;
    
    for k=find(indfail)
        bar(trials(k),failgoal,0.8,'facecolor','black');
    end
    for k=find(indblue)
        bar(trials(k),score(k),0.8,'facecolor',cmaps(1,:));
    end
    for k=find(indred)
        bar(trials(k),score(k),0.8,'facecolor',cmaps(4,:));
    end
    NTICKS=20; DX=round(trials(end)/NTICKS);
    
    set(gca,'xtick',0:DX:trials(end));
    xlabel('Trial');
    ylabel('Outcome');
    xlim([1-ddx,trials(end)+ddx]);
    yticks([failgoal,params.cirgoal,params.squargoal])
    yticklabels({'FAIL','[R,R]','[B B]'});
    ylim([failgoal-1,params.squargoal+1]);
    set(gca,'fontsize',fs);
    %   
    subplot(Npl,1,1); hold on; box on; grid on;
    CB1_STR(abs(CB1_STR-0.7)<0.1)=0.7;
    CB1_STR(abs(CB1_STR-0.3)<0.1)=0.3;
    for ind=1:NC
        a(ind)=plot(trials,CB1_STR(ind,:),'marker',markers{ind},'linewidth',3,'color',cmaps(ind,:));
    end
    title('White Agent')
    
    NTICKS=20; DX=round(trials(end)/NTICKS);
    
    set(gca,'xtick',0:DX:trials(end));
    
    xlabel('Trial');
    ylabel('Prob');
    xlim([1-ddx,trials(end)+ddx]);
    ylim([0,1]);
    if strcmp (params.description,'Djoint_OPEN_A15050_A25050_SHOW_TEST_03')   
        
    else
        legend(a,inf_labs);
    end
    set(gca,'fontsize',fs);
    
    %% Agent 2
    
    subplot(Npl,1,2); hold on; box on; grid on;
    for ind=1:NC
        a(ind)=plot(trials,CB2_STR(ind,:),'marker',markers{ind},'linewidth',3,'color',cmaps(ind,:));
    end
    
    title('Grey Agent')
    
    set(gca,'xtick',0:DX:trials(end));
    xlabel('Trial');
    ylabel('Prob');
    xlim([1-ddx,trials(end)+ddx]);
    ylim([0,1]);
    if strcmp (params.description,'Djoint_OPEN_A15050_A25050_SHOW_TEST_03')
        pos=[0.70883002580528 0.579339343309905 0.192715228057855 0.0750421565057455];
        legend(a,inf_labs,'position',pos,'NumColumns',2);
    end
    legend(a,inf_labs);
    
    set(gca,'fontsize',fs);
    set(hfig, 'PaperPositionMode','auto');
    set(hfig,'Position',p);
%%  
    if 0
        sf=[dj.save_dir '/' dj.description '_TrialB'];
        fprintf('Saving %s\n',sf);
        print(hfig,'-depsc2',[sf '.eps']);
        savefig(hfig,[sf '.fig']);
        convertEPS2PSD_cell({dj.save_dir});
    end
end


if wo(6)
    strategy_plot=[1,1];
    Npl=3+sum(strategy_plot);
    iA1=1; iS1=0; iS2=0; 
    
    if strategy_plot(1) 
        iS1=2;
    end
    iA2=iA1+1+strategy_plot(1);
%     iA2=3; 
    if strategy_plot(2)
        iS2=4;
    end
    iG=Npl;

    %% plot start end
    inf_labs={'(Blue, Blue)','(Blue, Red)','(Red,Blue)','(Red, Red)'};
    CB1_STR=nan(NC,N);
    CB1_END=nan(NC,N);
    CB2_STR=nan(NC,N);
    CB2_END=nan(NC,N);

    for n=1:N
        CB1_END(:,n)=squeeze(jstats.ContextBelief(1,n,:,TsB(n)));
        CB1_STR(:,n)=squeeze(jstats.ContextBelief(1,n,:,1));

        CB2_END(:,n)=squeeze(jstats.ContextBelief(2,n,:,TsB(n)));
        CB2_STR(:,n)=squeeze(jstats.ContextBelief(2,n,:,     1));
    
    end
    trials=1:N;

    hfig=figure('visible',vis); 
    p=[0,0,1500,800];
    fs=14;
    ddx=0.5;
%     
    %% Goal Plot
    if iG
        subplot(Npl,1,iG); hold on; box on; grid on;
        S1=jstats.S1;
        S2=jstats.S2;
        Ntrials=size(S1,1);
        for ind=1:Ntrials
            Traj1=S1(ind,:);
            Traj2=S2(ind,:);
            score(ind)=Djoint_AnalyzeTraj_21MazeSuccess(Traj1,Traj2,params.cirgoal,params.squargoal);
        end
        indblue=score==params.squargoal;
        indred= score==params.cirgoal;
        indfail=score==0;
        failgoal=params.cirgoal-2;

        for k=find(indfail)
            bar(trials(k),failgoal,0.8,'facecolor','black');
        end
        for k=find(indblue)
            bar(trials(k),score(k),0.8,'facecolor',cmaps(1,:));
        end
        for k=find(indred)
            bar(trials(k),score(k),0.8,'facecolor',cmaps(4,:));
        end
        NTICKS=20; DX=round(trials(end)/NTICKS);

        set(gca,'xtick',0:DX:trials(end));
        xlabel('Trial');
        ylabel('Outcome');
        xlim([1-ddx,trials(end)+ddx]);
        yticks([failgoal,params.cirgoal,params.squargoal])
        yticklabels({'Fail','R,R','B B'});
        ylim([failgoal-1,params.squargoal+1]);
        set(gca,'fontsize',fs);
        %
    end
    if iA1
    %% Agent 1 Ending Belief
        subplot(Npl,1,iA1); hold on; box on; grid on;

        for ind=1:NC
            a(ind)=plot(trials,CB1_STR(ind,:),'marker',markers{ind},'linewidth',3,'color',cmaps(ind,:));
        end
        title('White Agent')

        NTICKS=20; DX=round(trials(end)/NTICKS);

        set(gca,'xtick',0:DX:trials(end));

        xlabel('Trial');
        ylabel('Prob');
        xlim([1-ddx,trials(end)+ddx]);
        ylim([0,1]);
        pos=[0.524061817496554 0.725574195778819 0.381456946300355 0.0404721743742893];
        legend(a,inf_labs,'NumColumns',4,'Position',pos);
        set(gca,'fontsize',fs);
    end
    if iA2
        %% Agent 2 Ending Belief
        subplot(Npl,1,iA2); hold on; box on; grid on;
        for ind=1:NC
            a(ind)=plot(trials,CB2_STR(ind,:),'marker',markers{ind},'linewidth',3,'color',cmaps(ind,:));
        end

        title('Grey Agent')

        set(gca,'xtick',0:DX:trials(end));
        xlabel('Trial');
        ylabel('Prob');
        xlim([1-ddx,trials(end)+ddx]);
        ylim([0,1]);
        pos=[0.524061817496554 0.379874364412883 0.381456946300355 0.0404721743742893];
        legend(a,inf_labs,'NumColumns',4,'position',pos);
        set(gca,'fontsize',fs);
        set(hfig, 'PaperPositionMode','auto');
        set(hfig,'Position',p);
    end
    
    if iS1
    %% Agent 1 Strategy
        lcs=sprintf('%g,',collong);
        scs=sprintf('%g,',colshort);
        LongStr =['\color[rgb]{' lcs(1:end-1) '} \bf{L} '];
        ShortStr=['\color[rgb]{' scs(1:end-1) '} \bf{S} '];
        short =1;
        long  =2;
        center=[7,11,15];
        PAR.short = short;
        PAR.long  =  long;
        PAR.center=center;
 
        subplot(Npl,1,iS1); hold on; box on; grid on;
        S1=jstats.S1;

        Ntrials=size(S1,1);
        strategy=nan(1,Ntrials);
        for ind=1:Ntrials
            Traj=S1(ind,:);
            strategy(ind)=Djoint_AnalyzeTraj_21MazeShortLong(Traj,PAR);
        end
        indlong = strategy==PAR.long;
        indshort= strategy==PAR.short;


        for k=find(indshort)
            bar(trials(k),strategy(k),0.8,'facecolor',colshort);
        end
        for k=find(indlong)
            bar(trials(k),strategy(k),0.8,'facecolor',collong );
        end
        NTICKS=20; DX=round(trials(end)/NTICKS);

        set(gca,'xtick',0:DX:trials(end));
        xlabel('Trial');
        ylabel('Strategy');
        
        xlim([1-ddx,trials(end)+ddx]);
        yticks([PAR.short-px,PAR.long+px])
        yticklabels({ShortStr,LongStr});
        ylim([PAR.short-1,PAR.long+1]);
        set(gca,'fontsize',fs);
    end
    if iS2
    %% Agent 2 Strategy
        subplot(Npl,1,iS2); hold on; box on; grid on;
        S2=jstats.S2;
        Ntrials=size(S1,1);
        strategy=nan(1,Ntrials);
        for ind=1:Ntrials
            Traj=S2(ind,:);
            strategy(ind)=Djoint_AnalyzeTraj_21MazeShortLong(Traj,PAR);
        end
        indlong = strategy==PAR.long;
        indshort= strategy==PAR.short;

        for k=find(indshort)
            bar(trials(k),strategy(k),0.8,'facecolor',colshort);
        end
        for k=find(indlong)
            bar(trials(k),strategy(k),0.8,'facecolor',collong );
        end
        NTICKS=20; DX=round(trials(end)/NTICKS);

        set(gca,'xtick',0:DX:trials(end));
        xlabel('Trial');
        ylabel('Strategy');
        
        xlim([1-ddx,trials(end)+ddx]);
        yticks([PAR.short-px,PAR.long+px])
        yticklabels({ShortStr,LongStr});
        ylim([PAR.short-1,PAR.long+1]);
        set(gca,'fontsize',fs);

        %%
        if 0
            sf=[dj.save_dir '/' dj.description '_Trialw6'];
            fprintf('Saving %s\n',sf);
            print(hfig,'-depsc2',[sf '.eps']);
            savefig(hfig,[sf '.fig']);
            convertEPS2PDF({dj.save_dir});
        end
    end
end


if wo(7)
    %%% STRATEGY CLOSED
    Npl=5;
    iA1=1; iS1=2; iA2=3; iS2=4; iG=5;
    %% plot start end
    inf_labs={'(Blue, Blue)','(Blue, Red)','(Red,Blue)','(Red, Red)'};
    CB1_STR=nan(NC,N);
    CB1_END=nan(NC,N);
    CB2_STR=nan(NC,N);
    CB2_END=nan(NC,N);

    for n=1:N
        CB1_END(:,n)=squeeze(jstats.ContextBelief(1,n,:,TsB(n)));
        CB1_STR(:,n)=squeeze(jstats.ContextBelief(1,n,:,1));

        CB2_END(:,n)=squeeze(jstats.ContextBelief(2,n,:,TsB(n)));
        CB2_STR(:,n)=squeeze(jstats.ContextBelief(2,n,:,     1));
    
    end
    trials=1:N;

    hfig=figure('visible',vis); 
    p=[0,0,1500,600];
    fs=14;
    ddx=0.5;
%     
    %% Goal Plot
    subplot(Npl,1,iG); hold on; box on; grid on;
    S1=jstats.S1;
    S2=jstats.S2;
    Ntrials=size(S1,1);
    for ind=1:Ntrials
        Traj1=S1(ind,:);
        Traj2=S2(ind,:);
        score(ind)=Djoint_AnalyzeTraj_21MazeSuccess(Traj1,Traj2,params.cirgoal,params.squargoal);
    end
    indblue=score==params.squargoal;
    indred= score==params.cirgoal;
    indfail=score==0;
    failgoal=params.cirgoal-2;
    
    for k=find(indfail)
        bar(trials(k),failgoal,0.8,'facecolor','black');
    end
    for k=find(indblue)
        bar(trials(k),score(k),0.8,'facecolor',cmaps(1,:));
    end
    for k=find(indred)
        bar(trials(k),score(k),0.8,'facecolor',cmaps(4,:));
    end
    NTICKS=20; DX=round(trials(end)/NTICKS);
    
    set(gca,'xtick',0:DX:trials(end));
    xlabel('Trial');
    ylabel('Strategy');
    xlim([1-ddx,trials(end)+ddx]);
    yticks([failgoal,params.cirgoal,params.squargoal])
    yticklabels({'Fail','R,R','B B'});
    ylim([failgoal-1,params.squargoal+1]);
    set(gca,'fontsize',fs);
    %
    
    %% Agent 1 Ending Belief
    subplot(Npl,1,iA1); hold on; box on; grid on;

    for ind=1:NC
        a(ind)=plot(trials,CB1_END(ind,:),'marker','o','linewidth',3,'color',cmaps(ind,:));
    end
    title('Agent 1 Ending Belief on goal')
    
    NTICKS=20; DX=round(trials(end)/NTICKS);
    
    set(gca,'xtick',0:DX:trials(end));
    
    xlabel('Trial');
    ylabel('Prob');
    xlim([1-ddx,trials(end)+ddx]);
    ylim([0,1]);
    legend(a,inf_labs);
    set(gca,'fontsize',fs);
    
    %% Agent 2 Ending Belief
    subplot(Npl,1,iA2); hold on; box on; grid on;
    for ind=1:NC
        a(ind)=plot(trials,CB2_END(ind,:),'marker','o','linewidth',3,'color',cmaps(ind,:));
    end
    
    title('Agent 2 Ending Belief on goal')
    
    set(gca,'xtick',0:DX:trials(end));
    xlabel('Trial');
    ylabel('Prob');
    xlim([1-ddx,trials(end)+ddx]);
    ylim([0,1]);
    legend(a,inf_labs);
    set(gca,'fontsize',fs);
    set(hfig, 'PaperPositionMode','auto');
    set(hfig,'Position',p);

    
    %% Agent 1 Strategy
    LongStr='L  ';
    ShortStr='S  ';
    short =1;
    long  =2;
    PAR.short = short;
    PAR.long  =  long;
    
    subplot(Npl,1,iS1); hold on; box on; grid on;
    S1=jstats.S1;
    
    Ntrials=size(S1,1);
    strategy=nan(1,Ntrials);
    for ind=1:Ntrials
        Traj=S1(ind,:);
        strategy(ind)=Djoint_AnalyzeTraj_21MazeShortLong_closed(Traj,PAR);
    end
    indlong = strategy==PAR.long;
    indshort= strategy==PAR.short;
    

    collong =[0.3,0.2,0.7];
    colshort=[0.7,0.3,0.2];
    for k=find(indshort)
        bar(trials(k),strategy(k),0.8,'facecolor',colshort);
    end
    for k=find(indlong)
        bar(trials(k),strategy(k),0.8,'facecolor',collong );
    end
    NTICKS=20; DX=round(trials(end)/NTICKS);
    
    set(gca,'xtick',0:DX:trials(end));
    xlabel('Trial');
    ylabel('Strategy');

    xlim([1-ddx,trials(end)+ddx]);
    yticks([PAR.short-1,PAR.long+1])
    yticklabels({ShortStr,LongStr});
    ylim([PAR.short-1,PAR.long+1]);
    set(gca,'fontsize',fs);
    
    %% Agent 2 Strategy
    
    subplot(Npl,1,iS2); hold on; box on; grid on;
    S2=jstats.S2;
    Ntrials=size(S1,1);
    strategy=nan(1,Ntrials);
    for ind=1:Ntrials
        Traj=S2(ind,:);
        strategy(ind)=Djoint_AnalyzeTraj_21MazeShortLong_closed(Traj,PAR);
    end
    indlong = strategy==PAR.long;
    indshort= strategy==PAR.short;
    

    collong =[0.3,0.2,0.7];
    colshort=[0.7,0.3,0.2];
    for k=find(indshort)
        bar(trials(k),strategy(k),0.8,'facecolor',colshort);
    end
    for k=find(indlong)
        bar(trials(k),strategy(k),0.8,'facecolor',collong );
    end
    NTICKS=20; DX=round(trials(end)/NTICKS);
    
    set(gca,'xtick',0:DX:trials(end));
    xlabel('Trial');
    ylabel('Strategy');
    xlim([1-ddx,trials(end)+ddx]);
    yticks([PAR.short-1,PAR.long+1])
    yticklabels({ShortStr,LongStr});
    ylim([PAR.short-1,PAR.long+1]);
    set(gca,'fontsize',fs);
    
    %%
    if 0
        sf=[dj.save_dir '/' dj.description '_Trialw6'];
        fprintf('Saving %s\n',sf);
        print(hfig,'-depsc2',[sf '.eps']);
        savefig(hfig,[sf '.fig']);
        convertEPS2PDF({dj.save_dir});
    end
end