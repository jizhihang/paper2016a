function [W U S V NP] = get_PCA_transformation_matrix (X_train)


    
Sigma=cov(X_train);
[U,S,V] = svd(Sigma);

eigVals = diag(S);
%eigVecs = U;

for i = 1: length(eigVals)
energy(i) = sum(eigVals(1:i));
end

propEnergy = energy./energy(end);
percentMark = min(find(propEnergy > 0.9));
NP = percentMark;

W = U(:,1:NP);

