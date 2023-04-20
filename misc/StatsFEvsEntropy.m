function s=StatsFEvsEntropy(N,params,iB1s,iB2s,indAgent)
try
    N;
catch
%     N=1000;
    N=1;
end
polInfo             = DjointPolicies();
    
try
    params;
catch

    %% simulation with parameters of test_name=OPEN_LF_A15050C_A25050_SIM_CA_P1
    params              = custom_simmetric_maze_open();
    params.policy_labels= polInfo.policy_labels;
    
    maisto_case                           = 0;
    donnarumma_case                       = 1-maisto_case;
    
    
    
    c1=6; c2=6;
    if maisto_case
        belief_propagation                = 1;
        no_coactor_location_uncertainty   = 1; 
        nsplits                           = 0;
        forcemirrorC3                     = 0;
        params.cs{1}                      = [-c1; c1/2; c1];
        params.cs{2}                      = [-c2; c2/2; c2];
    elseif donnarumma_case
        belief_propagation                = 1;
        no_coactor_location_uncertainty   = 0; 
        nsplits                           = 0;
        forcemirrorC3                     = 1;
        params.cs{1}                      = [-c1; 5; c1];
        params.cs{2}                      = [-c2; 5; c2];
    
    %     belief_propagation              = 0.98;%0.7;
    %     belief_propagation              = 0.97;%0.7;
    %     belief_propagation              = 0.90;%0.7;
    
    %     forcemirrorC3                   = 0;
    %     params.cs{1}                    = [-c1; 4.5; c1];
    %     params.cs{2}                    = [-c2; 4.5; c2];
    
    %     params.cs{1}                    = [-c1; c1/2; c1];
    %     params.cs{2}                    = [-c2; c2/2; c2];
    end
    params.belief_propagation             =belief_propagation;              % 1 is perfect propagation. < 1 noisy propagation
    params.nsplits                        =nsplits;                         % splits to enlarge the divergence in salience: values 0 (no split),1,2,3
    params.no_coactor_location_uncertainty=no_coactor_location_uncertainty; % uncertainty about coactor locations
    params.forcemirrorC3                  =forcemirrorC3;                   % if C{3}=[0.5;0.0;0.0;0.5] | if 01 C{3}=ones(4,1)*1/4;
    
    params.lambda                         = 0;%2.05;  % .95;  % 10          
    
    
    
    RR                     = [1,0];
    params.RR              = RR;
    params.Nagents         = length(params.RR);   % number of agents
    params.ActionList      = getActionList(params.Nactions, params.Nagents);
    params.T               = 9;
end
indSHORT                            = polInfo.P_INDEX(:,polInfo.COL_STRATEGY1)==polInfo.SHORT;
indLONG                             = polInfo.P_INDEX(:,polInfo.COL_STRATEGY1)==polInfo.LONG;
    
Np                  = length(params.policy_labels);

pGSs                = nan(N,1);
pGLs                = nan(N,1);
Gs                  = nan(N,Np);
entropy_A1s         =nan(N,1);

mB                     = eps;

for nk=1:N

    try
        iB1=iB1s(nk);
        iB2=iB2s(nk);
        indAgent;
    catch
        indAgent            = 1;
        %% random a circle b
        a=rand;
        while ~(a>=0.5 && a<=0.9)
            a=rand;
        end
        b=rand;
        % iB1                    = [0.0,     0.0,    0.5,    0.5]; % leader knows that follower knows -- works
        % iB2                    = [0.5,     0.0,    0.0,    0.5];
        % iB1                    = [0.0,     0.0,    0.0,    1.0]; % leader knows that follower knows -- works
        % iB2                    = [0.5,     0.0,    0.0,    0.5];
        % 
        iB1                    = [0.0,     0.0,    a,    1-a]; % leader knows that follower knows -- works
        iB2                    = [  b,     0.0,  0.0,    1-b];
        
        % iB1                    = [0.0,     0.0,    0.5,    0.5]; % Iter 1/1: Entropy A1:           1, p(Signaling):  0.99985,   p(~Signaling): 0.00015044
        % iB1                    = [0.0,     0.0,    0.4,    0.6]; % Iter 1/1: Entropy A1:    0.970951, p(Signaling): 0.993228,   p(~Signaling): 0.00677161
        % iB1                    = [0.0,     0.0,    0.3,    0.7]; % Iter 1/1: Entropy A1:    0.881291, p(Signaling): 0.405009,   p(~Signaling): 0.594991
        % iB1                    = [0.0,     0.0,    0.2,    0.8]; % Iter 1/1: Entropy A1:    0.721928, p(Signaling): 0.00824696, p(~Signaling): 0.991753
        % iB1                    = [0.0,     0.0,    0.1,    0.9]; % Iter 1/1: Entropy A1:    0.468996, p(Signaling): 0.00953806, p(~Signaling): 0.990462
        
        % iB1                    = [0.0,     0.0,    0.05,    0.95]; % Iter 1/1: Entropy A1:    0.468996, p(Signaling): 0.00953806, p(~Signaling): 0.990462
        
        % iB1                    = [0.0,     0.0,    0.0,    0.1]; % Iter 1/1: Entropy A1: 3.33871e-13, p(Signaling): 0.298552,   p(~Signaling): 0.701448
        
    end
        
        
        
    iB1                    = iB1+mB;
    iB1                    = iB1/sum(iB1);
    iB2                    = iB2+mB;
    iB2                    = iB2/sum(iB2);
