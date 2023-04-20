function x_D2 = belief_dependent_salience_(D2,s,Xi)
% Belief dependence

x_D2 = Xi(:,s);
 
[~,id]      =     max(x_D2);
if D2 > .5   
  
    x_D2(id) = (1 - (D2 - .5)) * x_D2(id);
    if x_D2(id) < .5
        x_D2(id) = .5;
    end
    x_D2(2-id+1)  = 1 - x_D2(id);
    
end
