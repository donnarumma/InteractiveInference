%% function A = getA_MAZE2D_PAR(T,locs,squargoal,cirgoal,square,lambda) 

function A = getA_MAZE2D_PARAMS(T,locs,square,params) 

squargoal                       = params.squargoal;
cirgoal                         = params.cirgoal;
lambda                          = params.lambda;
nsplits                         = params.nsplits;
no_coactor_location_uncertainty = params.no_coactor_location_uncertainty;

Xi = salience_field(T,locs,squargoal,cirgoal); 

for u = 1:T.Nu
    A{1}{u}                               = repmat(eye(T.No(1)),1,1,T.Ns(2),T.Ns(3));
    %A{2}{u}                               = repmat(eye(T.No(2)),1,T.Ns(1),T.Ns(2),1);
    
    for s = 1:T.Ns(1)
        % A{3}
        
        if square
            xi_s    =   belief_dependent_salience_(T.D{2}(1),s,Xi);
        else
            xi_s    =   belief_dependent_salience_(T.D{2}(T.Ns(2)),s,Xi);
        end
        
        xi_s    =   action_dependent_salience(T,s,u,lambda,xi_s,Xi);
        
%         xi_s_o  =  xi_s;
        
        xi_s_o  =xi_s;
        for spl=1:nsplits
        	xi_s    = split_salience(xi_s);
        end
        for ss = 1:T.Ns(3)
            %xi_ss    =   belief_dependent_salience(T,ss,square,Xi);
            if square
                xi_ss    =   belief_dependent_salience_(T.D{2}(1),ss,Xi);
            else
                xi_ss    =   belief_dependent_salience_(T.D{2}(T.Ns(2)),ss,Xi);
            end
            
            xi_ss    =   action_dependent_salience(T,s,u,lambda,xi_ss,Xi);
            
            xi_ss_o  = xi_ss; %%removed
            for spl=1:nsplits
                xi_ss    =   split_salience(xi_ss);
            end
         
            c11=xi_s(1) * xi_ss(1);
            c12=xi_s(1) * xi_ss(2);
            c21=xi_s(2) * xi_ss(1);
            c22=xi_s(2) * xi_ss(2);
            
            
            a11=(1-c11)/3;
            a12=(1-c12)/3;
            a21=(1-c21)/3;
            a22=(1-c22)/3;

            A{3}{u}(:,s,1,ss)     =     [c11,a11,a11,a11]';
            A{3}{u}(:,s,2,ss)     =     [a12,c12,a12,a12]';
            A{3}{u}(:,s,3,ss)     =     [a21,a21,c21,a21]';
            A{3}{u}(:,s,4,ss)     =     [a22,a22,a22,c22]';
            
            try
                if params.NoClue
                    A{3}{u}(:,s,:,ss)=0;
                    if s==1 && ss==1 && u==1
                        fprintf('Reinforcement Learning mode\n');
                    end
                end
            catch
                
            end
                

            if no_coactor_location_uncertainty
                val     =1;
                antival =0;
            else
                xi_ss=xi_ss_o;
                xi_s =xi_s_o;
                for spl=1:3 %n+splits
                    xi_ss   =   split_salience(xi_ss);
                    xi_s    =   split_salience(xi_s);
                end
                %% insert an uncertainty on location of the co-actor
                val=params.status_certainty(xi_s,xi_ss);
%                 val=status_certainty(xi_s_o,xi_ss_o);
                antival=1-val;
            end
            A2 = ones(T.No(2),T.Ns(2))*antival;
            A2(ss,:) = ones(1,T.Ns(2))*val;
            
            A{2}{u}(:,s,:,ss)        =     A2; 
            
        end        
        if s~=cirgoal && s ~=squargoal
            A{4}{u}(:,s,:,:)              = repmat([0;1;0],1,1,T.Ns(2),T.Ns(3));     
        elseif s == cirgoal
            A{4}{u}(:,s,:,:)              = repmat([1;0;0],1,1,T.Ns(2),T.Ns(3));            
            % 
            if ~T.isleader
                A{4}{u}(:,s,1,s) = [0; 0; 1]; 
                A{4}{u}(:,s,4,s) = [0; 0; 1]; 
            else  
                A{4}{u}(:,s,4,s) = [square; 0; 1-square]; 
            end
            %
        elseif s == squargoal
            A{4}{u}(:,s,:,:)              = repmat([1;0;0],1,1,T.Ns(2),T.Ns(3)); 
            %
            if ~T.isleader
                A{4}{u}(:,s,1,s) = [0; 0; 1]; 
                A{4}{u}(:,s,4,s) = [0; 0; 1]; 
            else  
                A{4}{u}(:,s,1,s) = [1-square; 0; square]; 
            end 
        end
    end
end
