function dist =  cluster_distance (S_cluster, X_point)



dist = log(det( 0.5*(X_point + S_cluster) )) - 0.5*log(det(X_point*S_cluster ));





