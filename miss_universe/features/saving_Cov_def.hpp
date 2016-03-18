class OverlappedCovs
{
public:  
    inline OverlappedCovs(const std::string in_path,
		    const std::string in_MissUniverseList
                  );
    


    inline void calculate_covariances( int view );
    

    field<std::string> list_missUni;
    const std::string path;
    const std::string MissUniverseList;
    

  private: 
    inline void one_video_multiple_covs( std::string load_feat_video_i, std::string load_labels_video_i, std::string missUni_year, std::string country);
    inline mat mehrtash_suggestion(mat cov_i);
    inline void create_folder( std::string name);



 
  
};