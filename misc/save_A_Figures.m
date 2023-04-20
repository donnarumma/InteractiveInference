
function all=save_A_Figures(modes)
%% function all=save_A_Figures

close all;
try
    modes;
catch
    modes=1;
    modes=2;
    modes=3;
    modes=4;
    modes=5;
end
MAZE=[1     1     1     1     1; ...
      1     0     1     0     1; ...
      1     1     1     1     1; ...
      1     0     1     0     1; ...
      1     1     1     1     1];

square                          =1; %% square

Nactions                        =5;
if modes==4 || modes==3
    no_coactor_location_uncertainty =1;
else
    no_coactor_location_uncertainty =0;
end
cirgoal                         =10;
squargoal                       =12;
% T1state                         =19;
T2state                         =3;
nsplits                         =0;
lambda                          =0;

[locations, maze]               =maze_create(MAZE);

Dvals       =cell(0,0);


% Dvals{end+1}=[0.0;0.0;0.0;1.0];
% Dvals{end+1}=[0.1;0.0;0.0;0.9];
% Dvals{end+1}=[0.2;0.0;0.0;0.8];
% Dvals{end+1}=[0.3;0.0;0.0;0.7];
% Dvals{end+1}=[0.4;0.0;0.0;0.6];
Dvals{end+1}=[0.5;0.0;0.0;0.5];
% Dvals{end+1}=[0.6;0.0;0.0;0.4];
Dvals{end+1}=[0.7;0.0;0.0;0.3];
% Dvals{end+1}=[0.8;0.0;0.0;0.2];
Dvals{end+1}=[0.9;0.0;0.0;0.1];
% Dvals{end+1}=[1.0;0.0;0.0;0.0];

cases       = {'SS','SC','CS','CC'};

Nstates     =numel(locations);
Nbeliefs    =length(Dvals);
Ncases      =length(cases);

all        =nan(Nbeliefs,Ncases,Nstates);
if modes==4 || modes==5
    all=nan(Nbeliefs,Ncases,Nstates,Nstates);
end
for ind=1:Nbeliefs
    T=struct();
    T.D{2}                          =Dvals{ind};
%     T1col                           =zeros(Nstates,1);
%     T2col                           =zeros(Nstates,1);
%     T1col(T1state)                  =1;
%     T2col(T2state)                  =1;


    T.No                            =[Nstates, Nstates, 4 , 3];
    T.Ns                            =[Nstates, 4, Nstates];
    T.Nu                            =Nactions^2;
    T.isleader                      =0;


    belief_propagation              =1;
    T.B                             = getB_MAZE2D_PAR_debug(T,locations,maze,belief_propagation);

    
    A = getA_MAZE2D_PAR_debug(T,locations,squargoal,cirgoal,square,lambda,nsplits,no_coactor_location_uncertainty);
    wo = '3';
    % return
    % A_M=params.mdp{1}{1}.A{3}{1};
    for rg=1:Ncases
    
        if     modes==1
            A_M=A{3}{1};
            sqA         =squeeze(A_M(1,:,rg,T2state));
            wo='3_m1';
        elseif modes==2
            A_M=A{3}{1};
            sqA         =squeeze(A_M(rg,:,rg,T2state));
            wo='3_m2';
        elseif modes==3
            A_M=A{3}{1};
            N=19;
%             N= 3;
            sqA         =squeeze(A_M(rg,N,rg,:));
%             sqA         =squeeze(A_M(rg,:,rg,N));

            wo=['3_env' num2str(N)];
        elseif modes==4
            A_M=A{3}{1};
            sqA         =squeeze(A_M(rg,:,rg,:));
            all(ind,rg,:,:)=sqA;
        elseif modes==5
            wo='2';
            A_M=A{2}{1};
            sqA         =squeeze(A_M(:,:,rg,T2state));
            all(ind,rg,:,:)=sqA;
        end
%         RESA{ind,rg}=sqA;
        if modes<4%%~(modes~=4 || modes~=5)
            all(ind,rg,:)=sqA;
        end
    end
end

% allcol=rescale(all,0,1);
allcol = all;
% if modes==4
%     allcol=round(allcol*1000)/1000;
% end
ucols  =unique(allcol(:));
Ncols  =length(ucols);

cmapname   ='jet';
% cmapname   ='gray';
% cmapname   ='summer';
% cmapname   ='hot';

dummyfigure=figure('visible','off');
cmaps      =colormap(cmapname);
dummybar   =colorbar;
Nticks     =length(dummybar.TickLabels);
close(dummyfigure);
%% create a palette mapping the corresponding values of probabilities from cmaps corresponding to ucols
tot     =size(cmaps,1);        
inds    =round(linspace(1,tot,Ncols));
palette =cmaps(inds,:);
CLIM    = [min(allcol(:)) max(allcol(:))];
%% create tick values reflecting ucols values
ibar  =round(linspace(1,Ncols,Nticks));
nticks=round(100*ucols(ibar))/100;
   
for ind=1:Nbeliefs
    for rg=1:Ncases
        
        sqA=squeeze(allcol(ind,rg,:));
        if modes==4 || modes==5
            sqA=squeeze(allcol(ind,rg,:,:));
            imagesc(sqA,CLIM);
            hfig=gcf;
        end
       
        
        if 0
            col         =repmat(sqA,1,3);
        elseif modes<4%~(modes~=4 || modes~=5)
            col=nan(Nstates,3);
            for is=1:Nstates
                col(is,:)=palette(ismember(ucols,sqA(is)),:);
            end

            hfig    =showEnvironment_Djoint(MAZE,col);
            printStateNames(locations);
            set(hfig,'visible','off');
        
        end
        %% choose colormap
        colormap(cmapname);
        hbar=colorbar;
        
        if modes~=4
            hbar.TickLabels=num2cell(nticks);
        end
        % imagesc(sqA);colormap gray;
        axis square;
        
        case_str    =cases{rg};
        Dstr        = num2str(round(Dvals{ind}(1)*100));
        title([case_str Dstr]);

        save_dir = '~/tmp/AFigures/';
        if ~isfolder(save_dir)
            mkdir(save_dir);
        end
        nf   = [save_dir '/A' wo '_' case_str Dstr];
        fprintf('Saving %s\n', nf);
        print(hfig,[nf '.jpg'],'-djpeg');
        print(hfig,[nf '.eps'],'-depsc2');

        savefig(hfig,[nf '.fig']);
        close all;
    end
end

convertEPS2PSD_cell({save_dir});

