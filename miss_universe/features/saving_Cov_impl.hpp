inline
OverlappedCovs::OverlappedCovs( const std::string in_path,
				const std::string in_MissUniverseList)
:path( in_path ), MissUniverseList( in_MissUniverseList )
{
  
  list_missUni.load( MissUniverseList );  
  
  
}



///****************************************************************************************
///****************************************************************************************

inline
void
OverlappedCovs::calculate_covariances( int view )
{
  
  
  int n_years = list_missUni.n_rows;

  int total_videos = 0;

  for (int y = 0; y< n_years; ++y)    
  {
    std::stringstream ss_country_list;
    ss_country_list << path << list_missUni (y) << "/country_list.txt";
    field <std::string> country_list ;
    country_list.load( ss_country_list.str() );
    
    cout << country_list.n_rows << endl;
    total_videos = total_videos + country_list.n_rows;
    
  }
  
  cout << "total_videos " << total_videos << endl;
  //getchar();
  field <std::string> parallel_names (total_videos,4); 
  int k =0;
  
  
  create_folder( "covs" );
  
  for (int y = 0; y< n_years; ++y)    
  {
    
    std::stringstream ss_country_list;
    ss_country_list << path << list_missUni(y) << "/country_list.txt";
    field <std::string> country_list ;
    country_list.load( ss_country_list.str() );
    
    //country_list.print();
    //getchar();
    
    int n_queens = country_list.n_rows;
    
    
    std::stringstream  ss_create_folder;
    ss_create_folder << "covs/" << list_missUni(y);  
    create_folder( ss_create_folder.str() );

    for (int q=0; q<n_queens; ++q)
    {

      
      std::stringstream load_feat_video_i;
      std::stringstream load_labels_video_i;
      
     
      
      load_feat_video_i   << "./features/" << list_missUni(y) << "/" << country_list(q) << "_view" << view << ".h5";
      load_labels_video_i << "./features/" << list_missUni(y) << "/lab_" << country_list(q) << ".h5";
      
      parallel_names(k,0) = load_feat_video_i.str();
      parallel_names(k,1) = load_labels_video_i.str();
      parallel_names(k,2) = list_missUni(y); //MissUniverseYear
      parallel_names(k,3) = country_list(q); //Country
      
      
      k++;
      
    }
  }
  
  
   for (int i = 0; i<parallel_names.n_rows; ++i)
  {
    
    
    std::string load_feat_video_i;
    std::string load_labels_video_i;
    std::string missUni_year;
    std::string country;
    
    load_feat_video_i 	= parallel_names(i,0);
    load_labels_video_i = parallel_names(i,1);
    missUni_year 	= parallel_names(i,2); 
    country 		= parallel_names(i,3);
    
    
    cout <<  missUni_year << "_" << country << endl;
    one_video_multiple_covs(load_feat_video_i, load_labels_video_i, missUni_year, country );
    //getchar();
    
  }
    


  
  
}


inline
void
OverlappedCovs::one_video_multiple_covs( std::string load_feat_video_i, std::string load_labels_video_i, std::string missUni_year, std::string country)
{

    
    mat mat_features_video_i;    
    mat_features_video_i.load( load_feat_video_i, hdf5_binary );  
    
    vec labels;
    labels.load( load_labels_video_i, hdf5_binary );
    
    int n_vec = mat_features_video_i.n_cols;
    
    
    std::stringstream save_folder;
    
    save_folder << "./covs/" << missUni_year; ;
    

    
    
    
    int seg_length = 5;
    int num_frames;
    
    int length_lab = labels.n_elem;
    num_frames = labels(length_lab-1);
    
    //cout << labels( 0 ) << " ";
    //cout << num_frames << " " << endl;
    
    int num_covs = 0;
    mat seg_vec;
    
    
     for (int i=2; i<=num_frames-seg_length; ++i)
    {
      
      running_stat_vec<rowvec> stat_seg(true);
       
       for (int j=i; j<i+seg_length; ++j )
       {
	 
	 uvec q1 = find(labels == j);
	 //cout << q1.n_elem << endl;
	 seg_vec = mat_features_video_i.cols( q1 );
	 //cout << seg_vec.n_cols << " - " << seg_vec.n_rows << endl;
	 
	 for (int l=0; l<seg_vec.n_cols; ++l)
	 {
	   //cout << l << " ";
	   vec sample = seg_vec.col(l); 
	   stat_seg (sample);
	   
	}
	 
      }
      
     
      //By manual inspection, If the segment contains 
      //a reduced number of pixels, then discard it
     
      if (stat_seg.count() > 100 )  {
      
      
      num_covs++;
      std::stringstream save_Covs;
      save_Covs << save_folder.str() << "/Cov_" <<  country <<  "_segm" << num_covs <<  ".h5";
      mat seg_cov= stat_seg.cov();
      
      seg_cov = mehrtash_suggestion( seg_cov );
      
      //cout << save_Covs.str() << endl; 
      seg_cov.save(  save_Covs.str(), hdf5_binary ); 
      }
      else
      {
	 cout << stat_seg.count() << " " ;
      }
    	
     }
     
     
     //cout << endl;
     
    
    //cout << num_covs << endl;
    vec vecNumCovs;
    
    vecNumCovs << num_covs << endr;
    
    std::stringstream save_vecNumCovs;
    save_vecNumCovs << save_folder.str() << "/NumCov_" <<  country <<  ".dat";
    
    vecNumCovs.save( save_vecNumCovs.str(), raw_ascii ) ; 
    //getchar();
     
    
    
}



inline
mat
OverlappedCovs::mehrtash_suggestion(mat cov_i)
{
  //Following Mehrtash suggestions as per email dated June26th 2014
  mat new_covi;
  
  double THRESH = 0.000001;
  new_covi = 0.5*(cov_i + cov_i.t());
  vec D;
  mat V;
  eig_sym(D, V, new_covi);
  uvec q1 = find(D < THRESH);
  
  
  if (q1.n_elem>0)
  {
    for (uword pos = 0; pos < q1.n_elem; ++pos)
    {
      D( q1(pos) ) = THRESH;
      
    }
    
    new_covi = V*diagmat(D)*V.t();  
    
  }  
  
  return new_covi;
    //end suggestions
}



inline
void
OverlappedCovs::create_folder( std::string name)
{
  
  std::stringstream folder_name;
  folder_name << "mkdir -p " << name;
  //cout << folder_name.str() << endl;
  //getchar();
  
  
  const int dir_err = system( folder_name.str().c_str() );
  
  if (-1 == dir_err)
  {
    printf("Error creating directory!n");
    exit(1);
  }
  
  
}