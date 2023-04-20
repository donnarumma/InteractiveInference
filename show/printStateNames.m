%% function printStateNames(states,locname)

function printStateNames(states,locname)
dp=[0.35,0.45];
try 
    l=locname;
catch
    l='L';
end
for i=1:length(states)
    XY=states{i}-dp;Y=XY(1);X=XY(2);
    text(X,Y,[l num2str(i)])
end
