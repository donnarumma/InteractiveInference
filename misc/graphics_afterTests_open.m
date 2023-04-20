%% function graphics_afterTests_open(testname,NN,ichange,params)
function graphics_afterTests_open(params,spm_dir)
try
    woat=params.woat;
catch
    woat=[0,0,0,0,0,1,0];
end
testname=params.test_name;
NN      =params.iRepetition;
ichange =find(sum(params.bchange,2));
dj      =loadTrialResult(testname,NN,params.res_dir);

params.sequenceon   =~params.sequenceon;
getStatistics_Djoint_Plus(dj,woat,params);

hfig=gcf;
hLegend = findobj(gcf, 'Type', 'Legend');
Npl=length(hfig.Children)-length(hLegend);

rmpath(spm_dir);
col1=[0.3,0.5,0.3];
for ia=1:Npl
    subplot(Npl,1,ia); hold on; box on; grid on;
    if ia<Npl
        xlabel('');
    end
    plotChangesPoint_PlusTrial(ichange,col1);
end
addpath(spm_dir);

for ia=1:length(hLegend)
    hLegend(ia).String=hLegend(ia).String(1:end-length(ichange));
end

sf=[params.save_dir '/' params.description '_TrialLongShort'];
fprintf('Saving %s\n',sf);
print(hfig,'-depsc2',[sf '.eps']);
print(hfig,'-djpeg',[sf '.jpg']);
savefig(hfig,[sf '.fig']);
convertEPS2PDF({params.save_dir});

if NN==100
    visual_trace_free_energy(testname,100,1,1,1,params.test_dir); %% Agent 1
    visual_trace_free_energy(testname,100,1,2,1,params.test_dir); %% Agent 2
end
try
fprintf('Initial Beliefs: B1=[%g,%g,%g,%g], B2=[%g,%g,%g,%g], squareT=[%g,%g]\n',   ...
         params.ContextBelief{1},                                                   ...
         params.ContextBelief{2},                                                   ...
         params.squareF1,                                                           ...
         params.squareF2);
catch
end