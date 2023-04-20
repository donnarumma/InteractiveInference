%% function score=Djoint_AnalyzeTraj_21Maze(Traj,goalposition)
function score=Djoint_AnalyzeTraj_21MazeSuccess(Traj1,Traj2,circleposition,squareposition)

% short   = PAR.short;
% signal  = PAR.signal;
wrong   = 0;
score=wrong;
Traj1=Traj1(~isnan(Traj1));
Traj2=Traj2(~isnan(Traj2));

if Traj1(end)==Traj2(end) && Traj1(end)==circleposition
    score=circleposition;
elseif Traj1(end)==Traj2(end) && Traj1(end)==squareposition
    score=squareposition;
end
%     if ismember(center,Traj)
%         score=short;
%     else
%         score=signal;
%     end
end
