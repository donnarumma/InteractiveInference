%% function [mdp] = parun_JointTask(MDP,par)
% parallel execution, (note: Agent1 is the first to move in every step)
function [mdp] = parun_JointTask(MDP,par)

try 
    par.print;
catch
    par.print = 1;
end

UU  = getUU;

mdp =cell(length(MDP),1);

mdp{1}{1}    =   MDP{1};
mdp{2}{1}    =   MDP{2};

Vl  =  mdp{1}{1}.V;
Vf  =  mdp{2}{1}.V;

try
    T = par.T;
catch
    T = size(Vl,1);
    if T > size(Vf,1)
        T = size(Vf,1);
    end
end

try
    OPTION.simcase = par.case;
catch
    OPTION.simcase = 'LF';
end
try 
    OPTION.modality= par.modality;
catch
    OPTION.modality= 'FE';
end

if par.print
    tas={'Leader','Follower'};
    fprintf('\nMIRROR GAME with two agents: A1:%s and A2:%s\n\n',tas{2-par.RR(1)},tas{2-par.RR(2)});
end
    
    
for t = 1:T
    %
    % T1, the leader, receives observations sent from T2; T2 sets T1 as new state and 
    % update its observation
    
    mdpL_t = mdp{1}{t};
    
    mdpF_t = mdp{2}{t};

    mdpL_t = update_mdp(mdpL_t,mdpF_t,UU,Vl,t);
    mdpF_t = update_mdp(mdpF_t,mdpL_t,UU,Vf,t);
%     mdpL_t = update_mdp(mdpL_t,mdpF_t,UU,Vl,t);
    
%     printDjoint(mdp,t);
    % T1 active inference 
    mdp{1}{t+1}         = spm_MDP_GAME_parsim(t,mdpL_t,OPTION);

      
    % T2 active inference
    mdp{2}{t+1}         = spm_MDP_GAME_parsim(t,mdpF_t,OPTION);
 
    
    if par.print
        printDjoint(mdp,t);
    end
    
    try
       if (mdp{1}{t+1}.s(1,t+1) == par.squargoal   && mdp{2}{t+1}.s(1,t+1) == par.squargoal) || ...
          (mdp{1}{t+1}.s(1,t+1) == par.cirgoal     && mdp{2}{t+1}.s(1,t+1) == par.cirgoal  )
            printDjoint(mdp,t+1);
            fprintf('MIRROR - IMITATIVE\n');
            break
        end
        if (mdp{1}{t+1}.s(1,t+1) == par.squargoal   && mdp{2}{t+1}.s(1,t+1) == par.cirgoal) || ...
           (mdp{1}{t+1}.s(1,t+1) == par.cirgoal     && mdp{2}{t+1}.s(1,t+1) == par.squargoal  ) 
            printDjoint(mdp,t+1);
            fprintf('COUNTER-MIRROR - COMPLEMENTARY\n');
            break
        end
    catch
        
    end
    
        
end

%--- AUX FUN --------------------------------------------------------------

function UU = getUU()
%
% returns a tridimensional matrix with the third dimension showing the
% action of the other agent
%
% number of actions per agent
% number of real action per single agent
% Ex:
% for Nu = 25 and nu = 5;
% action of the considered agent (up,up) and coded in the vector U1; action of the other agent
% (wait,left) with index u2 = 23. You get the transformed vector U1p from the following instructions:
%
% >> U1 = [1,zeros(1,24)]';
% >> u2 = 23;
% >> UU = defineUUop(25,5);
% >> U1p = UU(:,:,u2) * U1
% ans =
% 
%      0
%      0
%      0
%      0
%      1
%      0
%      0
%      0
%      0
%      0
%      0
%      0
%      0
%      0
%      0
%      0
%      0
%      0
%      0
%      0
%      0
%      0
%      0
%      0
%      0
% 
% >>
%
%
Nu = 25;
nu = 5;

UU = zeros(Nu,Nu,Nu);

r = 0;
for k =1:Nu
    if mod(k,nu)-1 == 0
        r = r+1;
    end
    m = 0;
    for i = r:nu:Nu
        j =  m*nu+1;
        UU(i,j:j+nu-1,k) = ones(nu,1);
        m = m+1;
    end
end


%--------------------------------------------------------

