function vec_spd = vecSPD (cov, dim, dim_spdvec)

vec_spd = zeros(dim_spdvec,1);
k = 1;
sr2 = sqrt(2);

  
  for  i=1:dim
      for j=i:dim
          if (i==j)
              vec_spd(k) = cov(i,j);	
          else
              vec_spd(k) = sr2*cov(i,j);
          end
      k = k+1;  
      end
  end
  
    
  