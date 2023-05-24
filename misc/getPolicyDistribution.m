function [mm,nmm]=getPolicyDistribution(indRep,GK1)
% priorparams=custom_simmetric_maze_open;
% indRep=1;
mm=squeeze(GK1(indRep,:,:)); % 100x30x25

% Nreps   =size(GK1,1);
Ntrials =size(GK1,2);
Np      =size(GK1,3);


li=14;
[a,b]=sort(mm(li,:),'descend');

b=b(1:8);
TR=[1,2,14,15,16];
TR=[1:3:30];
% TR=1:30;
mm=mm(TR,:);
for ip=1:Np
    mm(:,ip)=smooth(mm(:,ip));
end

nmm=nan(Ntrials,Np);
for ip=1:Np
    nmm(:,ip)=interp1(TR,mm(:,ip),1:Ntrials,'pchip','extrap');
end
mm=nmm;

% mmo = mm;
mm=softmax(mm')';
return
figure; hold on;
plot(1:Ntrials,mm(:,b),'linewidth',2);
beststr='northoutside';
% beststr='best';
legend(priorparams.policy_labels(b),'location',beststr);
% xlim([1,10])