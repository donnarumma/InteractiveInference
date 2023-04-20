%%function new_xi_s=split_salience(xi_s)


function new_xi_s=split_salience(xi_s)
meanbias=1/length(xi_s);
new_xi_s=xi_s.*exp(xi_s-meanbias);
new_xi_s=new_xi_s/sum(new_xi_s);

if sum(new_xi_s>=0)<length(xi_s)
    new_xi_s
    disp('WARNING: negative values');
end