%% function experiment=save_Statistical_figures(test_name,params)

% test_name='OPEN_LF_A15050C_A25050_SIM_CA_P1'; forceTN=1:10;           hmsub=3;
% test_name='OPEN_LF_A15050S_A25050_SIM_CA_P1'; params.forceTN=1:10; params.hmsub=3; params.ifplotKL_PRIORS_PLUS=1;

% F3 bar    % test_name='OPEN_A15050_A25050_SIM_CA_P1';     params.forceTN=1:15; params.hmsub=2; params.ifplotKL_PRIORS_PLUS=1;
% F3 inter  % test_name='OPEN_A15050_A25050_SIM_CA_P1';     params.forceTN=1:15; params.hmsub=2; params.ifplotKL_PRIORS_PLUS=1; params.ifbar=0;
% F3 plot   % test_name='OPEN_A15050_A25050_SIM_CA_P1';     params.forceTN=1:15; params.hmsub=2; params.ifplotKL_PRIORS_PLUS=1; params.ifbar=3;
% F3 plot2  % test_name='OPEN_A15050_A25050_SIM_CA_P1';     params.forceTN=1:15; params.hmsub=2; params.ifplotKL_PRIORS_PLUS=1; params.ifbar=2;

% F5 bar    % test_name='OPEN_LF_A15050S_A25050_SIM_CA_P1'; params.forceTN=1:10; params.hmsub=3; params.ifplotKL_PRIORS_PLUS=1;
% F5 inter  % test_name='OPEN_LF_A15050S_A25050_SIM_CA_P1'; params.forceTN=1:10; params.hmsub=3; params.ifplotKL_PRIORS_PLUS=1; params.ifbar=0;
% F5 plot   % test_name='OPEN_LF_A15050S_A25050_SIM_CA_P1'; params.forceTN=1:10; params.hmsub=3; params.ifplotKL_PRIORS_PLUS=1; params.ifbar=3; 
% F5 plot   % test_name='OPEN_LF_A15050S_A25050_SIM_CA_P1'; params.forceTN=1:10; params.hmsub=3; params.ifplotKL_PRIORS_PLUS=1; params.ifbar=2; 

% test_name='OPEN_A15050_A25050_CONTRA';
% test_name='OPEN_LF_A15050C_A25050_CONTRA';    forceTN=[1:6,15:18];    hmsub=3; % [1:6,15:18], 3


% test_name='OPEN_LF_A15050C_A25050_SIM_CA_P1'; params.forceTN=1:10; params.ifplotKL_PRIORS_PLUS=1;

% S2 % test_name='OPEN_A15050_A25050_SIM_CA_P1'; params.forceTN=1:30; params.ifplotImageScore=1;
% S3 % test_name='OPEN_A15050_A25050_RL'; params.forceTN=[5,2:4,1,6:30]; params.ifplotImageScore=1;  
% S4 bar    % test_name='OPEN_A15050_A25050_RL'; params.forceTN=[2,3,4,6:8,9:13,20,15,5,24]; params.hmsub=2; params.ifplotKL_PRIORS_PLUS=1; params.removeOutliers=false; params.ma=1;
% S4 inter  % test_name='OPEN_A15050_A25050_RL'; params.forceTN=[2,3,4,6:8,9:13,20,15,5,24]; params.hmsub=2; params.ifplotKL_PRIORS_PLUS=1; params.removeOutliers=false; params.ma=1; params.ifbar=0;
% S4 plots2 % test_name='OPEN_A15050_A25050_RL'; params.forceTN=[2,3,4,6:8,9:13,20,15,5,24]; params.hmsub=2; params.ifplotKL_PRIORS_PLUS=1; params.removeOutliers=false; params.ma=1; params.ifbar=3;
% S4 plots  % test_name='OPEN_A15050_A25050_RL'; params.forceTN=[2,3,4,6:8,9:13,20,15,5,24]; params.hmsub=2; params.ifplotKL_PRIORS_PLUS=1; params.removeOutliers=false; params.ma=1; params.ifbar=2;

% S6 % test_name='OPEN_LF_A15050C_A25050_SIM_CA_P1'; params.forceTN=1:10; params.ifplotImageScore=1;

