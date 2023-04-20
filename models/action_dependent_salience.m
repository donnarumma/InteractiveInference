function xi_u = action_dependent_salience(T,s,u,lambda,xi_D2,Xi)
% Action dependence

if u <= (T.Nu-5)
    [~,id]      =     max(xi_D2);
    s_u = find(find(T.B{3}(s,:,u)) ~= s);
    if isempty(s_u)
        s_u = s;
    end
    xi_u(id,1) = xi_D2(id,1) + lambda*(xi_D2(id,1) - Xi(id,s_u)); % - xi_(id));
    
    if xi_u(id) > 1
        xi_u(id) = 1;
    end
    if xi_u(id) < 0
        xi_u(id) = 0;
    end
    xi_u(2-id+1)  = 1 - xi_u(id);
else
    xi_u = xi_D2;
end