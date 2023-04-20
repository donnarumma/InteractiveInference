%%function params=shufflePolicies(params)
function params=shufflePolicies(params)
V1=params.V1;
V2=params.V2;
if params.ifshuffle==1
    %% policy order  simmetric for A1 and A2
    Np                   = size(V1,2);
    permV                =randperm(Np);
    params.permV         = permV;
    V1                   =V1(:,permV);
    V2                   =V2(:,permV);
    params.policy_labels =params.policy_labels(permV);
else
    %% policy order assimetric for A1 and A2
    Np1                  = size(V1,2);
    Np2                  = size(V2,2);
    permV1               =randperm(Np1);
    permV2               =randperm(Np2);
    params.permV1        = permV1;
    params.permV2        = permV2;
    V1                   =V1(:,permV1);
    V2                   =V2(:,permV2);
    policy_labels        =params.policy_labels;
    params.policy_labels1=policy_labels(permV1);
    params.policy_labels2=policy_labels(permV2);
end
params.V1=V1;
params.V2=V2;
end