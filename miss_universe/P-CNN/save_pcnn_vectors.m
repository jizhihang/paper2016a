function save_pcnn_vectors(param)


loadname=sprintf('%s/Xn_test.mat',param.savedir);
disp(['Load test features in: ',loadname])
load(loadname,'Xn_test')
loadname=sprintf('%s/Xn_train.mat',param.savedir);
disp(['Load train features in: ',loadname])
load(loadname,'Xn_train')



param.trainsplitpath; 
param.testsplitpath;

split_train = fopen(param.trainsplitpath) ;
split_test = fopen(param.testsplitpath) ;


for i=1:length(split_train)
    split_train(i)
    pause
    
    
    
end


