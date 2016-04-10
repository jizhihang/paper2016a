inline
opt_feat::opt_feat(const std::string in_path,
		   const std::string in_MissUniverse
)
:path(in_path), MissUniverse(in_MissUniverse)
{

  list_missUni.load( MissUniverse );  
  dim = 14;

}

inline
void
opt_feat::features_all_videos(int view ) 
{
  int n_years = list_missUni.n_rows;

  int total_videos = 0;

  for (int y = 0; y< n_years; ++y)    
  {
    std::stringstream ss_country_list;
    ss_country_list << path << list_missUni (y) << "/country_list.txt";
    field <std::string> country_list ;
    country_list.load( ss_country_list.str() );
    
    //cout << country_list.n_rows << endl;
    total_videos = total_videos + country_list.n_rows;
    
  }
  
  //cout << "total_videos " << total_videos << endl;
  //getchar();
  field <std::string> load_save_names (total_videos,3); 
  int k =0;
  
  
  
  //Correr solo una vez
  create_folder("features");
  for (int y = 0; y< n_years; ++y)    
  {
    
    std::stringstream ss_country_list;
    ss_country_list << path << list_missUni(y) << "/country_list.txt";
    field <std::string> country_list ;
    country_list.load( ss_country_list.str() );
    //country_list.print();
    
    //getchar();
    
    int n_queens = country_list.n_rows;
    
    
    //Correr solo una vez    
    std::stringstream  ss_create_folder;
    ss_create_folder << "features/" << list_missUni(y);  
    create_folder( ss_create_folder.str() );

    for (int q=0; q<n_queens; ++q)
    {

      
      std::stringstream folder;
      std::stringstream save_feat_video_i;
      std::stringstream save_labels_video_i;
      
      folder << path << list_missUni(y) << "/" << country_list(q) << "-" << view;
      
      
      save_feat_video_i   << "./features/" << list_missUni(y) << "/" << country_list(q) << "_view" << view << ".h5";
      save_labels_video_i << "./features/" << list_missUni(y) << "/lab_" << country_list(q)  << "_view" << view << ".h5";
      
      load_save_names(k,0) = folder.str();
      load_save_names(k,1) = save_feat_video_i.str();
      load_save_names(k,2) = save_labels_video_i.str();
      k++;
      
    }
  }
  
  
  
  
  
  //int nProcessors=omp_get_max_threads();
  //std::cout<<nProcessors<<std::endl;
  //std::cout<< omp_get_num_threads()<<std::endl;
  
  
  //wall_clock timer;
  //timer.tic();
  //omp_set_num_threads(8); //Use only 8 processors
  
  //#pragma omp parallel for 
  
  
  for (int i = 0; i<load_save_names.n_rows; ++i)
  {
    
    std::string one_folder = load_save_names(i,0);
    //int tid=omp_get_thread_num();
    
    //#pragma omp critical
    //cout<< "Processor " << tid <<" doing "<< one_folder << endl;
    
    
    Struct_feat_lab my_Struct_feat_lab;
    cout << one_folder << endl;
    //getchar( );
    
   
    feature_video( one_folder, my_Struct_feat_lab ); // It's not a video is a set of frames
    
    
    
    mat mat_features_video_i;
    vec lab_video_i;
    
    if (my_Struct_feat_lab.features_video_i.size()>0)
    {
      mat_features_video_i.zeros( dim,my_Struct_feat_lab.features_video_i.size() );
      lab_video_i.zeros( my_Struct_feat_lab.features_video_i.size() );
      for (uword i = 0; i < my_Struct_feat_lab.features_video_i.size(); ++i)
      {
	mat_features_video_i.col(i) = my_Struct_feat_lab.features_video_i.at(i)/norm(my_Struct_feat_lab.features_video_i.at(i),2);
	lab_video_i(i) = my_Struct_feat_lab.labels_video_i.at(i);
      }
    }
    else
    {
      mat_features_video_i.zeros(dim,0);
    }
    
    
    my_Struct_feat_lab.features_video_i.clear();
    my_Struct_feat_lab.labels_video_i.clear();
  
  
    std::string save_feat_video_i   = load_save_names(i,1);
    std::string save_labels_video_i = load_save_names(i,2);
    

    mat_features_video_i.save( save_feat_video_i, hdf5_binary );
    lab_video_i.save( save_labels_video_i, hdf5_binary );

    
  
  }
  
  
  

  
  
  
  
}

