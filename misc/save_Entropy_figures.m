function save_Entropy_figures(test_name,ecode,wo,hm,save_dir)
%% function save_Entropy_figures(test_name,ecode,wo)

% test_name='OPEN_LF_A15050C_A25050_SIM_CA_P2'; ecode   = 'KTYp9gX3TkjTwbM';
try
    save_dir;
catch
    save_dir       =['./results_djoint/' test_name '/'];
end


% nfGK        = load ([save_dir '/' test_name '/' test_name 'KL_POLICIES.mat']);
% tmp_dir     =[save_dir '/' test_name '/'];
tmp_dir     = './';
tmp_dir     = '../SharedContextBelief_V4/';
nfGK        = load ([tmp_dir test_name 'KL_POLICIES.mat']);

GK1         = nfGK.GK1;
try
    ecode;
catch
    ecode   = 'KTYp9gX3TkjTwbM';
end
eninfo      = load ([tmp_dir 'Entropy' ecode '.mat']);
entropy_A1s = eninfo.entropy_A1s;
pGSs        = eninfo.pGSs;
pGLs        = eninfo.pGLs;
GLs         = eninfo.GLs;
GSs         = eninfo.GSs;
Nreps       = size(GK1,1);
Ntrials     = size(GK1,2);
Np          = size(GK1,3);

% mm-(reshape(mm(:),Ntrials,Np));
nmm         = nan(Nreps,Ntrials*Np);
LONGPOL =21;
SHORTPB=nan(Nreps,Ntrials);
for indRep = 1:Nreps
    [mm, gmm]           = getPolicyDistribution(indRep,GK1);
    nmm(indRep,:)       = mm(:);
    ngmm(indRep,:)      = gmm(:);
%     GG           =squeeze(GK1(indRep,:,:));
%     GGs(indRep,:)=GG(:);           
    SHORTPB(indRep,:)   = mm(:,LONGPOL);
end
GGs         = reshape(GK1,Nreps,Np*Ntrials);
newone      =1;
if newone
    meanPB      = mean(ngmm);
    stdPB       = std(ngmm);
else
    meanPB      = mean(nmm);
    stdPB       = std(nmm);
end
% stdPB       = 10^13*stdPB;

meanGG      = mean(GGs);
stdGG       = std(GGs);
polInfo     = DjointPolicies();

mPB         = reshape(meanPB(:),Ntrials,Np);
sPB         = reshape( stdPB(:),Ntrials,Np);
mGG         = reshape(meanGG(:),Ntrials,Np);
sGG         = reshape( stdGG(:),Ntrials,Np);

% sPB   = sPB*10^10;

cmaps       = linspecer(Np);
li          = 14;
[a,b]       = sort(mPB(li,:),'descend');
% [a,b]=sort(mGG(li,:),'descend');
try
    hm;
catch
    % hm          = 25;
    hm          = 2;
end
b           = b(1:hm);

cmapsLight  = lightCmaps(cmaps);

c1          = cmaps;
c2          = cmapsLight;
c3          = cmaps;


if newone
    Mtim        = 15;        
    times       = linspace(1,15,Ntrials);
else
    times       = 1:Ntrials;
end

Nf          = sum(wo);
hfigs       = gobjects(Nf,1);

nf          = 'Haris';
fs          = 16;
p           = [0,0,1500,600];

vis         = 'off';

