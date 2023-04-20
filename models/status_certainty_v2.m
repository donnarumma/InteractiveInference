%% function out=status_certainty_v2(x1,x2,params)
function [out,x]=status_certainty_v2(x1,x2,params)
    try
        h=params.h_A;
    catch
        h=4;
    end
    try
        k=params.K_A;
    catch
        k=10;
    end
    
    x   = abs(diff(x1).*diff(x2));
    out = 1./(1+h*exp(-k*x));
return