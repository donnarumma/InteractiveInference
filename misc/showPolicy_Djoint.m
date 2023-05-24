function hfig=showPolicy_Djoint (V,AgentId,params)
MAZE             = params.MAZE;
states           = maze_create(MAZE);
mdp              = params.mdp;
simg             = params.source_images;
squargoal        = params.squargoal;      % point where is placed the square
cirgoal          = params.cirgoal;        % point where is placed the circle
Ci               = states{cirgoal};
Sq               = states{squargoal};
try
    fprintf('%s\n',params.description);
catch
    fprintf('%s')
end
Nagents          =length(mdp);
i1               =AgentId;     %% AgentId    
i2               =3-AgentId;   %% Complementary Id

Uid              = V;
Uid_mirror       = mirrorPolicy(Uid,params.ActionList);

if AgentId==1
    Uid1    =Uid;    
    Vs(i1,:)=Uid;
    Vs(i2,:)=Uid_mirror;
    Uid2=Uid_mirror;
elseif AgentId==2
    Uid1    =Uid_mirror;
    Vs(i1,:)=Uid_mirror;
    Vs(i2,:)=Uid;
    Uid2    =Uid;
end
starts             =[params.startT1, params.startT2];

S{1}(1)            = starts(1);
S{2}(1)            = starts(2);

B1=mdp{1}{1}.B{1};
B3=mdp{1}{1}.B{3};

Tt=length(Uid);
for i=1:Tt
    [~,S{1}(i+1)]=max(B1(:,S{1}(i),Uid1(i)));
    [~,S{2}(i+1)]=max(B3(:,S{2}(i),Uid1(i)));
end

        
agentname       ={'Agent 1 (white)','Agent 2 (gray)'};
tp              = 1; %% visual delay   

%% need params + S{1}, S{2} + Uid
hfig            = showEnvironment(MAZE); colormap gray; axis on; xticks([]); yticks([]);

imgTravBoth     = imread([simg '/h_common.png']);
imgTrav         = imread([simg '/HAND1.png']);


imgCheese       = imread([simg '/red_button.jpg']);   %  square - cheese - red button
imsCheeseBoth   = imread([simg '/h_common_red.jpg']); 
imgWater        = imread([simg '/blue_button.jpg']);  %  circle - water  - blue button
imsWaterBoth    = imread([simg '/h_common_blue.jpg']); 

a               = min(imgTrav(:));
mina            = imgTrav==a;

dI              = 50;
imgTrav1        = imgTrav+dI;
imgTrav2        = imgTrav;

imgTrav1(mina)  = a;
imgTrav2(mina)  = a;

imgTrav2        = imgTrav2(:,end:-1:1,:);

ims{1,1}        = imgTrav1;
ims{2,1}        = imgTrav2;
ims{3,1}        = imgTravBoth;


rat             = [imagesc([]),imagesc([])];

rdi             = 0.45;

%% PLOT GOALS
rdi             = rdi-0.15;
imagesc([Ci(2)-rdi,Ci(2)+rdi], [Ci(1)-rdi,Ci(1)+rdi],imgCheese); %axis off;
imagesc([Sq(2)-rdi,Sq(2)+rdi], [Sq(1)-rdi,Sq(1)+rdi],imgWater ); %axis off;
rdi             = 0.45;


%%
Stc(1,:)        =states{S{1}(1)};
Stc(2,:)        =states{S{2}(1)};

tstart=0;
fprintf('Time: %g; N. Agents %g;\t\tLocations: (%g,%g).\n',        ...
        tstart,                                                  ...
        Nagents,                                            ...
        S{1}(1),S{2}(1)                                     ...
        );

Stcold =nan(2,2);
        
for iR=1:Nagents
    rat(iR)=imagesc([Stc(iR,2)-rdi,Stc(iR,2)+rdi], [Stc(iR,1)-rdi,Stc(iR,1)+rdi],ims{iR}); %axis off;
                    tmpstr=sprintf('%s starts in L%g',agentname{iR},S{iR}(1));
                    title(tmpstr);
                    xlabel(sprintf('Time %g',tstart))
                    % imwrite(rat(iR).CData,[save_dir 'Agent' num2tr(iR)'.jpg']);
                    printStateNames(states);
    pause (tp) %
end
imageinfo.ims          =ims;
imageinfo.rdi          =rdi;
imageinfo.imsCheeseBoth=imsCheeseBoth;
imageinfo.imsWaterBoth =imsWaterBoth;
imageinfo.agentname    =agentname;
imageinfo.states       =states;
imageinfo.Ci           =Ci;
imageinfo.Sq           =Sq;

for ind=1:Tt
    %% print Status
    s1=S{1}(ind+1); s2=S{2}(ind+1); u1=Uid1(ind); u2=Uid2(ind); s=printStatus(ind+1,u1,u2,s1,s2); fprintf('%s\n',s);

    %% states and move
    Stc(1,:)=states{S{1}(ind+1)};
    Stc(2,:)=states{S{2}(ind+1)};
    moveT1  =Uid1(ind);
    moveT2  =Uid2(ind);
    move    =[moveT1,moveT2];
    for iR=1:Nagents
        rat=updateOneStepPlot(ind+tstart,Stc,move,Stcold,iR,rat,imageinfo);
        pause (tp) %     hgexport(gcf,[save_dir nf num2str(stamp) '.eps']);        
    end

    Stcold=Stc;
end

fprintf ('Leader   Policy '); fprintf('%g ',Vs(i1,:)); if AgentId==1;fprintf('(original)'); end; fprintf('\n');
fprintf ('Follower Policy '); fprintf('%g ',Vs(i2,:)); if AgentId==2;fprintf('(mirrored)'); end; fprintf('\n');