%     params.ContextBelief{1}= iB1';
%     params.ContextBelief{2}= iB2';
    params.ContextBelief{1}= iB1(:);
    params.ContextBelief{2}= iB2(:);
    
    % 1 = square (blue)   %  0 = circle (red)
    % randi(2,1,2)
    squareT                = [0,0]; % circle circle
    
    params.squareF1        = squareT(1);
    params.squareF2        = squareT(2);
                           %% square-square square-circle circle-square circle-circle
    params.RW{1}           =  [squareT(1);        0;            0;       1-squareT(1)];
    params.RW{2}           =  [squareT(2);        0;            0;       1-squareT(2)];
    if params.RR(1,1)==0
        sampleSquare=find(rand < cumsum(params.ContextBelief{1}'),1);
        if sampleSquare==4
            squareT(1,1)=0;
        else
            squareT(1,1)=sampleSquare;
        end
    end
    if params.RR(1,2)==0
        sampleSquare=find(rand < cumsum(params.ContextBelief{2}'),1);
        if sampleSquare==4
            squareT(1,2)=0;
        else
            squareT(1,2)=sampleSquare;
        end
    end
    
    
    MDP                    = Djoint_Mirror_PAR_sharedContextBelief(params);
    
      
    for ichT=1:2
    %     if whochange(goods,ichT)
    %         MDP{ichT}           = mdp_cur{ichT};
            MDP{ichT}.d{1}      = MDP{ichT}.D{1};
            MDP{ichT}.d{2}      = 1 * MDP{ichT}.D{2};  
            MDP{ichT}.d{3}      = MDP{ichT}.D{3};
    %                     MDP{ichT}.eta       = 0.2;
            MDP{ichT}.eta       = 0.5;
            MDP{ichT}.T         = params.T;
    %     end
    end
    
    
    % mdp_iT                 = initialiseMDP_debug(MDP{indAgent});
    mdp_cur                = parunJointTask_debug(MDP,params);
    mdp_iT                 = mdp_cur{indAgent}{end};
    % wt      =  find(mdp_iT.ut(:,t))';
    Np                     = length(params.policy_labels);
    cmaps                  = linspecer(Np);
    
    wt                     = 1:Np;
    % V=mdp_iT.V(wt);
    % a = mdp_iT.u(t-1);
    % jj = ismember(mdp_iT.V(t - 1,:),a);
    t                      = 1;
    % Np=length(wt);
    H=nan(Np,1);
    D=nan(Np,1);
    for k=1:Np
        hgj=nan(mdp_iT.Ng,mdp_iT.T);
        dgj=nan(mdp_iT.Ng,mdp_iT.T);
        for g=1:mdp_iT.Ng
            hgj(g,:)=computeH (mdp_iT,t,wt(k),g);
            dgj(g,:)=computeD (mdp_iT,t,wt(k),g);
        end
        ggj=hgj+dgj;
        out.H{k}=hgj;
        out.D{k}=hgj;
        out.G{k}=ggj;
        
        H(k)=nansum(hgj(:));
        D(k)=nansum(dgj(:));
    end
    G=H+D;
    
    pG                          = spm_softmax(G);
    
    entropy_A1  = entropy_compute(params.ContextBelief{1});
    entropy_A2  = entropy_compute(params.ContextBelief{2});
    % pGS         = sum(pG(indSHORT));
    pGL         = sum(pG(indLONG ));
    
    pGS        = 1-pGL;
    
    % pGL         = sum(pG(~indSHORT));
    fprintf('Iter %g/%g: Entropy A1: %g, p(Signaling): %g, p(~Signaling): %g\n',nk,N,entropy_A1,pGL,pGS);
    
    pGSs(nk)        = pGS;
    pGLs(nk)        = pGL;
    entropy_A1s(nk) = entropy_A1;           
    Gs(nk,:)        = G;

end
if N>1
    s = generateRandomString(15);
    nf = ['Entropy' s '.mat'];
    fprintf('Saving %s\n',nf);
    save(nf,'entropy_A1s','pGSs','pGLs','GSs','GLs');

    figure;plot(entropy_A1s,pGSs,'o','MarkerSize',6);
    
    xlabel('Entropy Belief White Agent');
    ylabel('probability of signaling policy');
    xlim([-inf,+inf]);
    dy=0.05;
    ylim([0-dy,1+dy]);
end

%EntropyHMaZCbpjBURl4QP.mat
% EntropyWO8PjHLdFbBtXtR.mat

figure; hold on; box on; grid on;
hs(1)=plot(entropy_A1s,Gs(:,1),'+','MarkerSize',6,'color',cmaps(1,:));
% hs(3)=plot(entropy_A1s,Gs(:,3),'--o','MarkerSize',6,'color',cmaps(3,:));
hs(2)=plot(entropy_A1s,Gs(:,5),'o','MarkerSize',6,'color',cmaps(5,:));
legend(hs,params.policy_labels([1,5]));
xlabel('Entropy Belief White Agent');
ylabel('probability of signaling policy');
xlim([-inf,+inf]);

% EntropyKTYp9gX3TkjTwbM.mat