%% function visual_trace_free_energy
% example: visual_trace_free_energy('OPEN_LF_A15050S_A25050_SIM',102,8,1,1);

function out=visual_trace_free_energy(test_name,indRepetition,indTrial,indAgent,time,test_dir)

params=loadTrialRepetition(test_name,indRepetition,indTrial,test_dir);
try 
    time;
catch
    time=1;
end

if params.ifshuffle
    if params.ifshuffle==1
        permV=params.permV;
    elseif params.ifshuffle==2
        permV=params.(['permV' num2str(indAgent)]);
    end
else
    permV=1:size(params.(['V' num2str(indAgent)]),2);
end

out=Djoint_single_visual_trace_t(params.mdp{indAgent}{end},time,params.custom_maze,permV,0);
close(out.hfigActionSelection);
hfig=out.hfigFreeEnergies;

p=[0,0,1500,1000];
fs=14;
set(hfig,'visible','off');
set(gca,'fontsize',fs);
ylabel('Expected Free Energy');
if indAgent==1
    xlabel(['Policy of white agent']);
elseif indAgent==2
    xlabel(['Policy of grey agent']);
end
set(hfig, 'PaperPositionMode','auto');
set(hfig,'Position',p);
save_dir=params.save_dir;
% return
pause(1);
sf=[save_dir '/' params.description '_TRIAL' num2str(indTrial) '_FreeEnergy_Agent' num2str(indAgent)];
    fprintf('Saving %s\n',sf);
    print(hfig,'-depsc2',[sf '.eps']);
    print(hfig,'-djpeg',[sf '.jpg']);
    savefig(hfig,[sf '.fig']);
    convertEPS2PDF({save_dir});
return
%%