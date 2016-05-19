load ./FV/dec_values_FV.mat 
load ./P-CNN/dec_values_Pcnn.mat
late_fusion = cell( length(all_dec_values_Pcnn),1);

for i=1:length(all_dec_values_Pcnn)     
late_fusion{i} = all_dec_values_Pcnn{i} + all_dec_values_FV{i};
end

%late_predicted_output = sign(late_fusion{1}') ;