// //****************** Feature Extraction**************************************
// //***************************************************************************


inline 
void
opt_feat::feature_video( std::string one_folder, Struct_feat_lab &my_Struct_feat_lab )
{
 
  
  std::stringstream ss_frames_list;
  std::stringstream ss_bbox_list;
      
  ss_frames_list <<  one_folder << "/list.txt";
  ss_bbox_list << one_folder << "/BB_all_frames.txt";
  
  field<std::string> frames_list;
  frames_list.load( ss_frames_list.str() );
  
  mat bb_list;
  bb_list.load( ss_bbox_list.str() );
  
  int n_frames = frames_list.n_rows;
  
  my_Struct_feat_lab.features_video_i.clear();
  my_Struct_feat_lab.labels_video_i.clear();
  
  
  cv::Mat prevgray, gray, flow, cflow, frame, prevflow, frame_tmp;
  cv::Mat ixMat, iyMat, ixxMat, iyyMat;
  cv::Mat flow_xy[2], mag, ang;
  
  
  string text;
  
  rowvec BB;
  
  
	
  cout << frames_list.n_rows << " - " << bb_list.n_rows << endl;
  
  
  for(int fr=0; fr<n_frames; fr++){
    
    //cout << fr << " " ;
    
    std::stringstream  ss_frame_name;
    ss_frame_name << one_folder << "/" << frames_list(fr);
    
    //cout << ss_frame_name.str() << endl;
    
    
    
    frame_tmp = cv::imread( ss_frame_name.str());
    
    BB = bb_list.row(fr);
    //BB.print();

    
    cv::Rect rec;
    rec.x = BB(0);
    rec.y = BB(1);
    rec.width = BB(2);
    rec.height = BB(3);

    frame=frame_tmp(rec);
    
    cv::resize(frame, frame, cvSize(50, 100));



    //frame=frame_tmp;
    cv::cvtColor(frame, gray, CV_BGR2GRAY);
    
    int new_row = frame.rows;
    int new_col = frame.cols;

    if( prevgray.data )
    {
      //cout << t << " " ;
      cv::calcOpticalFlowFarneback(prevgray, 
				   gray, 
				   flow, 
				   0.5, //pyr_scale
				   3,   //levels
				   9,   //winsize
				   1,   //iterations
				   5,   //poly_n
				   1.1, //poly_sigma
				   0);  //flags
      
      
      //optical flow
      cv::split(flow, flow_xy);
      cv::cartToPolar(flow_xy[0], flow_xy[1], mag, ang, true);
      
      cv::Sobel(gray, ixMat, CV_32F, 1, 0, 1);
      cv::Sobel(gray, iyMat, CV_32F, 0, 1, 1);
      cv::Sobel(gray, ixxMat, CV_32F, 2, 0, 1);
      cv::Sobel(gray, iyyMat, CV_32F, 0, 2, 1);
      
      float  ux = 0, uy = 0, vx = 0,  vy = 0;
      float u, v;
      
      if( prevflow.data )
      {
	//cout << new_col << " " << new_row << endl;
	
	for (int x = 0 ; x < new_col ; ++x ){
	  for (int y = 0 ; y < new_row ; ++y ) {
	    
	    vec features_one_pixel(dim);
	    u = flow.at<cv::Vec2f>(y, x)[0];
	    v = flow.at<cv::Vec2f>(y, x)[1];
	    
	    //cout << "x= " << x << " - y= " << y << endl;
	    // x grad
	    //cout << " x y grad" << endl;
	    float ix = ixMat.at<float>(y, x);
	    //cout << " y grad" << endl;
	    float iy = iyMat.at<float>(y, x);
	    
	    // grad direction &  grad magnitude. (Edges)
	    //cout << "grad direction &  grad magnitude" << endl;
	    float gd = std::atan2(std::abs(iy), std::abs(ix));
	    float gm = std::sqrt(ix * ix + iy * iy);
	    
	    // x second grad
	    //cout << "x y  second grad " << endl;
	    float ixx = ixxMat.at<float>(y, x);
	    // y second grad
	    float iyy = iyyMat.at<float>(y, x);
	    
	    //du/dt
	    float ut = u - prevflow.at<cv::Vec2f>(y, x)[0];
	    // dv/dt
	    float vt = v - prevflow.at<cv::Vec2f>(y, x)[1];
	    
	    
	    
	    if (x>0 && y>0 )
	    {
	      ux = u - flow.at<cv::Vec2f>(y, x - 1)[0];
	      uy = u - flow.at<cv::Vec2f>(y - 1, x)[0];
	      vx = v - flow.at<cv::Vec2f>(y, x - 1)[1];
	      vy = v - flow.at<cv::Vec2f>(y - 1, x)[1];
	    }
	    
	    
	    float Div = (ux + vy);
	    float Vor = (vx - uy);
	    //Adding more features
	    mat G (2,2);
	    mat S;
	    float gd_opflow = ang.at<float>(y,x);
	    float mg_opflow = mag.at<float>(y,x);
	    //Gradient Tensor
	    G   << ux << uy << endr
	    << vx << vy << endr;
	    
	    //Rate of Stein Tensor  
	    S = 0.5*(G + G.t());
	    
	    float tr_G = trace(G);
	    float tr_G2 = trace( square(G) );
	    float tr_S = trace(S);
	    float tr_S2 = trace(square(S));
	    
	    //Tensor Invariants  of the optical flow
	    float Gten = 0.5*( tr_G*tr_G - tr_G2 );
	    float Sten = 0.5*( tr_S*tr_S - tr_S2 ); 

	      
	      features_one_pixel  << x << y << abs(ix) << abs(iy) << abs(ixx) 
	      << abs(iyy) << gm << gd <<  u << v << abs(ut) 
	      << abs(vt) << (ux + vy)  << (vx - uy);
	    
	    
	    
	    
	    if (!is_finite( features_one_pixel ) )
	    {
	      cout << "It's not FINITE... continue???" << endl;
	      getchar(); 
	    }
	    // Plotting Moving pixels
	    //cout << " " << gm;
	    
	    double is_zero = accu(abs(features_one_pixel));
	    
	    if (gm>40 && is_finite( features_one_pixel ) && is_zero!=0 ) // Empirically set to 40
	    {   
	      
	      frame.at<cv::Vec3b>(y,x)[0] = 0;
	      frame.at<cv::Vec3b>(y,x)[1] = 0;
	      frame.at<cv::Vec3b>(y,x)[2] = 255;
	      my_Struct_feat_lab.features_video_i.push_back(features_one_pixel);
	      my_Struct_feat_lab.labels_video_i.push_back( fr );
	    }
	  }
	}
      }
      
      if(cv::waitKey(30)>=0)
	break;
      
    }
    
    
    cv::rectangle( frame, rec, cvScalar(0,255,0) );
    
    
    std::swap(prevgray, gray);
    std::swap(prevflow, flow);
    
    cv::imshow("color", frame);
    cv::waitKey(1);
    
  }
  
  
}



