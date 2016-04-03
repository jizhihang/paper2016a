class opt_feat
{
public:  
  inline opt_feat(const std::string in_path,
		  const std::string in_MissUniverse
  );
  
  
  inline void features_all_videos( int view );
  inline void see_all_videos( int view );

  
  
  
  
  const std::string path;
  const std::string MissUniverse;
  int dim;
  
  
  
  field<std::string> list_missUni;
  
  struct Struct_feat_lab{
    vector <vec> features_video_i; //All vectors per video_i are stored here
    vector <int> labels_video_i;
    
  };
  
  
private:
  
  
  
  inline void feature_video( std::string one_video, Struct_feat_lab &my_Struct_feat_lab );
  inline void visualise( std::string one_folder  );
  inline void create_folder( const std::string path, std::string folder_name);
  inline void create_folder( std::string folder_name );


  
  
  
  
};
