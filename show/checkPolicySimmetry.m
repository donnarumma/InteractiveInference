%% function out=checkPolicySimmetry(V1,V2,ActionList)
function out=checkPolicySimmetry(V1,V2,ActionList)
out=isequal(mirrorPolicy(V1,ActionList),V2);