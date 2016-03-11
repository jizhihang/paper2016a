#include <omp.h>
#include <stdio.h>
#include <opencv2/opencv.hpp>
#include <fstream>
#include <iostream>
#include <armadillo>
#include <iomanip>
#include <vector>
#include <cstdlib>



using namespace std;
using namespace arma;
using namespace cv;



cv::Mat src,img,ROI;
Rect cropRect(0,0,0,0);
Point P1(0,0);
Point P2(0,0);

const char* winName="Original Video";
bool clicked=false;
int i=0;
char imgName[15];



inline void create_folder(const std::string path, std::string country);
inline int play_sub_video(const std::string path, std::string video_name, std::string country, int ini_fr, int end_fr);
inline int play_sub_video_2(const std::string path, std::string video_name, int ini_fr, int end_fr );
inline int save_frames(const std::string path, std::string video_name, std::string country, int ini_fr, int end_fr );


//No funciona.
inline int create_new_video(const std::string path, std::string video_name, std::string country, int ini_fr, int end_fr);


//Steps:
inline int visualise_original_video(const std::string path, std::string video_name );
inline void step_2(const std::string path, std::string video_name);
inline void step_3(const std::string path, std::string video_name);


int
main(int argc, char** argv)
{
  
  cout<<"------> Press 'p' see previous frame" << endl << endl;
  cout<<"------> Press 'n' see previous frame" << endl << endl;
  
  cout<<"------> Press 'Esc' to quit"<<endl<<endl;
  
  // Path @ Home
  //const std::string path = "/media/johanna/HD1T/codes/datasets_codes/EveningGownCompetition_v3/MissUniverse2010/";
  
  //Path @UQ
  const std::string path = "/home/johanna-uq/codes/datasets_codes/EveningGownCompetition/MissUniverse2001/";
  
  
  
  std::string video_name =  "OriginalVideo_2001.mp4";
  
  
  
  
  
  /// Step 1: 
  // See the Original Video and manually select Initial and End Frame per
  // participant. Create file "Country_Ini_End.txt";
  //visualise_original_video(path, video_name );
  
  
  
  
  /// Step 2: The initial frames and ending frames of each participant are stored in "Country_Ini_End.txt"
  // see each one and select the starting and ending frame of two views. 
  // See  Frames Numbers are shown. Using the Initial and End Frame per Participant
  //Manually create the file  "Country_Ini_End_2.txt"
  //step_2(path,  video_name); 
  
  
   /// Step 3: 
  //Creating Folders and Using 2 views per participant. Saving frames in each folder
  step_3( path, video_name);
  
  

  
  
}

inline void step_2(const std::string path, std::string video_name)
{
  
  std::string country, sIni, sEnd;
  int ini_fr, end_fr;
  std::string country_boundaries =  "Country_Ini_End.txt";
  std::stringstream country_boundaries_path;
  country_boundaries_path << path << country_boundaries;
  field<string> oriVideo_info;
  oriVideo_info.load(country_boundaries_path.str());
  oriVideo_info.print();
  
  
  int num_queens= oriVideo_info.n_rows;
  
  for (int q=0; q  < num_queens; q++)
  {
    
    //cout << q << endl;
    country = oriVideo_info(q,0);
    
    sIni = oriVideo_info( q,1);
    ini_fr = atoi( sIni.c_str());
    
    sEnd = oriVideo_info( q,2);
    end_fr = atoi( sEnd.c_str() );
    
    cout << country << " " << ini_fr << " " << end_fr  << endl;
    
    play_sub_video_2( path, video_name, ini_fr, end_fr);
    
  }
}



inline void step_3(const std::string path, std::string video_name)
{
  
  std::string country, sIni, sEnd;
  int ini_fr, end_fr;
  
  
  std::string country_boundaries =  "Country_Ini_End_2.txt";
  std::stringstream country_boundaries_path;
  country_boundaries_path << path << country_boundaries;
  field<string> oriVideo_info;
  oriVideo_info.load(country_boundaries_path.str());
  oriVideo_info.print();
  int num_queens= oriVideo_info.n_rows;
     
     for (int q=0; q  < num_queens; q++)
     {
       country = oriVideo_info(q,0);       
       sIni = oriVideo_info( q,1);
       ini_fr = atoi( sIni.c_str());
       
       sEnd = oriVideo_info( q,2);
       end_fr = atoi( sEnd.c_str() );
       
       cout << country << " " << ini_fr << " " << end_fr  << endl;
       
       create_folder(path, country);
       save_frames(path, video_name, country, ini_fr, end_fr );
     }
  
}




