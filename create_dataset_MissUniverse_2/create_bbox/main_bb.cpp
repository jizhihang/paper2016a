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


void checkBoundary(){
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

void showImage(){
  img=src.clone();
  checkBoundary();
  if(cropRect.width>0&&cropRect.height>0){
    ROI=src(cropRect);
    imshow("cropped",ROI);
  }
  
  rectangle(img, cropRect, Scalar(0,255,0), 1, 8, 0 );
  imshow(winName,img);
}


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
  
  
  //Path  @ Home
  //const std::string path = "/media/johanna/HD1T/codes/datasets_codes/EveningGownCompetition/";
  
  // Path @ UQ
  const std::string path = "/home/johanna-uq/codes/datasets_codes/EveningGownCompetition/";
 
 
  
  
  std::string name =  "MissUniverse2009_Top10.mp4";
  std::stringstream video_path;
  
  
  std::string country_year;
  cout << "Folder Name (year_country: ";
  getline(cin, country_year);

  
  
  video_path << path << name;
  std::string one_video;
  one_video = video_path.str();
  cout << one_video << endl;
  
  
   cv::VideoCapture capVideo(one_video);
    int n_frames = capVideo.get(CV_CAP_PROP_FRAME_COUNT);
    
   if( !capVideo.isOpened() )
   {
     cout << "Video couldn't be opened" << endl;
     return 0;
     
   }
  
  
    ///CUIDADO COMO GUARDAS LAS FRAMES 1, 2,3
  // debes cambiarlo a 001, 002, 003, etc
  int ini_frame = 1565;
  
  for(int fr=ini_frame; fr<n_frames; fr++){
    
    capVideo.set(CV_CAP_PROP_POS_FRAMES, fr); //start the video at 300ms
    cout << fr << endl;
     
   // src=imread("Nemo.jpg",1);
    capVideo.read(src);
    
    //Create a window
    namedWindow(winName, 1);
    setMouseCallback(winName,onMouse,NULL );
    //show the image
    imshow(winName, src);
    
     while(1){
       char c=waitKey();
       
       if(c=='s'&&ROI.data){
	 std::stringstream bb_name;
	 bb_name << "./" << country_year <<  "/" <<fr << ".jpg";
	 //sprintf(imgName,"%d.jpg",i++);
	 //imwrite(imgName,ROI);
	 
	 cv::resize( ROI, ROI, cv::Size(250, 400) );
      
      
	 imwrite(bb_name.str().c_str(),ROI);
	 bb_name.str().c_str();
	 cout<<"  Saved " <<bb_name.str() <<endl;
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
  
  
  
  
  return 0;
  
}