/// See all videos with Bboxes
inline
void
opt_feat::see_all_videos(int view ) 
{
  int n_years = list_missUni.n_rows;

  for (int y = 0; y< n_years; ++y)    
  {
    
    std::stringstream ss_country_list;
    ss_country_list << path << list_missUni(y) << "/country_list.txt";
    field <std::string> country_list ;
    country_list.load( ss_country_list.str() );
    
    int n_queens = country_list.n_rows;
    
    std::stringstream scores;
    scores << path << list_missUni(y) << "/" << "scores.txt";
    field <std::string> scores_list;
    
    scores_list.load( scores.str() );
    float one_score;
    //scores_list.print();
    
    
    vec vec_scores;
    vec_scores.zeros(scores_list.n_rows);
    
    for (int s = 0; s<scores_list.n_rows; ++s)
    {
      
      double temp = ::atof(scores_list(s,1).c_str());
      vec_scores(s) = temp;
      
    }
    
    //vec_scores.print();
    uword  index_min;
    double min_val = vec_scores.min(index_min);
    uword  index_max;
    double max_val = vec_scores.max(index_max);
    
    cout << "***********************" << endl;
    cout <<  list_missUni(y)<< endl;
    cout << country_list(index_max) << " got max " << max_val << endl; 
    cout << country_list(index_min) << " got min " << min_val << endl;
    cout << "***********************" << endl;
   
    
/*
    for (int q=0; q<n_queens; ++q)
    {

      
      

      std::stringstream one_folder;
      one_folder << path << list_missUni(y) << "/" << country_list(q) << "-" << view;
      
      one_score = vec_scores(q);
      cout << list_missUni(y) << "/" << country_list(q) << ". Score: "<< one_score << endl;
      
      //getchar();
      //visualise( one_folder.str(), one_score); // It's not a video is a set of frames

    }
    */
    getchar();
  }

}


