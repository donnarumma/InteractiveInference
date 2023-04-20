function [hfig,himg]=showEnvironment(MAZE,col)
[states, maze]=maze_create(MAZE);
cv = 0;
lw = 3;
try
    col;
catch
    col=1*ones(3,1); %% WHITE
end

hfig=figure; hold on;

%% BLACK BACKGROUND
% himg=imagesc(MAZE); colormap gray;

%% RECTANGLE STATES
axis equal;
[Mx, My]=size(MAZE);
dp=1/2;
set(gca,'YDir','reverse')
xlim([dp,Mx+dp]);
ylim([dp,My+dp]);
axis off
for i=1:length(states)
    XY=states{i};Y=XY(1);X=XY(2);
    rectangle('Position',[X-dp,Y-dp,1,1],'Curvature',cv,'linewidth',lw,'FaceColor',col);%'Linestyle','none');
%     fprintf('X=%g, Y=%g\n',X,Y);
end
  

%% OPENINGS
lw=lw+1; % larger lines
col =col-0.05;
for i=1:length(states)

    XY=states{i};Y=XY(1);X=XY(2);
    if Y<My
        if MAZE(Y+1,X)%1 %MAZE(X,Y+1)
            plot([X-dp/2,X+dp/2],[Y+dp,Y+dp],'color',col,'linewidth',lw);
        end
%         fprintf('X=%g, Y=%g\n',X,Y);        
    end
end

for i=1:length(states)

    XY=states{i};Y=XY(1);X=XY(2);
    if X<Mx
        if MAZE(Y,X+1)%1 %MAZE(X,Y+1)
            plot([X+dp,X+dp],[Y-dp/2,Y+dp/2],'color',col,'linewidth',lw);
        end
%         fprintf('X=%g, Y=%g\n',X,Y);        
    end
end