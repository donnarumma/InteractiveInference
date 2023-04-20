%% function ActionList=getActionList(params)

function ActionList=getActionList(Nactions,Nagents)

ActionList=permutations(Nactions, Nagents);
