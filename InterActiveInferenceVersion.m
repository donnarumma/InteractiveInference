function out = InterActiveInferenceVersion()
%% function out = InterActiveInferenceVersion() 
v=load("version.txt");
s=sprintf('v%d',v);
if nargout>0
    out=s;
else
    fprintf('%s\n',s);
end