inline 
void
opt_feat::visualise( std::string one_folder, float one_score )
{
 
  
  
  std::stringstream ss_frames_list;
  std::stringstream ss_bbox_list;
      
  ss_frames_list <<  one_folder << "/list.txt";
  ss_bbox_list << one_folder << "/BB_all_frames.txt";
  
  field<std::string> frames_list;
  frames_list.load( ss_frames_list.str() );
  
  mat bb_list;
  bb_list.load( ss_bbox_list.str() );
  
  int n_frames = frames_list.n_rows;
  

  
  
  cv::Mat frame,  frame_tmp, gray;
  std::string text;
  rowvec BB;
  
  
	
  //cout << frames_list.n_rows << " - " << bb_list.n_rows << endl;
  
  
  for(int fr=0; fr<n_frames; fr++){
    
    //cout << fr << " " ;
    
    std::stringstream  ss_frame_name;
    ss_frame_name << one_folder << "/" << frames_list(fr);
    
    //cout << ss_frame_name.str() << endl;
    
    
    
    frame_tmp = cv::imread( ss_frame_name.str());
    
    BB = bb_list.row(fr);
    //BB.print();

    
    cv::Rect rec;
    rec.x = BB(0);
    rec.y = BB(1);
    rec.width = BB(2);
    rec.height = BB(3);

    frame=frame_tmp(rec);
    
    cv::resize(frame, frame, cvSize(50, 100));

    cv::cvtColor(frame, gray, CV_BGR2GRAY);
    
    int new_row = frame.rows;
    int new_col = frame.cols;
    
    //cv::rectangle( frame_tmp, rec, cvScalar(0,255,0), 2 );

    cv::imshow("color", frame_tmp);
    cv::waitKey( 60);

  
}

}



///Auxiliary Functions

inline
void
opt_feat::create_folder(const std::string path, std::string name)
{
  
  std::stringstream folder_name;
  folder_name << "mkdir -p " << path << name;
  //cout << folder_name.str() << endl;
  //getchar();
  
  
  const int dir_err = system( folder_name.str().c_str() );
  
  if (-1 == dir_err)
  {
    printf("Error creating directory!n");
    exit(1);
  }
  
  
}

inline
void
opt_feat::create_folder( std::string name)
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