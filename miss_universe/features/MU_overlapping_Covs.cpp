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

#include "saving_Cov_def.hpp"
#include "saving_Cov_impl.hpp"



//This path is only to load the matrices that contain all the feature vectors
//per video and their labels. 

//WANDA
//const std::string path = "/home/johanna/codes/datasets_codes/MissUniverse/features";


// UQ
const std::string path_dataset  = "/home/johanna-uq/codes/datasets_codes/MissUniverse/";
const std::string path_features = "/home/johanna-uq/codes/codes-git/paper2016a/trunk/miss_universe/features/features";


const std::string MissUniverseList = "miss_universe_list.txt";




int
main(int argc, char** argv)
{
  
  int view = 1;

    
    
    OverlappedCovs get_CovsperVideo(path, MissUniverseList);
    get_CovsperVideo.calculate_covariances( view);
  
  
  return 0;
  
}







