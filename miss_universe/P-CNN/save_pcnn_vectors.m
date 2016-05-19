function save_pcnn_vectors(param, features_folder)

if ~exist(features_folder, 'dir')
    mkdir(features_folder);
end




loadname=sprintf('%s/Xn_test.mat',param.savedir);
disp(['Load test features in: ',loadname])
load(loadname,'Xn_test')
loadname=sprintf('%s/Xn_train.mat',param.savedir);
disp(['Load train features in: ',loadname])
load(loadname,'Xn_train')



param.trainsplitpath; 
param.testsplitpath;

split_train = importdata(param.trainsplitpath) ;
split_test = importdata(param.testsplitpath) ;


for i=1:length(split_train)
    split_train(i)
    
    pcnn_vector = Xn_train(:,i);
    
    namesave_vector  = [ './' features_folder '/' split_train(i)  '.h5'];
    hdf5write(char(namesave_vector), '/dataset1', pcnn_vector);
end

for i=1:length(split_test)
    split_test(i)
    
    pcnn_vector = Xn_test(:,i);
    
    namesave_vector  = [ './' features_folder '/' split_test(i)  '.h5'];
    hdf5write(char(namesave_vector), '/dataset1', pcnn_vector);
end




