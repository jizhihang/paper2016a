function get_FV_descriptors(list_pac_tr, list_pac_te, K,path, dim, GMM_folder, FV_folder)


for i=1:length(list_pac_tr)
    %i
    one_video_pac = {list_pac_tr{i,:}};
    %tic
    FV_kth_all_videos(one_video_pac, K,path, dim, GMM_folder, FV_folder);
    %toc
end



for i=1:length(list_pac_te)
    %i
    one_video_pac = {list_pac_te{i,:}};
    %tic
    FV_kth_all_videos(one_video_pac, K,path, dim, GMM_folder, FV_folder);
    %toc
end