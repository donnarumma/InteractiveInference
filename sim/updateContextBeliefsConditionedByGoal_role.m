%% function [MDP_T1,MDP_T2,square,circle] = updateContextBeliefsConditionedByGoal_role(mdp_T1,mdp_T2,MDP_T1,MDP_T2,par)

function [MDP_T1,MDP_T2,square,circle] = updateContextBeliefsConditionedByGoal_role(mdp_T1,mdp_T2,MDP_T1,MDP_T2,par)
    
threshold=0.70;
square = 0;
circle = 0;
t = numel(find(mdp_T1.s(1,:)>0));

%% if they reach the same goal then 
if (mdp_T1.s(1,t) == mdp_T2.s(1,t)) && ((mdp_T1.s(1,t) == par.squargoal) || (mdp_T1.s(1,t) == par.cirgoal))
    
    squaresquare=(mdp_T1.s(1,t) == par.squargoal);
    circlecircle=(mdp_T1.s(1,t) == par.cirgoal);
    switch mdp_T1.s(1,t)
        case par.squargoal
            square = 1;
        case par.cirgoal
            circle = 1;
    end
    
    %% T1
    d2 = mdp_T1.d{2};
    i = d2 > 0;
    
    if par.RR(1)
        if par.squareF1
            if i(1) && squaresquare
                d2(1) = d2(1) + mdp_T1.X{2}(1,t-1)*mdp_T1.eta;
            elseif circlecircle
                d2=ones(size(MDP_T1.d{2}));
            end
        else
            if i(4) && circlecircle
                d2(4) = d2(4) + mdp_T1.X{2}(4,t-1)*mdp_T1.eta;
            elseif squaresquare
                d2=ones(size(MDP_T1.d{2}));
            end
        end
    else
        if squaresquare
            if i(1) && d2(1)>=d2(4)
                d2(1) = d2(1) + mdp_T1.X{2}(1,t-1)*mdp_T1.eta;
    %             d2(4) = d2(4) - mdp_T1.X{2}(4,t-1)*mdp_T1.eta;
            else
                d2=ones(size(MDP_T1.d{2}));
            end
        elseif circlecircle  
            if i(4) && d2(4)>=d2(1)
                d2(4) = d2(4) + mdp_T1.X{2}(4,t-1)*mdp_T1.eta;
    %             d2(1) = d2(1) - mdp_T1.X{2}(1,t-1)*mdp_T1.eta;
            else
                d2=ones(size(MDP_T1.d{2}));
            end
        end
    end
%     [~, imax]=max(mdp_T1.X{2}(i,t-1));
    %% reinforce reaching goal
%     d2(i) = d2(i) + mdp_T1.X{2}(i,t-1)*mdp_T1.eta;
    %% but penalize wrong belief (random goals)
%     if (imax==1 && circlecircle) || (imax==4 && squaresquare)
%         d2(imax) = d2(imax) - 2*mdp_T1.X{2}(imax,t-1)*mdp_T1.eta;
%         d2=ones(size(MDP_T1.d{2}));
%     end
    
    MDP_T1.d{2} = d2/sum(d2);
    
    %% T2
    d2 = mdp_T2.d{2};
    i = d2 > 0;
    if par.RR(2)
        if par.squareF2
            if i(1) && squaresquare
                d2(1) = d2(1) + mdp_T2.X{2}(1,t-1)*mdp_T2.eta;
            else
                d2=ones(size(MDP_T2.d{2}));
            end
        else
            if i(4) && circlecircle
                d2(4) = d2(4) + mdp_T2.X{2}(4,t-1)*mdp_T2.eta;
            elseif squaresquare
                d2=ones(size(MDP_T2.d{2}));
            end
        end
    else
        if squaresquare
            if i(1) && d2(1)>=d2(4)
                d2(1) = d2(1) + mdp_T2.X{2}(1,t-1)*mdp_T2.eta;
    %             d2(4) = d2(4) - mdp_T2.X{2}(4,t-1)*mdp_T2.eta;
            else
                d2=ones(size(MDP_T1.d{2}));
            end
        elseif circlecircle  
            if i(4) && d2(4)>=d2(1)
                d2(4) = d2(4) + mdp_T2.X{2}(4,t-1)*mdp_T2.eta;
    %             d2(1) = d2(1) - mdp_T2.X{2}(1,t-1)*mdp_T2.eta;
            else
                d2=ones(size(MDP_T1.d{2}));
            end
        end
    end
%     [~, imax]=max(mdp_T2.X{2}(i,t-1));
%     %% reinforce reaching goal
%     d2(i) = d2(i) + mdp_T2.X{2}(i,t-1)*mdp_T2.eta;    
%     %% but penalize wrong belief (random goals)
%     if (imax==1 && circlecircle) || (imax==4 && squaresquare)
% %         d2(imax) = d2(imax) - 2*mdp_T2.X{2}(imax,t-1)*mdp_T2.eta;
%         d2=ones(size(MDP_T2.d{2}));
%     end
    
    MDP_T2.d{2} = d2/sum(d2);
else
    %% otherwise penalty
    reset_fail1=rand;
    reset_fail2=rand;
    th=0.7;  %% if too many errors reset followers beliefs
    if reset_fail1>th || reset_fail2>th 
        d2=ones(size(MDP_T1.d{2}));
        if ~par.RR(1) && reset_fail1>th
            MDP_T1.d{2} = d2/sum(d2);
        end
        if ~par.RR(2) && reset_fail2>th
            MDP_T2.d{2} = d2/sum(d2);
        end
%         return;
    end
end

%% force saturation and mirror
% p0=exp(-16);
% d2 = spm_norm(MDP_T1.d{2}+p0);
% d2 = spm_norm(mdp_T1.d{2}+p0);


%% T1
mir= [true;true;true;true];
d2 = MDP_T1.d{2};
%% mirror T1
if par.mirror_game
    if par.RR(1)
        if par.squareF1
            d2(3:4)=0;
            d2=d2/sum(d2);
            mir= [true;true;false;false];
        else
            d2(1:2)=0;
            d2=d2/sum(d2);
            mir= [false;false;true;true];
        end
    else
        d2(2:3)=0;
        d2=d2/sum(d2);
        mir= [true;false;false;true];
    end
end
%% saturation T1
toomuch=d2>threshold;
if sum(toomuch)>0
	d2(~toomuch & mir)=d2(~toomuch & mir)+(d2(toomuch)-threshold)/+sum(~toomuch & mir);
%     d2(~toomuch)=d2(~toomuch)+(d2(toomuch)-threshold)/3;
    d2(toomuch)=threshold;
end
MDP_T1.d{2} = d2;

%% T2
mir= [true;true;true;true];
d2 = MDP_T2.d{2};
%% mirror T2
if par.mirror_game
    if par.RR(2)
        if par.squareF2
            d2(3:4)=0;
            d2=d2/sum(d2);
            mir= [true;true;false;false];
        else
            d2(1:2)=0;
            d2=d2/sum(d2);
            mir= [false;false;true;true];
        end
    else
        d2(2:3)=0;
        d2=d2/sum(d2);
        mir= [true;false;false;true];
    end
end

%% saturation T2
toomuch=d2>threshold;
if sum(toomuch)>0
    d2(~toomuch & mir)=d2(~toomuch & mir)+(d2(toomuch)-threshold)/sum(~toomuch & mir);
%     d2(~toomuch)=d2(~toomuch)+(d2(toomuch)-threshold)/3;
    d2(toomuch)=threshold;
end
MDP_T2.d{2} = d2;
