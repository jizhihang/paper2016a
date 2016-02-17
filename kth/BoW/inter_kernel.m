function K = inter_kernel(X,Y)

% X,Y --> [K num_hists]

dim_x = size(X,2);
dim_y = size(X,2);

K = zeros(dim_x,dim_y);


for i=1:dim_x
    for j=1:dim_y           
        tmp = [ X(:,i); Y(:,j) ];
        K(i,j) = sum( min(tmp) );
    end
end