inline
void
create_folder(const std::string path, std::string country)
{
  
  std::stringstream folder_name;
  folder_name << "mkdir -p " << path << country;
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
int
play_sub_video(const std::string path, std::string video_name, std::string country, int ini_fr, int end_fr)
{
  std::stringstream video_path;
  
  video_path << path << video_name;
  std::string one_video;
  one_video = video_path.str();
  cout << one_video << endl;
  
  
  cv::VideoCapture inputVideo(one_video);
  int n_frames = inputVideo.get(CV_CAP_PROP_FRAME_COUNT);
  
  if( !inputVideo.isOpened() )
  {
    cout << "Video couldn't be opened" << endl;
    return 0;
    
  }
  
  
  for(int fr=ini_fr; fr<end_fr; fr++){
    
    inputVideo.set(CV_CAP_PROP_POS_FRAMES, fr); //start the video at 300ms
    //cout << fr << endl;
    
    // src=imread("Nemo.jpg",1);
    inputVideo.read(src);
    
    namedWindow(country, 1);
    //show the image
    imshow(country, src);
    waitKey(0.5);
    
  }
  
  return 0;  
}




inline
int
save_frames(const std::string path, std::string video_name, std::string country, int ini_fr, int end_fr )
{
  
  std::stringstream video_path;
  
  std::stringstream root_name;
  root_name << path << country << "/";
  
  
  
  video_path << path << video_name;
  std::string one_video;
  one_video = video_path.str();
  //cout << one_video << endl;
  
  
  cv::VideoCapture inputVideo(one_video);
  int n_frames = inputVideo.get(CV_CAP_PROP_FRAME_COUNT);
  
  if( !inputVideo.isOpened() )
  {
    cout << "Video couldn't be opened" << endl;
    return 0;
    
  }
  
  int ini_frame = ini_fr;
  int k = 1;
  
  for(int fr=ini_frame; fr<end_fr; fr++){
    
    inputVideo.set(CV_CAP_PROP_POS_FRAMES, fr); //start the video at 300ms
    inputVideo.read(src);
    
    std::stringstream frame_posi;   
    frame_posi << root_name.str() << std::setfill('0') << std::setw(3) << k << ".jpg";    
    imwrite( frame_posi.str(), src );    
    k++;
    
  }
  
  return 0; 
  
}


inline
int
play_sub_video_2(const std::string path, std::string video_name, int ini_fr, int end_fr )
{
  std::stringstream video_path;
  video_path << path << video_name;
  std::string one_video;
  one_video = video_path.str();
  cout << one_video << endl;
  
  cv::VideoCapture inputVideo(one_video);
  int n_frames = inputVideo.get(CV_CAP_PROP_FRAME_COUNT);
  
  if( !inputVideo.isOpened() )
  {
    cout << "Video couldn't be opened" << endl;
    return 0;
  }
  
  
  int ini_frame = ini_fr;
  
  for(int fr=ini_frame; fr<end_fr; fr++){
    
    inputVideo.set(CV_CAP_PROP_POS_FRAMES, fr); //start the video at 300ms
    //cout << fr << endl;
    
    // src=imread("Nemo.jpg",1);
    inputVideo.read(src);
    
    std::stringstream frame_num;
    frame_num << fr;
    
    string text = frame_num.str();
    int fontFace = FONT_HERSHEY_SCRIPT_SIMPLEX;
    double fontScale = 1;
    int thickness = 3;  
    cv::Point textOrg(10, 30);
    cv::putText(src, text, textOrg, fontFace, fontScale, Scalar::all(255), thickness,8);
    
    //Create a window
    namedWindow(winName, 1);
    //show the image
    imshow(winName, src);
    
    while(1){
      char c=waitKey();
      if(c=='p') { fr=fr-2;break;}
      if(c=='n') { break;}
      if(c==27) {fr = end_fr ; break;}
    }
  }

  return 0; 
  
}




inline
int
visualise_original_video(const std::string path, std::string video_name )
{
  
  std::stringstream video_path;
  
  video_path << path << video_name;
  std::string one_video;
  one_video = video_path.str();
  cout << one_video << endl;
  
  
  cv::VideoCapture inputVideo(one_video);
  int n_frames = inputVideo.get(CV_CAP_PROP_FRAME_COUNT);
  
  if( !inputVideo.isOpened() )
  {
    cout << "Video couldn't be opened" << endl;
    return 0;
    
  }
  
  
  
  int ini_frame = 0;
  
  for(int fr=ini_frame; fr<n_frames; fr++){
    
    inputVideo.set(CV_CAP_PROP_POS_FRAMES, fr); //start the video at 300ms
    //cout << fr << endl;
    
    // src=imread("Nemo.jpg",1);
    inputVideo.read(src);
    
    std::stringstream frame_num;
    frame_num << fr;
    
    string text = frame_num.str();
    int fontFace = FONT_HERSHEY_SCRIPT_SIMPLEX;
    double fontScale = 1;
    int thickness = 3;  
    cv::Point textOrg(10, 30);
    cv::putText(src, text, textOrg, fontFace, fontScale, Scalar::all(255), thickness,8);
    
    
    //Create a window
    namedWindow(winName, 1);
    //show the image
    imshow(winName, src);
    
    while(1){
      
      char c=waitKey();
      
      if(c=='p') { fr=fr-2;break;}
      
      if(c=='n') { break;}
      
      if(c==27) {fr = n_frames ; break;}
      
    }
    
  }
  return 0; 
  
}



//No funciona. Problema creando el nuevo archivo para guardar el nuevo video  :(
inline
int
create_new_video(const std::string path, std::string video_name, std::string country, int ini_fr, int end_fr)
{
  std::stringstream video_path;
  
  std::stringstream folderpath_name;
  folderpath_name << path << country << "/miss_"<< country << ".avi";
  
  
  
  video_path << path << video_name;
  std::string one_video;
  one_video = video_path.str();
  cout << one_video << endl;
  
  
  cv::VideoCapture inputVideo(one_video);
  int n_frames = inputVideo.get(CV_CAP_PROP_FRAME_COUNT);
  
  if( !inputVideo.isOpened() )
  {
    cout << "Video couldn't be opened" << endl;
    return 0;
    
  }
  
  string::size_type pAt = one_video.find_last_of('.');                  // Find extension point
  int ex = static_cast<int>(inputVideo.get(CV_CAP_PROP_FOURCC));     // Get Codec Type- Int form
  
  // Transform from int to char via Bitwise operators
  char EXT[] = {(char)(ex & 0XFF) , (char)((ex & 0XFF00) >> 8),(char)((ex & 0XFF0000) >> 16),(char)((ex & 0XFF000000) >> 24), 0};
  cout << "Input codec type: " << EXT << endl;
  
  
  Size S = Size((int) inputVideo.get(CV_CAP_PROP_FRAME_WIDTH),    // Acquire input size
		(int) inputVideo.get(CV_CAP_PROP_FRAME_HEIGHT));
  
  
  VideoWriter outputVideo; // Open the output
  
  //outputVideo.open(folderpath_name.str(), ex, inputVideo.get(CV_CAP_PROP_FPS), S, true);
  outputVideo.open(folderpath_name.str(), ex=-1, inputVideo.get(CV_CAP_PROP_FPS), S, true);
  
  if (!outputVideo.isOpened())
  {
    cout  << "Could not open the output video for write: " << folderpath_name.str() << endl;
    return -1;
  }
  
  cout << "Input frame resolution: Width=" << S.width << "  Height=" << S.height
  << " of nr#: " << inputVideo.get(CV_CAP_PROP_FRAME_COUNT) << endl;
  cout << "Input codec type: " << EXT << endl;
  
  
  
  for(int fr=ini_fr; fr<end_fr; fr++){
    
    inputVideo.set(CV_CAP_PROP_POS_FRAMES, fr); //start the video at 300ms
    //cout << fr << endl;
    
    // src=imread("Nemo.jpg",1);
    inputVideo.read(src);
    outputVideo << src;
    
    namedWindow(country, 1);
    //show the image
    imshow(country, src);
    waitKey(1);
    
  }
  
  return 0;  
}
