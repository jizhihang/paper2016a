function create_folders_FV(FV_folder, red_FV_folder, GMM_folder)



%FV
if ~exist(FV_folder, 'dir')
    mkdir(FV_folder);
end

%red_FV
if ~exist(red_FV_folder, 'dir')
    mkdir(red_FV_folder);
end


%Universal GMM
if ~exist(GMM_folder, 'dir')
    mkdir(GMM_folder);
end