% S7 bar    % test_name='OPEN_LF_A15050C_A25050_CONTRA'; params.forceTN=1:10; params.hmsub=3; params.ifplotKL_PRIORS_PLUS=1; params.removeOutliers=0; params.ma=3; 
% S7 inter  % test_name='OPEN_LF_A15050C_A25050_CONTRA'; params.forceTN=1:10; params.hmsub=3; params.ifplotKL_PRIORS_PLUS=1; params.removeOutliers=0; params.ma=3; params.ifbar=0;
% S7 plots2 % test_name='OPEN_LF_A15050C_A25050_CONTRA'; params.forceTN=1:10; params.hmsub=3; params.ifplotKL_PRIORS_PLUS=1; params.removeOutliers=0; params.ma=3; params.ifbar=3;
% S7 plots  % test_name='OPEN_LF_A15050C_A25050_CONTRA'; params.forceTN=1:10; params.hmsub=3; params.ifplotKL_PRIORS_PLUS=1; params.removeOutliers=0; params.ma=3; params.ifbar=2;

% test_name='OPEN_A15050_A25050_RL'; params.forceTN=[5,2:4,1,6:15]; params.hmsub=2; params.ifplotKL_PRIORS_PLUS=1; 



function experiment=save_Statistical_figures(test_name,params)
save_dir=['~/tmp/DJOINT/' test_name];
results_dir=['results_djoint/' test_name];
if ~isfolder(save_dir)
    mkdir (save_dir);
end
try
    hms=params.hmsub;
catch
    hms=2;
end
if  length(strsplit(test_name,'_LF_'))>1
    LF_TEST=1;
else
    LF_TEST=0;
end
try
    removeOutliers=params.removeOutliers;
catch
    removeOutliers=true;
end
try
    forceTN=params.forceTN;
catch
end
try
    ma=params.ma;
catch
    ma=5;
end
ifloaddata              = 1;

ifplotKL                = 0;
ifplotImageScore        = 0;
ifplotKL_PLUS           = 0;
ifplotKL_PRIORS_PLUS    = 0;
ifplotSuccessRate       = 0;
cmap_SuccessRate        = [0.2,0.2,0.2];
cmap_Signaling          = [0.4,0.4,0.4];
    
try
    ifplotKL=params.ifplotKL;
catch
end
try
    ifplotKL_PRIORS_PLUS=params.ifplotKL_PRIORS_PLUS;
catch
end
try
    ifplotImageScore=params.ifplotImageScore;
catch
end
try
    ifbar=params.ifbar;
catch
    ifbar=1;
end

% forceTN=10; % force trial numbers;
if ifloaddata
    nf=['experiment_' test_name];
    flexp=load ([results_dir '/' nf]);
    experiment=flexp.experiment;
    %% convert for a save error
    % experiment.rep=flexp.experiment.rep(100:199);
    % for i=1:100
    %     experiment.rep{i}.indRepetition=99+i;
    % end
    % save([results_dir '/' nf],'experiment');
    % experiment=flexp.experiment;

%     iT           =1;

%     indRepetition=1;
%     indTrial     =1;
    NC           =size(experiment.rep{1}.results{1}.ContextBelief{1},1);
    Nreps        =length(experiment.rep);
    Ntrials      =length(experiment.rep{1}.results);
    origNtrials  =Ntrials;
    try
%         Ntrials     =forceTN;
        Ntrials     =length(forceTN);
        indTrials   =forceTN;
    catch
        indTrials   =1:Ntrials;
    end

    %% Belief end
    endB1        =nan(Nreps,Ntrials,NC);
    endB2        =nan(Nreps,Ntrials,NC);
    for indRepetition=1:Nreps
        for iT=1:Ntrials
            indTrial=indTrials(iT);
            endB1(indRepetition,iT,:)=squeeze(experiment.rep{indRepetition}.rjstats.ContextBelief(1,indTrial,:,end));
            endB2(indRepetition,iT,:)=squeeze(experiment.rep{indRepetition}.rjstats.ContextBelief(2,indTrial,:,end));
        end
    end

    KL_T1T2=nan(Nreps,Ntrials);
    for indRepetition=1:Nreps
        for iT=1:Ntrials
