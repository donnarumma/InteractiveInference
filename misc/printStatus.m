function s=printStatus(t,u1,u2,s1,s2)

% u1=mdp{1}{t}.u(t-1);
% u2=mdp{2}{t}.u(t-1);

% s1=mdp{1}{t}.s(1,t);
% s2=mdp{2}{t+1}.s(1,t);
% B1=mdp{1}{t}.X{2}(:,t-1);
% B2=mdp{2}{t}.X{2}(:,t-1);

s=sprintf('Time: %g; Actions: (%s,%s);\tLocations: (%g,%g).',    ...
            t-1,                                                                                                              ...
            actionString(u1),actionString(u2),                                                  ...
            s1,s2);