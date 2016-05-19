load ./FV/dec_values_FV.mat 
load ./P-CNN/dec_values_Pcnn.mat

load('./P-CNN/info_results_Pcnn', 'info_results', 'all_years');

%De Info Results I only need labels_test
%info_results(i,1) -> accuracy(1)
%info_results(i,2) -> real_order
%info_results(i,3) -> predicted_order
%info_results(i,4) -> labels_test; (Real binary labels)
%info_results(i,5) -> predicted_output;


all_labels_test = info_results(:,4);
all_predicted_output_Pcnn =  info_results(:,5);

late_fusion = cell( length(all_dec_values_Pcnn),1);

for i=1:length(all_dec_values_Pcnn)     
late_fusion{i} = all_dec_values_Pcnn{i} + all_dec_values_FV{i};
end

%late_predicted_output = sign(late_fusion{1}') ;

i =1;
late_predicted_output_i = sign(late_fusion{i}') 
real_labels_i = all_labels_test{i}'; 
predicted_output_Pcnn_i = all_predicted_output_Pcnn{i}';