%             indTrial=indTrials(iT);
            h=squeeze(endB1(indRepetition,iT,:));
            g=squeeze(endB2(indRepetition,iT,:));
            KL_T1T2(indRepetition,iT) = -sum( h.*log(g./h) );
        end
    end
    %% Belief End
    [endB1m,endB2m]=getEndB(experiment,indTrials);
    KL_T1T2_POSTERIORS  =getKL_T1T2(endB1m,endB2m);

    %% Belief Start
    [startB1,startB2]=getStartB(experiment,indTrials);
%     [startB1,startB2]=getStartB(experiment,1:15);
    KL_T1T2_PRIORS      =getKL_T1T2(startB1,startB2);
    
    score=nan(Nreps,Ntrials);
    
    for indRepetition=1:Nreps
        dfRep=experiment.rep{indRepetition}.rjstats.S1-experiment.rep{indRepetition}.rjstats.S2;
        dfRep=dfRep(:,end);
        repscore=nan(size(dfRep));
        repscore(dfRep~=0)=-1;
        repscore(dfRep==0)=experiment.rep{indRepetition}.rjstats.S1(dfRep==0,end);
        score(indRepetition,:)=repscore(indTrials);
    end
    
%     tscore=score';
    
    
    short =1;
    long  =2;
    center=[7,11,15];
    PAR.short = short;
    PAR.long  =  long;
    PAR.center=center;
%     strategy=nan(1,Ntrials);
    strategy=nan(Nreps,origNtrials);

    for indRepetition=1:Nreps
        
        S1=experiment.rep{indRepetition}.jstats.S1;
        for indT=1:origNtrials
            Traj=S1(indT,:);
    %         Traj2=S2(indT,:);
            strategy(indRepetition,indT)=Djoint_AnalyzeTraj_21MazeShortLong(Traj,PAR);
        end
%         indlong = strategy==PAR.long;
%         indshort= strategy==PAR.short;
    end
%     indlong = strategy==PAR.long;
end

if ifplotKL   %% KL_T1T2
    times=1:Ntrials;
    cmaps=[0.2,0.2,0.2];

    cmapsLight=[0.6,0.6,0.6];
    mm = mean(KL_T1T2);
    st = std(KL_T1T2);
    ma=5; %8,30;
    means=smooth(mm,ma,'moving');
    sigmas=smooth(st,ma,'moving');
    sigmas=sigmas./sqrt(Nreps);
    hfig=figure; hold on; box on; grid on;
    c1=cmaps;
    c2=cmapsLight;
    c3=cmaps;
    % ih=plotMeanAndVariance(mm,st,times,cmaps,cmapsLight,cmaps);


    hm          = 15*3;                   % how many repetitions (increase if you see blank spaces)

    indh        = 0;% hold on;
    lw1         = 3;   % width of the vertical lines
    lw2         = 5;    % width of the mean line
    lw3         = 2;    % width of the sigmas line

    for i=1:length(times)-1
        t   = linspace(times(i),times(i+1),hm);
        xd  = linspace(means(i)-sigmas(i),means(i+1)-sigmas(i+1),hm);
        xu  = linspace(means(i)+sigmas(i),means(i+1)+sigmas(i+1),hm);
        xd(xd<0)=0;
        for k=1:hm
            indh=indh+1;
            out.h(indh)=plot([t(k),t(k)],[xd(k),xu(k)],'color',c2,'LineWidth',lw1);
        end         
    end
    indh=indh+1;
    out.h(indh)=plot(times,means,'linewidth',lw2,'color',c1);
    indh=indh+1;
    lowlevel=means-sigmas;
    lowlevel(lowlevel<0)=0;
    out.h(indh)=plot(times,lowlevel,'linewidth',lw3,'color',c3);
    indh=indh+1;
    out.h(indh)=plot(times,means+sigmas,'linewidth',lw3,'color',c3);
    ylabel ('KL divergence');
    xlabel('Trial')
    xticks(times)
    dx=Ntrials/400;
    xlim([1-dx,Ntrials+dx]);

    p=[0,0,1500,600];
    fs=16;
    set(gca,'fontsize',fs);
    set(hfig,'visible','off');
    set(hfig, 'PaperPositionMode','auto');
    set(hfig,'Position',p);
    % print(hfig,'Giovanni.jpg','-djpeg');

    nf   = [save_dir '/KL_' test_name];
    fprintf('Saving %s\n', nf);
    print(hfig,[nf '.jpg'],'-djpeg');
    print(hfig,[nf '.eps'],'-depsc2');
    savefig(hfig,[nf '.fig']);
