function my_ndcg = ndcg(pred,real,p, opt)

%opt:
%1 -> Wikipedia
%2 -> for YAHOO LTRC.
%3 -> for MSLR and LETOR 4.0

%Example in Wikipedia
%https://en.wikipedia.org/wiki/Discounted_cumulative_gain

%pred = [3 2 3 0 1 2];
%real = [ 3 3 2 2 1 0];
%p = 6;


dcg_pred  = dcg(pred,p, opt);
dcg_ideal = dcg(real,p, opt);
my_ndcg = dcg_pred/dcg_ideal;


function dcg_p = dcg(list, p, opt)

%% Wikipedia
%https://en.wikipedia.org/wiki/Discounted_cumulative_gain
if (opt==1)
    %Using the equation as per example in Wikipedia
    
    dcg_p = list(1);
    
    
    for i=2:p
        dcg_p = dcg_p + list(i)/log2( i );
        
    end
end

%% for YAHOO LTRC.
%See Large-scale Linear RankSVM

if (opt ==2)
    dcg_p = 0;
    
    
    for i=1:p
        %list(i)/log2( i );
        num = 2^list(i)-1;
        den = log2(i+1);
        dcg_p = dcg_p + num / den;
        
    end
    
end

%% for MSLR and LETOR 4.0
%See Large-scale Linear RankSVM

if (opt ==3)
    dcg_p = 0;
    
    
    for i=1:p
        num = 2^list(i)-1;
        den  = log2( max(2,i) );
        dcg_p = dcg_p + num / den;
        
    end
    
end