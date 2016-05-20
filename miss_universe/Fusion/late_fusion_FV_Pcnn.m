clear all
clc
my_path = pwd;
project_path = fileparts(my_path);

load( [ project_path '/FV/dec_values_FV.mat']);
load( [project_path '/P-CNN/dec_values_Pcnn.mat']);

load([ project_path '/P-CNN/info_results_Pcnn'], 'info_results', 'all_years');
load([ project_path '/FV/info_results_FV'], 'info_results_FV' );

%De Info Results I only need labels_test
%info_results(i,1) -> accuracy(1)
%info_results(i,2) -> real_order
%info_results(i,3) -> predicted_order
%info_results(i,4) -> labels_test; (Real binary labels)
%info_results(i,5) -> predicted_output;

num_years = length( all_years);

all_real_labels = info_results(:,4);
all_predicted_output_Pcnn =  info_results(:,5);
all_predicted_output_FV   =  info_results_FV(:,5);

late_fusion = cell( num_years,1);
 
for i=1:num_years  
late_fusion{i} = all_dec_values_Pcnn{i} + all_dec_values_FV{i};
end

%late_predicted_output = sign(late_fusion{1}') ;

acc_FV_PCNN_lateFusion = zeros(num_years,3);

for i=1:num_years    
    real_labels_i = all_real_labels{i}'; 

    predicted_output_Pcnn_i = all_predicted_output_Pcnn{i}';
    predicted_output_FV_i    = all_predicted_output_FV{i}';

    acc_Pcnn = length(find(real_labels_i==predicted_output_Pcnn_i))*100/length(real_labels_i);
    acc_FV   = length(find(real_labels_i==predicted_output_FV_i))*100/length(real_labels_i);


    late_predicted_output_i = sign(late_fusion{i}');
    acc_late_fusion = length(find(real_labels_i==late_predicted_output_i))*100/length(real_labels_i);
    
    acc_FV_PCNN_lateFusion(i,1) = acc_FV;    
    acc_FV_PCNN_lateFusion(i,2) = acc_Pcnn;
    acc_FV_PCNN_lateFusion(i,3) = acc_late_fusion;


end

acc_FV_PCNN_lateFusion
mean(acc_FV_PCNN_lateFusion)