end
tscore=score';
if ifplotImageScore %%  score
    
    hfig=figure; hold on;
    % imagenan=zeros(size(score));
    % image(imagenan); colormap gray;
    % imgoal=nan(size(score));
    % imgoal=(score==10) + 10;
    % image(imgoal);

    dp=1/2;
    cv = 0;
    lw = 1;

    h=[];
%     cmaps=linspecer(NC);
    cmaps=getRedBlueCmaps(NC);
    
    for indRepetition=1:Nreps
        for indTrial=1:Ntrials
            Y=indRepetition;
            X=indTrial;
            if tscore(X,Y)==10
                col=cmaps(4,:);
            elseif tscore(X,Y)==12
                col=cmaps(1,:);
            elseif tscore(X,Y)==-1
                col=[0.1,0.1,0.1];
            end
    %         h(end)=
            h(end+1)=rectangle('Position',[X-dp,Y-dp,1,1],'Curvature',cv,'linewidth',lw,'FaceColor',col);%'Linestyle','none')
        end
    %     pause
    end
    xlim([1-dp,Ntrials+dp]);
    ylim([1-dp,Nreps+dp]);
    xlabel('Trial')
    xticks(1:Ntrials);
    ylabel('Repetition');

    p=[0,0,1500,1500];
    fs=16;
    set(gca,'fontsize',fs);
    set(hfig,'visible','off');
    set(hfig, 'PaperPositionMode','auto');
    set(hfig,'Position',p);
    % print(hfig,'Giovanni.jpg','-djpeg');
%     mkdir ~/tmp/DJOINT;
    nf   = [save_dir '/ImageScore_' test_name];
    fprintf('Saving %s\n', nf);
    print(hfig,[nf '.jpg'],'-djpeg');
    print(hfig,[nf '.eps'],'-depsc2');
    savefig(hfig,[nf '.fig']);
end
if ifplotSuccessRate
    hfig=figure; hold on; box on; grid on; bar(sum(tscore>0,2),'facecolor',[0.2,0.2,0.2])
    p=[0,0,1500,600];
    xlabel('Trial')
    xticks(1:Ntrials);
    ylabel('Success Rate');

    fs=16;
    set(gca,'fontsize',fs);
    set(hfig,'visible','off');
    set(hfig, 'PaperPositionMode','auto');
    set(hfig,'Position',p);
    nf   = [save_dir '/SuccessRate_' test_name];
    fprintf('Saving %s\n', nf);
    print(hfig,[nf '.jpg'],'-djpeg');
    print(hfig,[nf '.eps'],'-depsc2');
    savefig(hfig,[nf '.fig']);

end

if ifplotKL_PLUS %% KL_T1T2
    fs=12;
    times=1:Ntrials;
    cmaps=[0.2,0.2,0.2];
    
    cmapsLight=[0.6,0.6,0.6];
    mm = mean(KL_T1T2);
    st = std(KL_T1T2);
    ma=5; %8,30;
    means=smooth(mm,ma,'moving');
    sigmas=smooth(st,ma,'moving');
    sigmas=sigmas./sqrt(Nreps);
    hfig=figure;
    
    subplot(hms,1,1);  hold on; box on; grid on;
    c1=cmaps;
    c2=cmapsLight;
    c3=cmaps;
    % ih=plotMeanAndVariance(mm,st,times,cmaps,cmapsLight,cmaps);


    hm          = 15*3;                   % how many repetitions (increase if you see blank spaces)

    indh        = 0;% hold on;
    lw1         = 3;   % width of the vertical lines
    lw2         = 5;    % width of the mean line
    lw3         = 2;    % width of the sigmas line

    for i=1:length(times)-1
        t   = linspace(times(i),times(i+1),hm);
        xd  = linspace(means(i)-sigmas(i),means(i+1)-sigmas(i+1),hm);
        xu  = linspace(means(i)+sigmas(i),means(i+1)+sigmas(i+1),hm);
        xd(xd<0)=0;
        for k=1:hm
            indh=indh+1;
            out.h(indh)=plot([t(k),t(k)],[xd(k),xu(k)],'color',c2,'LineWidth',lw1);
        end         
    end
    indh=indh+1;
    out.h(indh)=plot(times,means,'linewidth',lw2,'color',c1);
    indh=indh+1;
    lowlevel=means-sigmas;
    lowlevel(lowlevel<0)=0;
    out.h(indh)=plot(times,lowlevel,'linewidth',lw3,'color',c3);
    indh=indh+1;
    out.h(indh)=plot(times,means+sigmas,'linewidth',lw3,'color',c3);
    ylabel ('KL Distance B1 vs B2');
    xlabel('Trial')
    xticks(times)
    dx=Ntrials/400;
    xlim([1-dx,Ntrials+dx]);
    ylim([0,10]);
    
    set(gca,'fontsize',fs);
  %%%%%    2    %%%%%%%%%  
    subplot(hms,1,2);  hold on; box on; grid on;
    dp=1/2;
    
