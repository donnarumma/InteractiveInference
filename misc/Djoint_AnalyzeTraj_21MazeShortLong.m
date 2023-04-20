%% function score=Djoint_AnalyzeTraj_21MazeShortLong(Traj,PAR)
function score=Djoint_AnalyzeTraj_21MazeShortLong(Traj,PAR)

short   = PAR.short;
long    = PAR.long;
center  = PAR.center;
Traj=Traj(~isnan(Traj));
% if ismember(center,Traj)
if sum(ismember(center,Traj))
    score=short;
else
    score=long;
end
