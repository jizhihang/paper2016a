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




//Home

//WANDA
const std::string path = "/home/johanna/codes/datasets_codes/MissUniverse/";


// UQ
//const std::string path = "/home/johanna-uq/codes/datasets_codes/MissUniverse/";


const std::string MissUniverseList = "miss_universe_list.txt";






int
main(int argc, char** argv)
{
  
     
  int view = 1;
    
  opt_feat get_features(path,  MissUniverseList);
  get_features.features_all_videos( view  ) ;
    
   
    
   
  }
 

  