ind         = 1;
if wo(ind)
    hfigs(ind)  = figure('visible',vis); hold on; box on; grid on;
    par.hfig    = hfigs(ind);
    par.times   = times;
    par.fill    = 1;
    hmeans      = gobjects(length(b),1);
    
    for ip = 1:length(b)
        means       = mGG(:,b(ip));
        sigmas      = sGG(:,b(ip));
        par.c1      = c1(b(ip),:);
        par.c2      = c2(b(ip),:);
        par.c3      = c3(b(ip),:);

        means       = means(1:3:Ntrials);
        means       = smooth(means);
        means       = interp1(1:3:Ntrials,means,(1:Ntrials)','pchip','extrap');
    
        o           = plotMeanAndVariancePlus(means,sigmas*2,par);
        hmeans(ip)  = o.hmean;
    end
    if length(b)==25
        legend(hmeans,polInfo.policy_labels(b),'location','bestoutside','NumColumns',1); p([3:4])=[2000,700];
    else
        legend(hmeans,polInfo.policy_labels(b));
    end
    ylabel('Expected Free Energy');
    xlabel('Trial')
    xticks(times)
    xlim([times(1),times(end)]);
    ylim([-inf,inf]);
    nf=[nf 'PolicyFE'];
end

ind=2;
if wo(ind)
    hfigs(ind)  = figure('visible',vis); hold on; box on; grid on;
    par.hfig    = hfigs(ind);
    par.times   = times;
    par.fill    = 1;
    hmeans      = gobjects(length(b),1);
    for ip=1:length(b)
        means       = mPB(:,b(ip));
        sigmas      = sPB(:,b(ip));

        par.c1      = c1(b(ip),:);
        par.c2      = c2(b(ip),:);
        par.c3      = c3(b(ip),:);

        o           = plotMeanAndVariancePlus(means,sigmas,par);
        hmeans(ip)  = o.hmean;
    end
    
    
    xlabel('Trial')
    if newone
        xticks(1:Mtim)
        ylabel('Expected FE');
    else
        xticks(times)
        yticks(0.0:0.2:1.0);
        ylabel('Policy Prob');
    end
%     legend(hmeans,polInfo.policy_labels(b),'location','southoutside','NumColumns',1);

    if length(b)==25
        legend(hmeans,polInfo.policy_labels(b),'location','bestoutside','NumColumns',1); p([3:4])=[2000,700];
    else
        legend(hmeans,polInfo.policy_labels(b),'NumColumns',1,'location','west');
    end
    xlim([min(times),max(times)])
    nf=[nf 'PolicyPB'];
end

ind=3;
if wo(ind)
    hfigs(ind)=figure('visible',vis); hold on; box on; grid on;
    
%     plot(entropy_A1s,pGSs,'ko','MarkerSize',6);
    plot(entropy_A1s,pGLs,'ko','MarkerSize',6);
    
    xlabel('Entropy Belief White Agent');
    ylabel('Prob of signaling policy');
    if wo(6)
        xlim([0.6,1]);
    else
        xlim([-inf,1]);
    end
    dy  =0.05;
    ylim([0-dy,1+dy]);
    nf  =[nf 'Entropy'];
end

ind=4;
if wo(ind)
    hfigs(ind)  = figure('visible',vis); hold on; box on; grid on;
    par.hfig    = hfigs(ind);
    par.times   = times;
    par.fill    = 1;
    hmeans      = gobjects(length(b),1);
    for ip=1:length(b)
%         means       = mPB(:,b(ip));
%         sigmas      = sPB(:,b(ip));
        means       = mGG(:,b(ip));
        sigmas      = sGG(:,b(ip));

        par.c1      = c1(b(ip),:);
        par.c2      = c2(b(ip),:);
        par.c3      = c3(b(ip),:);

        o           = plotMeanAndVariancePlus(means,sigmas,par);
        hmeans(ip)  = o.hmean;
    end
    
    ylabel('Policy Prob');
    xlabel('Trial')
    xticks(times)
    yticks(0.0:0.2:1.0);
    if length(b)==25
        legend(hmeans,polInfo.policy_labels(b),'location','bestoutside','NumColumns',1); p([3:4])=[2000,700];
    else
        legend(hmeans,polInfo.policy_labels(b),'NumColumns',1,'location','west');
    end
    xlim([min(times),max(times)])
    nf=[nf 'PolicyPBG'];
end

ind=5;
if wo(ind)
    hfigs(ind)=figure('visible',vis); hold on; box on; grid on;
    
    ccmaps=c1(b,:);
    plot(entropy_A1s,GLs,'o','MarkerSize',6,'color',ccmaps(1,:));
%     plot(entropy_A1s,GSs,'o','MarkerSize',6,'color',cmaps(2,:));
    
    xlabel('Entropy Belief White Agent');
    ylabel('Prob of signaling policy');
%     xlim([-inf,1]);
%     dy  =0.05;
%     ylim([0-dy,1+dy]);
    nf  =[nf 'EntropyG'];
end
ind=6;
if wo(ind)
%    tmp_bin;
   [hfigs(ind),add]=tmp_bin(entropy_A1s,pGLs,pGSs,cmaps,b,vis);
   nf=[nf add];
end
%% save figure
save_dir='traces/';
nf = [save_dir, nf];

for iw=1:length(wo)
%     figure(iF);
    iF=wo(iw);
    if iF
        ha=findobj(hfigs(iw), 'Type', 'Axes');
        set(ha,'fontsize',fs);
    end
end


if Nf==1
    hfig=hfigs(wo);
else
    hfigs=hfigs(wo);
%     vis='on';
    hfig=figure('visible',vis);
    ax = gobjects(Nf,1);

    % Now copy contents of each figure over to destination figure
    % Modify position of each axes as it is transferred
    for i = 1:Nf
        %% create subplot
        ax(i)=subplot(Nf,1,i);
        h = get(hfigs(i),'Children');
        %% copy current figure
        newh = copyobj(h,hfig);
        %% set current figure in the subplot position
        for j = 1:length(newh)
            posnewh = get(newh(j),'Position');
            possub  = get(ax(i),'Position');
            
            set(newh(j),'Position',...
            [posnewh(1) possub(2) posnewh(3) possub(4)]);
        end
        %% eliminate the xlabel string from all but last
        if i==1 && sum(wo(1:2))>1
            oa=findobj(newh,'Type','Axes');
            oa.XLabel.String='';
        end
        delete(ax(i));
    end
    %% align axes
    ha=findobj(hfig, 'Type', 'Axes');
    for ia=1:length(ha)
       ha(ia).Position([1,3])=ha(1).Position([1,3]);    
    end
    %% reset legend
    ha=findobj(hfig, 'Type', 'Legend');
    for ia=1:length(ha)
       ha(ia).Location='Best';
    end
    %% ad hoc for this graph: do not replicate same legend
    if Nf==2
        if ~length(ha)==1
            ha(1).Visible='off';
            set(ha(2),...
            'Position',[0.301889900662252 0.466619909231729 0.433112570880265 0.0596221943672878]);
        end
        if wo(6)
%             set(ha(1),'Position',[0.623898744250774 0.367047678215622 0.0986754947545512 0.0636822176911642]);
            set(ha(1),'Position',[0.609329207826933 0.417207971075749 0.0986754947545513 0.0642443558044532]);
        end
    end
    if Nf==3
        if wo(6)
%             set(ha(2),...
%             'Position',[0.301889900662252 0.466619909231729 0.433112570880265 0.0596221943672878]);
%             set(ha(1),'Position',[0.622792728850665 0.272474007766316 0.0986754947545513 0.052935009045171]);
            set(ha(1),'Position',[0.868488093089076 0.191225573686068 0.0986754947545511 0.066584917037951]);
        else
%             ha(1).Visible='off';
            set(ha(2),...
            'Position',[0.306241727804901 0.625119805128299 0.433112570880265 0.0565509503125343],...
            'NumColumns',2,...
            'Box','off');
        end
    end

    if Nf==2
        p(4)=800;
    elseif Nf==3
        p(4)=1200;
    end

end

set(hfig, 'PaperPositionMode','auto');
set(hfig,'Position',p);
% set(hfig,'visible','on');

% pause(1);
fprintf('Saving %s\n',nf);
print(hfig,[nf '.eps'],'-depsc2');
print(hfig,[nf '.jpg'],'-djpeg');
savefig(hfig,[nf '.fig']);

% close all;


% if 0
%     ifsubplot=1;
%     
%     hfig=figure;
%     if ifsubplot
%         subplot(2,1,2);
%     end
%     hold on; box on; grid on;
%     plot(entropy_A1s,pGSs,'ko','MarkerSize',6);
%     
%     xlabel('Entropy Belief White Agent');
%     ylabel('Prob of signaling policy');
%     xlim([-inf,1]);
%     dy=0.05;
%     ylim([0-dy,1+dy]);
% 
%     p=[0,0,1500,600];
%     fs=16;
%     set(gca,'fontsize',fs);
% %     set(hfig,'visible','off');
%     set(hfig, 'PaperPositionMode','auto');
%     set(hfig,'Position',p);
%     fn='HarisEntropy';
%     save_dir='traces/';
%     nf = [save_dir, fn];
%     if ~ifsubplot
%         fprintf('Saving %s\n',nf);
%         print(hfig,[nf '.eps'],'-depsc2');
%         print(hfig,[nf '.jpg'],'-djpeg');
%         savefig(hfig,[nf '.fig']);
%         close all;
%         hfig=figure;
%         fn='HarisPolicy';
%         nf = [save_dir, fn];
%     else
%         subplot(2,1,1);
%         fn='HarisPolicyEntropy';
%         nf = [save_dir, fn];
%         
%     end
%     hold on; box on; grid on;
%     par.hfig    = hfig;
%     par.times   = times;
%     par.fill    = 1;
%     hmeans      = gobjects(length(b),1);
%     for ip=1:length(b)
%         means =mPB(:,b(ip));
%         sigmas=sPB(:,b(ip));
%         par.c1=c1(b(ip),:);
%         par.c2=c2(b(ip),:);
%         par.c3=c3(b(ip),:);
%         o=plotMeanAndVariancePlus(means,sigmas,par);
%         hmeans(ip)=o.hmean;
%     end
%     ylabel ('Policy Prob');
%     xlabel('Trial')
%     xticks(times)
% %     xticks(times(1:3:end))
% %     xticklabels(1:15);
%     
%     legend1=legend(hmeans,polInfo.policy_labels(b),'location','southoutside','NumColumns',1);
%     xlim([min(times),max(times)])
% %     xlim([1,28]);
%     set(gca,'fontsize',fs);
%     if ifsubplot
%         set(legend1,...
%             'Position',[0.13633333971103 0.727274742559951 0.461999987244606 0.0762839858445505]);
%     end
%     set(hfig,'visible','off');
%     set(hfig, 'PaperPositionMode','auto');
%     set(hfig,'Position',p);
%     fprintf('Saving %s\n',nf);
%     print(hfig,[nf '.eps'],'-depsc2');
%     print(hfig,[nf '.jpg'],'-djpeg');
%     savefig(hfig,[nf '.fig']);
%     close all;
% end

% convertEPS2PSD_cell({save_dir});
convertEPS2PDF({save_dir});