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

#include "optflow-feat-def.hpp"
#include "optflow-feat-impl.hpp"

#include "saving_Cov_def.hpp"
#include "saving_Cov_impl.hpp"




//Home
const std::string path = "/media/johanna/HD1T/codes/datasets_codes/MissUniverse/";


//WANDA
//const std::string path = "/home/johanna/codes/datasets_codes/MissUniverse/";


// UQ
//const std::string path = "/home/johanna-uq/codes/datasets_codes/MissUniverse/";


const std::string MissUniverseList = "miss_universe_list.txt";






int
main(int argc, char** argv)
{
  
     
  int view = 1;
    
  opt_feat get_features(path,  MissUniverseList);
  //get_features.features_all_videos( view  ) ;
  //get_features.see_all_videos( view  ) ;
  
  
  
  //OverlappedCovs get_CovsperVideo(path, MissUniverseList);
  //get_CovsperVideo.calculate_covariances( view);
    
   
    
   
  }
 

  