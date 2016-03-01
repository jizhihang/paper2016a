function get_descriptors_BoW(list_pac_tr,list_pac_te,K,path, dim, Kmeans_folder, BoW_folder  )


% Getting descriptors for Training Set
for i=1:length(list_pac_tr)
    one_video_pac = {list_pac_tr{i,:}};
    get_BoW_histograms(one_video_pac, K,path, dim, Kmeans_folder, BoW_folder);
end

% Getting descriptors for Testing Set

for i=1:length(list_pac_te)
    one_video_pac = {list_pac_te{i,:}};
    get_BoW_histograms(one_video_pac, K,path, dim, Kmeans_folder, BoW_folder);
end