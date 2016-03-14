//Taken from: http://stackoverflow.com/questions/22140880/drawing-rectangle-or-line-using-mouse-events-in-open-cv-using-python
#include <omp.h>
#include <stdio.h>
#include <opencv2/opencv.hpp>
#include <fstream>
#include <iostream>
#include <armadillo>
#include <iomanip>
#include <vector>



using namespace std;
using namespace arma;
using namespace cv;



cv::Mat src,img,ROI;
Rect cropRect(0,0,0,0);
Point P1(0,0);
Point P2(0,0);

const char* winName="Crop Image";
bool clicked=false;
int i=0;
char imgName[15];


void 
checkBoundary()
{
  //check croping rectangle exceed image boundary
  if(cropRect.width>img.cols-cropRect.x)
    cropRect.width=img.cols-cropRect.x;
  
  if(cropRect.height>img.rows-cropRect.y)
    cropRect.height=img.rows-cropRect.y;
  
  if(cropRect.x<0)
    cropRect.x=0;
  
  if(cropRect.y<0)
    cropRect.height=0;
}

void 
showImage(){
  img=src.clone();
  checkBoundary();
  if(cropRect.width>0&&cropRect.height>0){
    ROI=src(cropRect);
    imshow("cropped",ROI);
    
  }
  
  rectangle(img, cropRect, Scalar(0,255,0), 1, 8, 0 );
  imshow(winName,img);
}


inline void list_frames(const std::string path, std::string country);
inline void  creating_bbox(const std::string path, std::string country);



void onMouse( int event, int x, int y, int f, void* ){
  
  
  switch(event){
    
    case  CV_EVENT_LBUTTONDOWN  :
      clicked=true;
      
      P1.x=x;
      P1.y=y;
      P2.x=x;
      P2.y=y;
      break;
      
    case  CV_EVENT_LBUTTONUP    :
      P2.x=x;
      P2.y=y;
      clicked=false;
      break;
      
    case  CV_EVENT_MOUSEMOVE    :
      if(clicked){
	P2.x=x;
	P2.y=y;
      }
      break;
      
    default                     :   break;
    
    
  }
  
  
  if(clicked){
    if(P1.x>P2.x){ cropRect.x=P2.x;
      cropRect.width=P1.x-P2.x; }
      else {         cropRect.x=P1.x;
	cropRect.width=P2.x-P1.x; }
	
	if(P1.y>P2.y){ cropRect.y=P2.y;
	  cropRect.height=P1.y-P2.y; }
	  else {         cropRect.y=P1.y;
	    cropRect.height=P2.y-P1.y; }
	    
  }
  
  
  showImage();
  
}


int
main(int argc, char** argv)
{
  cout<<"Click and drag for Selection"<<endl<<endl;
  cout<<"------> Press 's' to save"<<endl<<endl;
  cout<<"------> Press '8' to move up"<<endl;
  cout<<"------> Press '2' to move down"<<endl;
  cout<<"------> Press '6' to move right"<<endl;
  cout<<"------> Press '4' to move left"<<endl<<endl;
  
  cout<<"------> Press 'w' increas top"<<endl;
  cout<<"------> Press 'x' increas bottom"<<endl;
  cout<<"------> Press 'd' increas right"<<endl;
  cout<<"------> Press 'a' increas left"<<endl<<endl;
  
  cout<<"------> Press 't' decrease top"<<endl;
  cout<<"------> Press 'b' decrease bottom"<<endl;
  cout<<"------> Press 'h' decrease right"<<endl;
  cout<<"------> Press 'f' decrease left"<<endl<<endl;
  
  
  cout<<"------> Press 'p' see previous frame"<<endl<<endl;
  
  cout<<"------> Press 'r' to reset"<<endl;
  cout<<"------> Press 'Esc' to quit"<<endl<<endl;
  
  
  
  //Path @Home
  //const std::string path =  "/media/johanna/HD1T/codes/datasets_codes/EveningGownCompetition/MissUniverse2007/";
  
  //Path @UQ
  const std::string path = "/home/johanna-uq/codes/datasets_codes/EveningGownCompetition/MissUniverse2010/";
  
  std::string country;
  
  
  std::string country_boundaries =  "Country_Ini_End_2.txt";
  std::stringstream country_boundaries_path;
  country_boundaries_path << path << country_boundaries;
  field<string> oriVideo_info;
  oriVideo_info.load(country_boundaries_path.str());
  oriVideo_info.col(0).print();
  int num_queens= oriVideo_info.n_rows;
  
  for (int q = 0; q  < num_queens; q=q+2) //Use only one view
  {
    country = oriVideo_info(q,0);       
    list_frames(path, country);
    creating_bbox(path, country);
    
    //getchar();
  }
  
  return 0;
  
}

inline
void
list_frames(const std::string path, std::string country)
{
  
  //List all jpg files in list.txt 
  std::stringstream create_list;
  create_list << "ls " << path << country <<  "/*.jpg | xargs -n 1 basename >" << path << country <<  "/list.txt"; 
  //cout << create_list.str() << endl;
  //getchar();
  
  
  const int dir_err = system( create_list.str().c_str() );
  
  if (-1 == dir_err)
  {
    printf("Error creating file!n");
    exit(1);
  }
  
  
  
  
}



inline 
void 
creating_bbox(const std::string path, std::string country)
{
  
  std::stringstream list;
  list << path << country <<  "/list.txt";
  cout << list.str() << endl;
  field<std::string> frames_list;
  
  frames_list.load( list.str() );
  
  int n_frames = frames_list.n_elem;
  mat bb_frames;
  bb_frames.zeros(n_frames,4);
  
  cout << n_frames << endl;
  
  
  
  
  for(int fr = 0; fr<n_frames; fr++){
    
    std::stringstream frame_name;
    
    frame_name << path << country << "/" << frames_list(fr);
    
    src = imread( frame_name.str(),1);
    
    //Create a window
    namedWindow(winName, 1);
    setMouseCallback(winName,onMouse,NULL );
    //show the image
    imshow(winName, src);
    
    while(1){
      char c=waitKey();
      
      if(c=='s'&&ROI.data){
	
	vec BB;
	BB.zeros(4); 
	
	BB(0) = cropRect.x;
	BB(1) = cropRect.y;
	BB(2) = cropRect.width;
	BB(3) = cropRect.height;
	
	bb_frames.row(fr) = BB.t();	 
	break;
	
      }
      
      
      if(c=='6') cropRect.x++;
      if(c=='4') cropRect.x--;
      if(c=='8') cropRect.y--;
      if(c=='2') cropRect.y++;
      
      if(c=='w') { cropRect.y--; cropRect.height++;}
      if(c=='d') cropRect.width++;
      if(c=='x') cropRect.height++;
      if(c=='a') { cropRect.x--; cropRect.width++;}
      
      if(c=='t') { cropRect.y++; cropRect.height--;}
      if(c=='h') cropRect.width--;
      if(c=='b') cropRect.height--;
      if(c=='f') { cropRect.x++; cropRect.width--;}
      if(c=='p') { fr=fr-2;break;}
      
      if(c==27) break;
      if(c=='r') {cropRect.x=0;cropRect.y=0;cropRect.width=0;cropRect.height=0;}     imshow(winName, src);
      showImage();
      
    }
    
    
    
  }
  
  std::stringstream bb_name;
  bb_name << path << country <<  "/BB_all_frames.txt";
  cout<< "  Saving " <<bb_name.str() <<endl;
  bb_frames.save( bb_name.str(), raw_ascii );
  
  
}



