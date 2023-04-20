%% function out=status_certainty(x1,x2)
function out=status_certainty(x1,x2)
a1=abs(diff(x1))+0.5;
a2=abs(diff(x2))+0.5;
out=min(a1*a2+0.5,1);