%     score=score';
   
    xlim([1-dp,Ntrials+dp]);
    ylim([1-dp,Nreps+dp]);
 
    set(gca,'fontsize',fs);
    bar(sum(tscore>0,2),'facecolor',[0.2,0.2,0.2])
    trials=1:Ntrials;
    xticks(trials);
    ylabel('Success Rate');
    xlabel('Trial');
    if hms>2
    %%%%%    3    %%%%%%%%%  
        subplot(hms,1,3); hold on; box on; grid on;
        xlim([1-dp,Ntrials+dp]);
    %     ylim([1-dp,Nreps+dp]);
        ma=8;
        means=sum(strategy~=PAR.short,1);
        means=smooth(means,ma,'moving');
    %     sigmas=smooth(st,ma,'moving');

        bar(means(10:end),'facecolor',[0.2,0.2,0.2]);
        xlabel('Trial');
        ylabel('Signaling');
        xticks(trials);
        ylim([40,100])
        set(gca,'fontsize',fs);
    end
%     -----------------------

    set(hfig,'visible','off');
    p=[0,0,1500,1000];
    set(hfig, 'PaperPositionMode','auto');
    set(hfig,'Position',p);
    % print(hfig,'Giovanni.jpg','-djpeg');
%     return
    nf   = [save_dir '/KLPLUS_' test_name];
    fprintf('Saving %s\n', nf);
    print(hfig,[nf '.jpg'],'-djpeg');
    print(hfig,[nf '.eps'],'-depsc2');
    savefig(hfig,[nf '.fig']);
end


if ifplotKL_PRIORS_PLUS %% KL_PRIORS_T1T2
    fs=12;
    times=1:Ntrials;
    cmaps=cmap_SuccessRate;%[0.2,0.2,0.2];
    cmapsLight=[0.6,0.6,0.6];
%    KL_T1T2_PRIORS=rmoutliers(KL_T1T2_PRIORS,'movmean',5);
%     KL_T1T2_PRIORS=rmoutliers(KL_T1T2_PRIORS,'mean');
    newdeal=true;
    % ma=5; %8,30;
    % ma=3;

    if newdeal && removeOutliers
        for irm = 1:size(KL_T1T2_PRIORS,2)
    %         [~,~,locs]=rmoutliers(KL_T1T2_PRIORS,'mean');
            [~,~,locs]=rmoutliers(KL_T1T2_PRIORS,'percentiles',[2.5,97.5]);
        end
        KL_T1T2_PRIORS(locs)=nan;
        sum(locs)
        ma=1;
    end
    mm = mean(KL_T1T2_PRIORS,'omitnan');
    st = std(KL_T1T2_PRIORS,'omitnan');
%     mm = median(KL_T1T2_PRIORS);

    means=smooth(mm,ma,'moving');
    sigmas=smooth(st,ma,'moving');
    sigmas=sigmas./sqrt(Nreps);
