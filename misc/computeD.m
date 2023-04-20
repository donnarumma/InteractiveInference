%% predicted divergence
function dtkg=computeD (mdp,t,k,g)

V=mdp.V;
x = cell(mdp.Nf,1);
for f = 1:mdp.Nf
    x{f}    = mdp.X{f}(:,t);
end
T=mdp.T;
dtkg=nan(1,T);
for j = t:T 
        % transition probability from current state
        %--------------------------------------------------------------
        for f = 1:mdp.Nf   
            x{f} = mdp.B{f}(:,:,V(j,k)) * x{f};
            
            mdp.xt{f}(:,j,k) = x{f};                % hidden state belief expected according to the k-th policy
        end

        % predicted divergence
        %--------------------------------------------------------------
        qo   = spm_dot(mdp.A{g}{V(j,k)},x);
        dtkg(j)=(mdp.lnC{g} - spm_log(qo))'* qo;       
end
end
function A = spm_log(A)
% log of numeric array plus a small constant
A  = log(A + 1e-16);
end
