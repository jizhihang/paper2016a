function cluster_idx_pac = initial_centers (list_pac, K)

a=1;
b = length(list_pac);


random_points = randi([a b],1,K);
cluster_idx_pac = cell(K,3);


for k=1:K
    
    cluster_idx_pac{k,1} = list_pac{random_points(k),1};
    cluster_idx_pac{k,2} = list_pac{random_points(k),2};
    new_b = list_pac{random_points(k),3}
    random_cov_idx = randi([a new_b],1,1)
    cluster_idx_pac{k,3} = random_cov_idx;

    
end