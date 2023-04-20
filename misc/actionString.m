%% function sa=actionString(aa)
function sa=actionString(aa)
a = ceil(aa/5);
    if a==1
    	sa='up';
    elseif a==2
        sa='down';
    elseif a==3
        sa='left';
    elseif a==4
        sa='right';
    elseif a==5
        sa='wait';
    end
end
        
        