function strpol=printPolinfo(trajpol,polInfo)
%% function strpol=printPolinfo(trajpol,polInfo)

%     {'T1, T2 long policy to circle'                              } LC1LC2 
% strpol1=sprintf('T1 %s policy to %s',            ...
%                  polInfo.TrajInfo{trajpol(1)},   ...
%                  polInfo.GoalInfo{trajpol(2)});
% strpol2=sprintf('T2 %s policy to %s',            ...
%                  polInfo.TrajInfo{trajpol(3)},   ...
%                  polInfo.GoalInfo{trajpol(4)});
strpol1=sprintf('White Agent %s policy to %s',            ...
                 polInfo.TrajInfo{trajpol(1)},   ...
                 polInfo.GoalInfo{trajpol(2)});
strpol2=sprintf('Grey Agent %s policy to %s',            ...
                 polInfo.TrajInfo{trajpol(3)},   ...
                 polInfo.GoalInfo{trajpol(4)});

strpol=sprintf('%s, %s',strpol1,strpol2);
fprintf('%s\n',strpol);

return
%% print all policies
Np      = size(polInfo.P_INDEX,1);
for ip=1:Np
    trajpol=polInfo.P_INDEX(ip,:);
    strpol=printPolinfo(trajpol,polInfo);
    allpolstr{ip}=strpol;
end
