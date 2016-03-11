//Taken from: http://www.magicandlove.com/blog/2011/08/26/people-detection-in-opencv-again/
#include <iostream>
#include <opencv2/opencv.hpp>
 
using namespace std;
using namespace cv;
 
int main (int argc, const char * argv[])
{
    // Path @ UQ
  const std::string path = "/home/johanna-uq/codes/datasets_codes/EveningGownCompetition/";
 
  std::string name =  "MissUniverse2009_Top10.mp4";
  std::stringstream video_path;
  
  
//   std::string country_year;
//   cout << "Folder Name (year_country: ";
//   getline(cin, country_year);

  
  
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
   
   
    Mat img;
    HOGDescriptor hog;
    hog.setSVMDetector(HOGDescriptor::getDefaultPeopleDetector());
 
    namedWindow("video capture", CV_WINDOW_AUTOSIZE);
    
    
  int ini_frame = 1565;

  for(int fr=ini_frame; fr<n_frames; fr++){
    
    capVideo.set(CV_CAP_PROP_POS_FRAMES, fr); //start the video at 300ms
        capVideo >> img;
        if (!img.data)
            continue;
 
        vector<Rect> found, found_filtered;
        hog.detectMultiScale(img, found, 0, Size(8,8), Size(32,32), 1.05, 2);
 
        size_t i, j;
        for (i=0; i<found.size(); i++)
        {
            Rect r = found[i];
            for (j=0; j<found.size(); j++)
                if (j!=i && (r & found[j])==r)
                    break;
            if (j==found.size())
                found_filtered.push_back(r);
        }
        for (i=0; i<found_filtered.size(); i++)
        {
	    Rect r = found_filtered[i];
            r.x += cvRound(r.width*0.1);
	    r.width = cvRound(r.width*0.8);
	    r.y += cvRound(r.height*0.06);
	    r.height = cvRound(r.height*0.9);
	    rectangle(img, r.tl(), r.br(), cv::Scalar(0,255,0), 2);
	}
        imshow("video capture", img);
        if (waitKey(40) >= 0)
            break;
    }
    return 0;
}