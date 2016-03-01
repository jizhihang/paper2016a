function create_folders(Kmeans_folder,BoW_folder, svm_folder)



%Kmeans
if ~exist(Kmeans_folder, 'dir')
    mkdir(Kmeans_folder);
end

%Descriptors
if ~exist(BoW_folder, 'dir')
    mkdir(BoW_folder);
end


%svm models
if ~exist(svm_folder, 'dir')
    mkdir(svm_folder);
end