% function mdp_r = update_mdp(mdp_r,mdp_s,UU,V,t)
% % mdp_r = mdp{i}{t}
% 
% if t > 1
%     
%     % update other observation
%     mdp_r.O{2}(:,t) =   mdp_s.O{1}(:,t);
%     mdp_r.o(2,t)    =   mdp_s.o(1,t);
%     
%     % update the related state
%     %
% %     sq = arrayfun(@(IDX) mdp_r.S{IDX}(:,t), (1:mdp_r.Nf).', 'uniform', 0);
% %     
% %     v = zeros(mdp_r.Ns(3),1);
% %     % marginal likelihood over outcome factors
% %     %--------------------------------------------------
% %     for g = 1:mdp_r.Ng
% %         %Ag = spm_dot(mdp_r.A{g},sq,3); % nell'hp che il fattore 3 non venga usato
% %         %Ag = spm_dot(mdp_r.A{g}{mdp_r.u(t-1)},sq,3);
% %         v  = v + spm_log(Ag(mdp_r.o(g,t),:))';        
% %     end
% %         
% %     st = find(rand < cumsum(softmax(v)),1);  
% %     
% %     
% %     mdp_r.S{3}(:,t) = zeros(mdp_r.Ns(3),1);
% %     mdp_r.S{3}(st,t) = 1;
% %     mdp_r.s(3,t) = st; 
%     %
% 
% % funzionante
%     mdp_r.S{3}(:,t) = zeros(mdp_r.Ns(3),1);
%     mdp_r.S{3}(mdp_r.o(2,t),t) = 1;
%     
%     mdp_r.s(3,t) = mdp_r.o(2,t); 
%     
%     % update actions in coherence with the other agent
%     mdp_r.U(:,t-1)  =   UU(:,:,mdp_s.u(t-1)) * mdp_r.U(:,t-1);
%     mdp_r.u(t-1)    =   find(mdp_r.U(:,t-1));
%     
%     % keep the whole set of policies
%     mdp_r.V       = V;
%     mdp_r.wt      = 1:size(V,2);
% end

%--------------------------------------------------------

function mdp_r = update_mdp(mdp_r,mdp_s,UU,V,t)
% mdp_r = mdp{i}{t}

if t > 1
    
    
    % update actions in coherence with the other agent
    mdp_r.U(:,t-1)  =   UU(:,:,mdp_s.u(t-1)) * mdp_r.U(:,t-1);
    mdp_r.u(t-1)    =   find(mdp_r.U(:,t-1));
    
    % keep the whole set of policies
    mdp_r.V       = V;
    mdp_r.wt      = 1:size(V,2);
    
    
    % update other observation
    mdp_r.O{2}(:,t) =   mdp_s.O{1}(:,t);
    mdp_r.o(2,t)    =   mdp_s.o(1,t);
    
    % update the related state
    %
    sq = arrayfun(@(IDX) mdp_r.S{IDX}(:,t), (1:mdp_r.Nf).', 'uniform', 0);
    
    v = zeros(mdp_r.Ns(3),1);
    % marginal likelihood over outcome factors
    %--------------------------------------------------
    for g = 1:mdp_r.Ng
        %Ag = spm_dot(mdp_r.A{g},sq,3); % nell'hp che il fattore 3 non venga usato
        Ag = spm_dot(mdp_r.A{g}{mdp_r.u(t-1)},sq,3);
        v  = v + spm_log(Ag(mdp_r.o(g,t),:))';        
    end
        
    st = find(rand < cumsum(softmax(v)),1);
    %[~,st] = max(softmax(v));
    
    mdp_r.S{3}(:,t) = zeros(mdp_r.Ns(3),1);
    mdp_r.S{3}(st,t) = 1;
    mdp_r.s(3,t) = st; 
    %
    

end

%--------------------------------------------------------


function [X] = spm_dot(X,x,i)
% Multidimensional dot (inner) product
% FORMAT [Y] = spm_dot(X,x,[DIM])
%
% X   - numeric array
% x   - cell array of numeric vectors
% DIM - dimensions to omit (asumes ndims(X) = numel(x))
%
% Y  - inner product obtained by summing the products of X and x along DIM
%
% If DIM is not specified the leading dimensions of X are omitted.
% If x is a vector the inner product is over the leading dimension of X
%
% See also: spm_cross
%__________________________________________________________________________
% Copyright (C) 2015 Wellcome Trust Centre for Neuroimaging

% Karl Friston
% $Id: spm_dot.m 7314 2018-05-19 10:13:25Z karl $

% initialise dimensions
if iscell(x)
    DIM = (1:numel(x)) + ndims(X) - numel(x);
else
    DIM = 1;
    x   = {x};
end

% omit dimensions specified
if nargin > 2
    DIM(i) = [];
    x(i)   = [];
end

% inner product using recursive summation (and bsxfun)
for d = 1:numel(x)
    s         = ones(1,ndims(X));
    s(DIM(d)) = numel(x{d});
    X         = bsxfun(@times,X,reshape(full(x{d}),s));
    X         = sum(X,DIM(d));
end

% eliminate singleton dimensions
X = squeeze(X);


%--------------------------------------------------------------------------

function A = spm_log(A)
% log of numeric array plus a small constant
A  = log(A + 1e-16);


% (EOF)
