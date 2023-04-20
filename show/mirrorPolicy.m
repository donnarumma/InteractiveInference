%% function Uid_mirror=mirrorPolicy(Uid,ActionList)

function Uid_mirror=mirrorPolicy(Uid,AL)

% AL=params.ActionList;
%% joint action list
na=AL(Uid,:);
%% invert columns
na=na(:,end:-1:1);
Uid_mirror=nan(size(Uid));
for i=1:length(na)
    %% find mirror uid index
    Uid_mirror(i)=find(sum(AL==na(i,:),2)==2);
end