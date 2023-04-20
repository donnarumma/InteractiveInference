function params=getLFmirrorparams(role1,role2,jointgoal)
%% function params=getLFmirrorparams()
% 1 - square - blue   
% 0 - circle - red
VARIABLES_Djoint
params                                  =getDefaultMirrorParams;
goal                                    =jointgoal;
squareT                                 =[goal,goal];
blue1                                   =squareT(1);
blue2                                   =squareT(2);
Nichanges                               =length(params.ichange);
params.squareT                          =repmat([goal,goal],Nichanges,1);

params.role                             =ones(Nichanges,2).*[role1,role2];

%%                                     blue-blue  blue-red red-blue  red-red
for iT=1:params.Nagents
    params.iB{iT}                       =nan(size(params.bchange,1),2^size(params.squareT,2));
end

try
    params.iB{1}(params.bchange(:,1),:)     =[ blue1 &  blue2,  ...
                                               blue1 & ~blue2,  ...     
                                              ~blue1 &  blue2,  ...
                                              ~blue1 & ~blue2];  % follower knows that red is the goal
catch
end
try
    params.iB{2}(params.bchange(:,2),:)     =[ blue1 &  blue2,  ...
                                               blue1 & ~blue2,  ...     
                                              ~blue1 &  blue2,  ...
                                              ~blue1 & ~blue2];  % follower knows to be mirror 
catch
end
for iT=1:size(params.role,2)
    for iR=1:Nichanges
        if params.bchange(iR,iT)
            r=params.role(iR,iT);
            if r==FOLLOWER  
                params.iB{iT}(iR,[2:3])=false;
                params.iB{iT}(iR,[1,4])=true;
            elseif r==LEADER
                params.iB{iT}(iR,[3:4])=max(params.iB{iT}(iR,[3:4]));
                params.iB{iT}(iR,[1:2])=max(params.iB{iT}(iR,[1:2]));
            end
        end
    end
end


for iT=1:params.Nagents
    params.iB{iT}=params.iB{iT}./sum(params.iB{iT},2);
end
%%
return
