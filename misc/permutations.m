function p=permutations(Labels, Slots)
%% function p=permutations(Labels, Slots)
% Labels= number of labels (base)
% example: Labels=4; Slots=3; p=permutations_Labels_Slots(Labels, Slots);

hm = Labels^Slots;                  % number of permutations
p=dec2base(0:hm-1,Labels) -'0' + 1; % Labels is the base
p(p>10)=p(p>10)-7;
return
% for i=1:size(p,2)
%     p(p(:,i)>10)=p(p(:,i)>10)-7;
%     p
%     pause
% end