%% function out=Djoint_single_visual_trace_t(mdp,t,custom_maze,permV,isvisible)
function out=Djoint_single_visual_trace_t(mdp,t,custom_maze,permV,isvisible)
% iT=1; %t=2;
try
    isvisible;
catch
    isvisible=0;
end

params=custom_maze();

mdp_iT=mdp;
wt =  find(mdp_iT.ut(:,t))';

Np=length(wt);
H=nan(Np,1);
D=nan(Np,1);
for k=1:Np
    hgj=nan(mdp_iT.Ng,mdp_iT.T);
    dgj=nan(mdp_iT.Ng,mdp_iT.T);
    for g=1:mdp_iT.Ng
        hgj(g,:)=computeH (mdp_iT,t,wt(k),g);
        dgj(g,:)=computeD (mdp_iT,t,wt(k),g);
    end
    ggj=hgj+dgj;
    out.H{k}=hgj;
    out.D{k}=hgj;
    out.G{k}=ggj;
    
    H(k)=nansum(hgj(:));
    D(k)=nansum(dgj(:));
end
G=H+D;

polInfo=DjointPolicies();
slab=polInfo.policy_labels;
try
    slab=slab(permV);
catch
end
out.labels = slab;
Nl=numel(slab);
cmaps=linspecer(Nl);
cmaps=cmaps(permV,:);
[bG, inds]=sort(G);
%% FREE ENERGY PLOT
hfig=figure('visible',isvisible); hold on; box on; grid on;
hh=gobjects(length(bG),1);

for i=1:length(bG)
    iin=inds(i);
    fprintf('P%g:\tH=%.4f\tD=%.4f\tG=%.4f\t%s\n',wt(inds(i)),H(iin),D(iin),G(iin),slab{wt(inds(i))})
    hh(i)=bar(i,bG(i),'facecolor',cmaps(wt(inds(i)),:));
end
legend(hh,slab(wt(inds)),'Location','southoutside');
xticks(1:Nl);

allU=1:mdp_iT.Nu;
ms=10;
%% ACTION PLOT
out.hfigFreeEnergies=hfig;
hfig=figure('visible',isvisible);hold on; box on; grid on; 
bar(allU,(mdp_iT.P(:,t)));
sel=logical(mdp_iT.U(:,t));

bar(allU(sel),(mdp_iT.P(sel,t)),'r');

xticks(1:params.Nactions^2)
xlabel('Joint Action u');
ylabel('Probability p(u)')
p=[0,0,1500,600];
fs=14;
set(gca,'fontsize',fs);
set(hfig, 'PaperPositionMode','auto');
set(hfig,'Position',p);
out.hfigActionSelection=hfig;