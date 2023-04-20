%% function showResults_Djoint(params)

function res=showResults_Djoint(params)
wo            = params.wo; %[1,1,1,1]
MAZE          = params.MAZE;
states        = maze_create(MAZE);
squargoal     = params.squargoal;      % point where is placed the square
cirgoal       = params.cirgoal;        % point where is placed the circle
Ci            = states{cirgoal};
Sq            = states{squargoal};
mdp           = params.mdp;

agentname={'Agent 1 (white)','Agent 2 (gray)'};


Nagents =length(mdp);
Tn      =nan(Nagents,1);
TnV     =nan(Nagents,1);

for n=1:Nagents
%     Tn(n) =length(mdp{n});
    Tn(n) = mdp{n}{1}.T;
    TnV(n)=size(mdp{n}{end}.V,1);
end
Tmax    =min(Tn);
TVmax   =min(TnV);

strtitle='';
if sum(wo)>0
    save_dir      = params.save_dir;
    if ~isfolder(save_dir)
        mkdir(save_dir)
    end
end


if Tmax==TVmax
    TmS=Tmax-1;
else
    TmS=TVmax;
end
Tt=Tmax-1;

S{1}             = mdp{1}{end}.s(1,1:TmS);
S{2}             = mdp{2}{end}.s(1,1:TmS);
U1               = mdp{1}{end}.U(:,1:Tt);
[~,Uid1]         = max(U1);
U2               = mdp{2}{end}.U(:,1:Tt);
[~,Uid2]         = max(U2);

% mdp{1}{Tmax}.U=U1;
% mdp{2}{Tmax}.U=U2;
% mdp{1}{Tmax}.ut=mdp{1}{Tmax}.ut(:,1:Tt);
% mdp{2}{Tmax}.ut=mdp{2}{Tmax}.ut(:,1:Tt);

mdp{1}{end}.U=U1;
mdp{2}{end}.U=U2;
mdp{1}{end}.ut=mdp{1}{end}.ut(:,1:Tt);
mdp{2}{end}.ut=mdp{2}{end}.ut(:,1:Tt);


if wo(1)
    spm_figure('GetWin',['T1 Leader"' strtitle '"']); clf
%     spm_MDP_game_X_plot(params.mdp{1}{Tmax});
%     spm_MDP_game_X_plot(mdp{1}{Tmax});
    spm_MDP_game_X_plot(mdp{1}{end});
    hgexport(gcf,[params.save_dir  '/Leader.eps'])
end
if wo(2)
    spm_figure('GetWin',['T2 Follower "' strtitle '"']); clf
%     spm_MDP_game_X_plot(mdp{2}{Tmax});
    spm_MDP_game_X_plot(mdp{2}{end});
    hgexport(gcf,[params.save_dir  '/Follower.eps'])
end


res.S               =S;
res.Uid{1}          =Uid1;
res.Uid{2}          =Uid2;
res.ContextBelief{1}=mdp{1}{end}.X{2}(:,1:Tt);
res.ContextBelief{2}=mdp{2}{end}.X{2}(:,1:Tt);

if wo(3)
    simg          = params.source_images;
    sf            = params.sf;
    step_dir      = params.step_dir;
    if ~isfolder(step_dir)
        mkdir(step_dir)
    end
    hfig            = showEnvironment(MAZE); colormap gray; axis on; xticks([]); yticks([]);

    imgTrav         = imread([simg '/HAND1.png']);

    imgTravBoth     = imread([simg '/h_common.png']);

    imgCheese       = imread([simg '/red_button.jpg']);
    imsCheeseBoth   = imread([simg '/h_common_red.jpg']);

    imgWater        =  imread([simg '/blue_button.jpg']);
    imsWaterBoth    =  imread([simg '/h_common_blue.jpg']);

    a                = min(imgTrav(:));
    mina             = imgTrav==a;

    dI               = 50;
    imgTrav1         = imgTrav+dI;
    imgTrav2         = imgTrav;

    imgTrav1(mina)   = a;
    imgTrav2(mina)   = a;

    imgTrav2         = imgTrav2(:,end:-1:1,:);

    ims{1,1}         =imgTrav1;
    ims{2,1}         =imgTrav2;
    ims{3,1}         =imgTravBoth;

    rat              =[imagesc([]),imagesc([])];

    rdi    =0.45;

    tp     =1;
    stamp  =1;
    tstart =0;
    
    Nagents=length(mdp);
    Stc(1,:)=states{S{1}(1)};
    Stc(2,:)=states{S{2}(1)};
    
    
    %% PLOT GOALS
    rdi             = rdi-0.15;
    imagesc([Ci(2)-rdi,Ci(2)+rdi], [Ci(1)-rdi,Ci(1)+rdi],imgCheese); %axis off;
    imagesc([Sq(2)-rdi,Sq(2)+rdi], [Sq(1)-rdi,Sq(1)+rdi],imgWater ); %axis off;
    rdi             = 0.45;

    fprintf('%s\n',params.description);
    if ~checkPolicySimmetry(Uid1,Uid2,params.ActionList)
        fprintf('WARNING: NO POLICY SIMMETRY');
    end
    printDjoint(mdp,tstart+1);
    
    delete([step_dir sf '*.jpg']);
    for iR=1:Nagents
        rat(iR)=imagesc([Stc(iR,2)-rdi,Stc(iR,2)+rdi], [Stc(iR,1)-rdi,Stc(iR,1)+rdi],ims{iR}); %axis off;
                    tmpstr=sprintf('%s starts in L%g',agentname{iR},S{iR}(1));
                    title(tmpstr);
                    xlabel(sprintf('Time %g',tstart))
                    printStateNames(states);
        %% SAVE IMAGE STEP
