function TESTS = Simulation_Djoint(params,seeds)
%% function TESTS = Simulation_Djoint(params,seeds)

ichange     =params.ichange;
bchange     =params.bchange;
whochange   =params.whochange;
squareT     =params.squareT;
RR          =params.role;
ifdestroy   =params.ifdestroy;

nfold       = [params.tests_source_directory '/' params.description '/'];

TESTS       =cell(params.N,1);

%% CICLE ON N TRIALS
for runIdx=1:params.N
    if params.do_update_seed
        seed=seeds(runIdx); rng(seed); % for each repetions a different sequence of seed for each trial
    end
    nf=[nfold  params.description '_' fromNumToOrderedString(runIdx,10^length(num2str(params.N)))];
    try    
        tmp_memory;
    catch
    end
    try
        if ifdestroy && isfile([nf '.mat'])
            fprintf('Forcing destroying saved file %s...\n',nf);
            if ifdestroy == 1
                fprintf('Do you want to continue? (press any key)');
                pause;
            end
            make_a_delibarate_error; % go to catch session
        end
        fprintf('Loading file %s...\n',nf);
        load(nf);
        mdp             =cell(2,1);
        mdp{1}{1}       =params.mdp{1}{end};
        mdp{2}{1}       =params.mdp{2}{end};
        params.mdp      =mdp;
        MDP             =params.MDP;
        TESTS{runIdx}   =params;
        fprintf('Size params: %g MB\n',round(getVarSize(params)/1000000));
        continue;
    catch
        fprintf('Cannot load %s file. creating params...\n',nf);
        
        params.idx             = runIdx;
        params.nf              = nf;

        if params.mirror_game && ismember(runIdx,ichange)
            params.seed            =seed; % save seed
            
%             params.res_square      = 0;
%             params.res_circle      = 0;
            goods                  = ismember(ichange,runIdx);

            if runIdx==1 || bchange(goods,1)
                params.ContextBelief{1}=params.iB{1}(goods,:)'; 
            else
                params.ContextBelief{1}=MDP{1}.d{2};
            end
            if runIdx==1 || bchange(goods,2)
                params.ContextBelief{2}=params.iB{2}(goods,:)'; 
            else
                params.ContextBelief{2}=MDP{2}.d{2};
            end
            
            if 1 || runIdx==1
%                 if RR(goods,1)==0
                if RR(1,1)==0
                    sampleSquare=find(rand < cumsum(params.ContextBelief{1}'),1);
                    if sampleSquare==4
                        squareT(goods,1)=0;
                    else
                        squareT(goods,1)=sampleSquare;
                    end
                end
%                 if RR(goods,2)==0
                if RR(1,2)==0
                    sampleSquare=find(rand < cumsum(params.ContextBelief{2}'),1);
                    if sampleSquare==4
                        squareT(goods,2)=0;
                    else
                        squareT(goods,2)=sampleSquare;
                    end
                end
            end
            
            params.squareF1        = squareT(goods,1);
            params.squareF2        = squareT(goods,2);
            
            params.RW{1}           = [squareT(goods,1) ; 0; 0; 1-squareT(goods,1)];
            params.RW{2}           = [squareT(goods,2) ; 0; 0; 1-squareT(goods,2)];
            
            params.RR              = RR(goods,:);
                        
            if params.ifshuffle
                params=shufflePolicies(params);
            end
            mdp_cur                = Djoint_Mirror_PAR_sharedContextBelief(params);
           
            for ichT=1:2
                if whochange(goods,ichT)
                    MDP{ichT}           = mdp_cur{ichT};
                    MDP{ichT}.d{1}      = MDP{ichT}.D{1};
                    MDP{ichT}.d{2}      = 1 * MDP{ichT}.D{2};  
                    MDP{ichT}.d{3}      = MDP{ichT}.D{3};
                    MDP{ichT}.eta       = params.eta;
                    MDP{ichT}.T         = params.T;
                end
            end
        end
    end
    
	mdp_cur          = parun_JointTask(MDP,params);%runJointTask_r_sync_debug(MDP,params);
	
    %    
    if params.do_update_context
        
%         [MDP{1},MDP{2},square,circle]   = updateContextBeliefsConditionedByGoal_LF(mdp_cur{1}{end},mdp_cur{2}{end},MDP{1},MDP{2},params);
        [MDP{1},MDP{2},square,circle]   = updateContextBeliefsConditionedByGoal_role(mdp_cur{1}{end},mdp_cur{2}{end},MDP{1},MDP{2},params);
%         [MDP{1},MDP{2},square,circle]   = updateContextBeliefsConditionedByGoal_FF(mdp_cur{1}{end},mdp_cur{2}{end},MDP{1},MDP{2},params);

%         params.res_square               = params.res_square + square;
%         params.res_circle               = params.res_circle + circle;
        params.MDP                      = MDP;
    end
    %% SAVE PARAMS IN tests_source_directory
    params.mdp           = mdp_cur;    
    TESTS{params.idx}    = params;
    fprintf('Saving Test %g in %s\n',params.idx,nf);
    save(nf,'params');
end

return