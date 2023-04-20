function Xi = salience_field(T,locs,squargoal,cirgoal)

for u = 1:T.Nu
    for s = 1:T.Ns(1)
        Xi(:,s) = cue_saliency(s,locs,squargoal,cirgoal);
    end
end


%%% AUX. FUN. %%%

function salvec = cue_saliency(s,states,squargoal,cirgoal,anchorst,pro)
%
% anchorst: is the state where the inertia is evaluated
%
% pro     : it holds in [0,1] (values quite beside to 1) and is a factor of deamplification applied to 
%           the distance of the context opposite to the current. It can be
%            considered as an inclination to not leave the current context
%

if nargin < 5
    kanchor = 0;
    pro = 1;
else
    dsqanchor = pdist([states{anchorst};states{squargoal}],'euclidean');
    dcranchor = pdist([states{anchorst};states{cirgoal}],'euclidean');
    kanchor = dsqanchor/dcranchor;
end

dsquare = pdist([states{s};states{squargoal}],'euclidean');
dcircle = pdist([states{s};states{cirgoal}],'euclidean');

if kanchor <= 1
    if dsquare <= dcircle
        k = dsquare/dcircle;
    else
        k = (pro*dsquare)/dcircle;
    end
else
    if dcircle <= dsquare
        k = dsquare/dcircle;
    else
        k = dsquare/(pro*dcircle);
    end
end

if k < Inf
    salvec = [1/(1+k);k/(k+1)];
else
    salvec = [0;1];
end
