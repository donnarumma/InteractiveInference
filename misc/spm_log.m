%% function A = spm_log(A)
% log of numeric array plus a small constant

function A = spm_log(A)
A  = log(A + 1e-16);
end