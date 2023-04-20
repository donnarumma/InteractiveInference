function MDP = Djoint_Mirror_PAR_sharedContextBelief(params)
%% function MDP = Djoint_Mirror_PAR_sharedContextBelief(params)
% with shared context belief between the agents.
% context belief code: [(square,square); (square,circle); (circle,square);
% (circle,circle)]:

[locations, maze]=maze_create(params.MAZE);
% Remarkable positions of the problem
%--------------------------------------------------------------------------
squareF1      = params.squareF1;     % real context - cheese
squareF2      = params.squareF2;

lambda        = params.lambda;     % saliency discount factor

squargoal     = params.squargoal;  
cirgoal       = params.cirgoal;    

T1.start      = params.startT1;    
T2.start      = params.startT2;    

T1.isleader   = params.RR(1);
T2.isleader   = params.RR(2);

T1D2          = params.ContextBelief{1};
T2D2          = params.ContextBelief{2};

V1            = params.V1;
V2            = params.V2;

T1.V          = V1;
T2.V          = V2;
%
RW1           = params.RW{1};
RW2           = params.RW{2};

C1            = params.cs{1};
C2            = params.cs{2};

Nactions      = params.Nactions;
belief_prop   = params.belief_propagation;
% no_coactor_unc= params.no_coactor_location_uncertainty;
% nsplits       = params.nsplits;

%----States----------------------------------------------------------------
T1.Ns(1)     =     numel(locations);
T1.Ns(2)     =     numel(T1D2);
T1.Ns(3)     =     numel(locations);

T2.Ns(1)     =     T1.Ns(1);
T2.Ns(2)     =     T1.Ns(2);
T2.Ns(3)     =     T1.Ns(3);

% T1 agent
T1.S{1}      =     zeros(T1.Ns(1),1);       T1.S{1}(T1.start)    =   1;
T1.S{2}      =     RW1; %[squareF1 ; 0; 0; 1-squareF1];
T1.S{3}      =     zeros(T2.Ns(1),1);       T1.S{3}(T2.start)    =   1;

% T2 agent
T2.S{1}      =     zeros(T2.Ns(1),1);       T2.S{1}(T2.start)    =   1;
T2.S{2}      =     RW2; %[squareF2 ; 0; 0; 1-squareF2];
T2.S{3}      =     zeros(T1.Ns(1),1);       T2.S{3}(T1.start)    =   1;


%--------------------------------------------------------------------------


%----Initial Beliefs-------------------------------------------------------

% T1 agent
T1.D{1}     =       T1.S{1};
T1.D{2}     =       T1D2;
T1.D{3}     =       T1.S{3};

% T2 agent
T2.D{1}     =       T2.S{1};
T2.D{2}     =       T2D2; 
T2.D{3}     =       T2.S{3};

%--------------------------------------------------------------------------


%----State Transitions-----------------------------------------------------

% Actions 
% (in an allocentric system) are encoded following the sequence:
% up = 1, down = 2, left = 3, right = 4, wait = 5.

% T1 agent
T1.Nu   =   Nactions^2;
T1.B    =   getB_MAZE2D_PARAMS(T1,locations,maze,belief_prop);

% T2 agent
T2.Nu   =   Nactions^2;
T2.B    =   getB_MAZE2D_PARAMS(T2,locations,maze,belief_prop);


%----Likelihoods-----------------------------------------------------------

% T1 agent
T1.No(1)    =       numel(locations);
T1.No(2)    =       numel(locations);
T1.No(3)    =       4;              % salience of a goal
T1.No(4)    =       3;              % [reward; not-reward; penalty]

%
T1.A        =       getA_MAZE2D_PARAMS(T1,locations,squareF1,params);


% T2 agent
T2.No(1)    =       numel(locations);
T2.No(2)    =       numel(locations);
T2.No(3)    =       4;              % salience of a goal
T2.No(4)    =       3;              % [reward; not-reward; penalty]

%
T2.A        =       getA_MAZE2D_PARAMS(T2,locations,squareF2,params);


%----Priors----------------------------------------------------------------

% T1 agent

%
T1.C{1}     =   ones(T1.No(1),1)/T1.No(1);
T1.C{2}     =   ones(T1.No(2),1)/T1.No(2);
T1.C{3}     =   .25*ones(4,1);  
if params.forcemirrorC3
    if params.RR(1)
        square=params.squareF1;
        T1.C{3}=[square;0.0;0.0;1-square];
    else
        T1.C{3}=[0.5;0.0;0.0;0.5];
    end
end
T1.C{4}     =   spm_softmax(C1);  % spm_softmax([-c1; 0; c1]); %

% T2 agent
%
T2.C{1}     =   ones(T2.No(1),1)/T2.No(1);
T2.C{2}     =   ones(T2.No(2),1)/T2.No(2);
T2.C{3}     =   .25*ones(4,1); 
if params.forcemirrorC3
    if params.RR(2)
        square=params.squareF2;
        T2.C{3}=[square;0.0;0.0;1-square];
    else
        T2.C{3}=[0.5;0.0;0.0;0.5];
    end
end
T2.C{4}     =   spm_softmax(C2); % spm_softmax([-c2; 0; c2]); %
%--------------------------------------------------------------------------

%%% ------------------------------------------------------
MDP{1}.N    = 8;                          % number of variational iterations

MDP{1}.S    = T1.S;                       % true initial state
MDP{1}.A    = T1.A;                       % observation model
MDP{1}.B    = T1.B;                       % model transition probabilities
MDP{1}.C    = T1.C;                       % terminal cost probabilities (priors)
MDP{1}.D    = T1.D;                       % initial state probabilities (priors)
MDP{1}.V    = T1.V;                       % allowable policies

MDP{1}.alpha  = 64; % 1600;               % gamma hyperparameter
MDP{1}.beta   = 4;                        % gamma hyperparameter
MDP{1}.lambda = 1/4;                      % precision update rate
% MDP{1}.gamma  = 16;

%%% Agent 2

MDP{2}.N = 8;                             % number of variational iterations

MDP{2}.S = T2.S;                          % true initial state
MDP{2}.A = T2.A;                          % observation model
MDP{2}.B = T2.B;                          % transition probabilities (priors)
MDP{2}.C = T2.C;                          % terminal cost probabilities (priors)
MDP{2}.D = T2.D;                          % initial state probabilities (priors)
MDP{2}.V = T2.V;                          % allowable policies

% WARNING:keep the values of these parameters high if working with 
% many policies. Their values directly influence the "temperature" 
% of the Boltzmann distribution picked on the mode
MDP{2}.alpha  = 128; %64                  % gamma hyperparameter
MDP{2}.gamma  = 1;

MDP{2}.beta   = 4;                        % gamma hyperparameter
MDP{2}.lambda = 1/4;                      % precision update rate

%switch square, case 1, par.target = 'square'; case 0, par.target = 'circle'; end


%----AUX. FUN.-------------------------------------------------------------

%------------------------------



%----------------------------------------------

function [y] = spm_softmax(x,k)

if nargin > 1, x = k*x; end

x  = exp(bsxfun(@minus,x,max(x)));
y  = bsxfun(@rdivide,x,sum(x));


% (EOF)