%     sigmas = 3*sigmas;
    sigmas = 2*sigmas;
    hfig=figure;
    
    subplot(hms,1,1);  hold on; box on; grid on;
    c1=cmaps;
    c2=cmapsLight;
    c3=cmaps;
    % ih=plotMeanAndVariance(mm,st,times,cmaps,cmapsLight,cmaps);


    hm          = 15*3;                   % how many repetitions (increase if you see blank spaces)

    indh        = 0;% hold on;
    lw1         = 3;   % width of the vertical lines
    lw2         = 5;    % width of the mean line
    lw3         = 2;    % width of the sigmas line

    lw1         = 3;   % width of the vertical lines
    lw2         = 1;    % width of the mean line
    lw3         = 1;    % width of the sigmas line

    for i=1:length(times)-1
        t   = linspace(times(i),times(i+1),hm);
        xd  = linspace(means(i)-sigmas(i),means(i+1)-sigmas(i+1),hm);
        xu  = linspace(means(i)+sigmas(i),means(i+1)+sigmas(i+1),hm);
        xd(xd<0)=0;
        for k=1:hm
            indh=indh+1;
            out.h(indh)=plot([t(k),t(k)],[xd(k),xu(k)],'color',c2,'LineWidth',lw1);
        end         
    end
    indh=indh+1;
    out.h(indh)=plot(times,means,'linewidth',lw2,'color',c1);
    indh=indh+1;
    lowlevel=means-sigmas;
    lowlevel(lowlevel<0)=0;
    out.h(indh)=plot(times,lowlevel,'linewidth',lw3,'color',c3);
    indh=indh+1;
    out.h(indh)=plot(times,means+sigmas,'linewidth',lw3,'color',c3);
    dx=Ntrials/400;
    xlim([1-dx,Ntrials+dx]);
    dp=1/2;
    if newdeal 
        if ifbar == 1
            hold off; 
            bar(times, means,'facecolor',[1,1,1]*0.7); hold on;
            errorbar(times,means,sigmas,'ko','linewidth',1);
            xlim([1-dp,Ntrials+dp]);
        elseif ifbar==2
            hold off; 
            
            % bar(times, means,'facecolor',[1,1,1]*0.7); hold on;
            plot(times, means,'k--','color',[1,1,1]*0.7,'linewidth',5); hold on;
            errorbar(times,means,sigmas,'ko','linewidth',1);
            xlim([1-dp,Ntrials+dp]);
        elseif ifbar==3
            hold off; 
            % bar(times, means,'facecolor',[1,1,1]*0.7); hold on;
            % plot(times, means,'k--','color',[1,1,1]*0.7,'linewidth',5); hold on;
            errorbar(times,means,sigmas,'ko','linewidth',1);
            xlim([1-dp,Ntrials+dp]);
        end
    end
    ylabel ('KL divergence');
    xlabel('Trial')
    xticks(times)
    if LF_TEST
        ylim([0,4]);
    else
        ylim([0,inf]);
%         ylim([0,0.012]);
    end
%     set(gca,'yscale','log');
    set(gca,'fontsize',fs);
%     ylim([0,0.3]);
  %%%%%    2    %%%%%%%%%  
    subplot(hms,1,2);  hold on; box on; grid on;
    
%     score=score';
   
    xlim([1-dp,Ntrials+dp]);
    ylim([1-dp,Nreps+dp]);
 
    set(gca,'fontsize',fs);
    bar(sum(tscore>0,2),'facecolor',cmap_SuccessRate);
    trials=1:Ntrials;
    xticks(trials);
    ylabel('Success Rate');
    xlabel('Trial');
    if hms>2
    %%%%%    3    %%%%%%%%%  
        subplot(hms,1,3); hold on; box on; grid on;
        xlim([1-dp,Ntrials+dp]);
    %     ylim([1-dp,Nreps+dp]);
        ma=8;
        means=sum(strategy~=PAR.short,1);
        means=smooth(means,ma,'moving');
    %     sigmas=smooth(st,ma,'moving');

        bar(means(10:end),'facecolor',cmap_Signaling);
        xlabel('Trial');
        ylabel('Signaling');
        xticks(trials);
        ylim([40,100])
        set(gca,'fontsize',fs);
    end
%     -----------------------

    set(hfig,'visible','off');
    p=[0,0,1500,1000];
    set(hfig, 'PaperPositionMode','auto');
    set(hfig,'Position',p);
    % print(hfig,'Giovanni.jpg','-djpeg');
%     return
    nf   = [save_dir '/KL_PRIORS_PLUS_' test_name];
    fprintf('Saving %s\n', nf);
    print(hfig,[nf '.jpg'],'-djpeg');
    print(hfig,[nf '.eps'],'-depsc2');
    savefig(hfig,[nf '.fig']);
    
end
convertEPS2PDF({save_dir});

