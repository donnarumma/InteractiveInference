%% function htkg=computeH (mdp,t,k,g)
% predicted entropy (uncentainty)

function htkg=computeH (mdp,t,k,g)

V=mdp.V;
x = cell(mdp.Nf,1);
for f = 1:mdp.Nf
    x{f}    = mdp.X{f}(:,t);
end
T=mdp.T;

A=mdp.A;
lnA     =cell(1,numel(A));
for gg=1:numel(A)
    for u=1:numel(A{gg})
        lnA{gg}{u} = spm_log(A{gg}{u}); 
    end
end

htkg=nan(1,T);
for j = t:T 
        % transition probability from current state
        %--------------------------------------------------------------
        for f = 1:mdp.Nf   
            x{f} = mdp.B{f}(:,:,V(j,k)) * x{f};
            
            mdp.xt{f}(:,j,k) = x{f};                % hidden state belief expected according to the k-th policy
        end

        % predicted entropy (uncentainty)
        %--------------------------------------------------------------
%         fprintf('Time %g: g=%g\n',j,g);
        Hu = sum(A{g}{V(j,k)} .* lnA{g}{V(j,k)});
        htkg(j) = spm_dot(Hu,x);
end
return