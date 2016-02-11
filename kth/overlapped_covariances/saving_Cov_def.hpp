class OverlappedCovs_kth
{
public:  
    inline OverlappedCovs_kth(const std::string in_path,
		    const std::string in_actionNames,  
		    const float in_scale_factor, 
		    const int in_shift
                  );
    


    inline void calculate_covariances( field<string> all_people, int dim );
    


const std::string path;
const std::string actionNames;

const float scale_factor;
const int shift;
int dim;

field<std::string> actions;
field<string> all_people;


  private: 
    inline void one_video_multiple_covs( std::string load_feat_video_i, std::string load_labels_video_i, int pe, int act );
    inline mat mehrtash_suggestion(mat cov_i);



 
  
};