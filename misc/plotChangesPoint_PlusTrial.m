function plotChangesPoint_PlusTrial(ichange,col)
yl=get(gca,'ylim');
% Len=(jstats.Ts)-1;
% NTrials=length(dj.results);
% Len=nan(NTrials,1);
% for itrial=1:NTrials
%     Len(itrial) = length(dj.results{itrial}.S{1});
%     z=find(dj.results{itrial}.S{1}==0,1);
%     if z
%         Len(itrial) = z-1;
%     end
% end
try
    col;
catch
    col=0.5*[1,1,1];
end
% before_change=ichange-1;
for x=ichange
    xx=[x,x];
    hl=plot(xx,yl,'color',col,'linewidth',5);
    hl.Color(4)=0.3;
    uistack(hl,'bottom');
end
ylim(yl);
