function AP = average_precision(predicted_output, labels_test)

%Precision at position n (P@n)
%Mean average precision (MAP)
%LETOR: Benchmark Dataset for Research on Learning to Rank for Information Retrieval

%predicted_output 
%labels_test

list_Pn = [];
tmp_sum = 0;
for b=1:length(predicted_output)
    
  tmp = (predicted_output(b) == labels_test(b));
  tmp_sum = tmp_sum + tmp;
  list_Pn = [list_Pn  tmp_sum/b*tmp ];
    
end
AP = sum(list_Pn/tmp_sum);

%Example from 
%LETOR: Benchmark Dataset for Research on Learning to Rank for Information Retrieval

%list = [1 0 0 1 1 1 0 0 1 1 ];
%list_Pn = [];

%for j=1:10
%    list_Pn = [ list_Pn sum(list(1:j))/j  ];
%end

%AP = (sum(list_Pn.*list))/sum(list);