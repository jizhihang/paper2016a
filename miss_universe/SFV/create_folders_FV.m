function create_folders_FV(FV_folder, svm_folder, GMM_folder)



%FV
if ~exist(FV_folder, 'dir')
    mkdir(FV_folder);
end

%Universal GMM
if ~exist(GMM_folder, 'dir')
    mkdir(GMM_folder);
end


%svm models
if ~exist(svm_folder, 'dir')
    mkdir(svm_folder);
end