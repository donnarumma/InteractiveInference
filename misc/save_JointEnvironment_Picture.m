function save_JointEnvironment_Picture()
% function save_JointEnvironment_Picture()
params              = custom_simmetric_maze_open();
[states, maze]      = maze_create(params.MAZE);

T1.Ns               = [sum(params.MAZE(:)),4,sum(params.MAZE(:))];
T1.Nu               = numel(params.MAZE);
B                   = getB_MAZE2D_PAR_debug(T1,states,maze,1);
params.mdp{1}{1}.B  = B;
params.mdp{2}{1}.B  = B;
params.source_images= './show/';
params.ActionList   = getActionList(params.Nactions, 2);
hfig                = showPolicy_Djoint ([25,25],1,params);
title('');
xlabel('');

dx=0.6; dy=0.2;

iT1=params.startT1;
XY=states{iT1};Y=XY(1);X=XY(2);
text(X+dx,Y-dy,'\bf WHITE');
text(X+dx,Y+dy,'\bf AGENT');

iT2=params.startT2;
XY=states{iT2};Y=XY(1);X=XY(2);
text(X-2*dx-0.3,Y-dy,'\bf  GREY');
text(X-2*dx-0.3,Y+dy,'\bf AGENT');

save_dir='show/';
nf   = [save_dir '/ENVIRONMENT'];
fprintf('Saving %s\n', nf);
print(hfig,[nf '.jpg'],'-djpeg');
print(hfig,[nf '.eps'],'-depsc2');
savefig(hfig,[nf '.fig']);
convertEPS2PSD_cell({save_dir});

