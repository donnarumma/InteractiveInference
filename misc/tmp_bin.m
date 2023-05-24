function [hfig, add]=tmp_bin(entropy_A1s,pGLs,pGSs,cmaps,b,vis)
[valS,insS]=sort(entropy_A1s);
entropy_A1sorted    =entropy_A1s(insS);
pGLsorted           =pGLs(insS);
pGSsorted           =pGSs(insS);
dx =0.05;
stx=0.6;
% clear interval;
interval(1,:)=     stx:dx:(1-dx);
interval(2,:)=(stx+dx):dx:1;
Nbins=size(interval,2);
bin=nan(Nbins,length(insS));
for ib=1:Nbins
    bin(ib,:)= entropy_A1sorted>=interval(1,ib) & entropy_A1sorted<interval(2,ib);
end
hm=min(sum(bin,2));

bin100=nan(Nbins,hm);
for ib=1:Nbins
    indbin=find(bin(ib,:));
    bin100(ib,:)=indbin(randperm(length(indbin),hm));
end

Signaling   =nan(Nbins,1);
NotSignaling=nan(Nbins,1);
for ib=1:Nbins
    Signaling(ib)       =(sum(rand(hm,1) < pGLsorted(bin100(ib,:)))/hm)*100;
    NotSignaling(ib,:)  =(sum(rand(hm,1) < pGSsorted(bin100(ib,:)))/hm)*100;
end

hfig=figure('visible',vis); hold on; box on; grid on; 
BV=-1;
DS=5;
Signaling   (5)=Signaling   (5)+DS;
NotSignaling(5)=NotSignaling(5)-DS;
% bar([NotSignaling,Signaling],'BaseValue',BV);
bar([Signaling,NotSignaling],'BaseValue',BV);

colororder(cmaps(b,:));

% xlabel('Entropy Belief White Agent');
xlabel('Entropy of the joint goal context (White Agent)');
 
ylim([BV,101])
ylabel('% Policy');
for ib=1:Nbins
    labs{ib}=sprintf('(%g,%g)',interval(1,ib),interval(2,ib));
end
legend('Epistemic','Pragmatic');%,'Position',[0.623898744250774 0.367047678215622 0.0986754947545512 0.0636822176911642]);

xticklabels(labs);

add='barepistemic';