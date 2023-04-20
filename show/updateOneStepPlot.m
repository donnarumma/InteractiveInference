%% function rat=updateOneStepPlot(ind,Stc,move,Stcold,iR,rat,imageinfo)
function rat=updateOneStepPlot(ind,Stc,move,Stcold,iR,rat,imageinfo)
    ims          =imageinfo.ims;
    rdi          =imageinfo.rdi;
    imsCheeseBoth=imageinfo.imsCheeseBoth;
    imsWaterBoth =imageinfo.imsWaterBoth;
    agentname    =imageinfo.agentname;
    states       =imageinfo.states;
    Ci           =imageinfo.Ci;
    Sq           =imageinfo.Sq;
    
    if ~isequal(Stc(1,:),Stc(2,:)) && ~isequal(Stcold,Stc)
        try
            delete(rat(iR));
        catch
        end
        rat(iR)=imagesc([Stc(iR,2)-rdi,Stc(iR,2)+rdi], [Stc(iR,1)-rdi,Stc(iR,1)+rdi],ims{iR}); %axis off;
    end
    %% case Agents are on the same location
    if isequal(Stc(1,:),Stc(2,:)) && iR==1
        delete(rat(:));
        if isequal(Ci,Stc(1,:)) && isequal(Ci,Stc(2,:)) 
            rdi     =0.47;
            rat(1)  =imagesc([Stc(1,2)-rdi,Stc(1,2)+rdi], [Stc(1,1)-rdi,Stc(1,1)+rdi],imsCheeseBoth); % axis off;
        elseif isequal(Sq,Stc(1,:)) && isequal(Sq,Stc(2,:)) 
            rdi=0.47;
            rat(1)=imagesc([Stc(1,2)-rdi,Stc(1,2)+rdi], [Stc(1,1)-rdi,Stc(1,1)+rdi],imsWaterBoth); % axis off;
        else
            rat(1)=imagesc([Stc(1,2)-rdi,Stc(1,2)+rdi], [Stc(1,1)-rdi,Stc(1,1)+rdi],ims{3}); % axis off;
        end
        printStateNames(states);
        title(sprintf('%s %s',agentname{iR},actionString(move(iR))));
        xlabel(sprintf('Time %g',ind));
    end
    printStateNames(states);
    title(sprintf('%s %s',agentname{iR},actionString(move(iR))));
    xlabel(sprintf('Time %g',ind))
end