%     	fprintf('Saving %s\n',[step_dir sf num2str(stamp) '.jpg']); 
        p=[0,0,800,600];
        set(hfig,'Position',p);
        print(hfig,[step_dir sf num2str(stamp) '.jpg'],'-djpeg'); stamp=stamp+1;
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
    
    Stcold =nan(2,2);
    
    TTT=min(size(mdp{1},2),size(mdp{2},2));

    for ind=1:TTT
%         ind
        printDjoint(mdp,ind+1);
        if (ind<Tt || (ind==Tt && Tmax<TVmax)) && ind+1<=TTT
            %% states and move
            Stc(1,:)=states{S{1}(ind+1)};
            Stc(2,:)=states{S{2}(ind+1)};
            moveT1  =Uid1(ind);
            moveT2  =Uid2(ind);
            move    =[moveT1,moveT2];

            for iR=1:Nagents 
                rat=updateOneStepPlot(ind+tstart,Stc,move,Stcold,iR,rat,imageinfo);
                %% SAVE IMAGE STEP
    %             fprintf('Saving %s\n',[step_dir sf num2str(stamp) '.jpg']); 
                p=[0,0,800,600];
                set(hfig,'Position',p);
                print(hfig,[step_dir sf num2str(stamp) '.jpg'],'-djpeg'); stamp=stamp+1; 
                pause (tp) %     hgexport(gcf,[step_dir nf num2str(stamp) '.eps']);
            end
            Stcold=Stc;
        end
    end

    params.extension   ='jpg';
    params.repetitions =10;
    params.ifisingle   =0;
    params.ifresize    =1;
    params.R           =600;
    params.C           =800;
    inname =[step_dir '/' sf];
    outname=[step_dir '/' params.description '_AGENTMOVIE_Trial' num2str(params.idx)];
%     fprintf('Saving %s.avi\n',outname);
    createMovie(inname,outname,params);
end

if wo(4)
    hfig=figure; hold on; box on; grid on;
    p=[0,0,1500,600];
    fs=16;
    subplot(2,1,1);
    times=1:size(res.ContextBelief{1},2);
    a=plot(res.ContextBelief{1}','linewidth',3);
    title('Agent 1 Belief on goal')
    xlabel('Step');
    ylabel('Prob');
    legend(a,'(Blue, Blue)','(Blue, Red)','(Red,Blue)','(Red, Red)');
    set(gca,'fontsize',fs);
    set(gca,'xtick',times);
    subplot(2,1,2);
    a=plot(res.ContextBelief{2}','linewidth',3);
    title('Agent 2 Belief on goal')
    xlabel('Step');
    ylabel('Prob');
    legend(a,'(Blue, Blue)','(Blue, Red)','(Red,Blue)','(Red, Red)');
    set(gca,'xtick',times);
    set(gca,'fontsize',fs);
%     set(hfig,'visible','off');
    set(hfig, 'PaperPositionMode','auto');
    set(hfig,'Position',p);
    
    sf=[save_dir '/' params.description '_Belief_TEST' num2str(params.idx)];
    fprintf('Saving %s\n',sf);
    print(hfig,'-depsc2',[sf '.eps']);
    savefig(hfig,[sf '.fig']);
    convertEPS2PDF({save_dir});
end

end