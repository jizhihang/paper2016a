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
const std::string path = "/home/johanna/codes/codes-git/manifolds/trunk/kth/dim_14/features/kth-features_dim14_openMP/sc1/" ;

const std::string peopleList = "people_list.txt";
const std::string  actionNames = "actionNames.txt";



int
main(int argc, char** argv)
{
  
  field<string> all_people;
  all_people.load(peopleList);
  
  
  float scale_factor = 1;
  int shift = 0;
  

    
    
    CovMeans_mat_kth get_CovsperVideo(path, actionNames, scale_factor, shift);
    get_CovsperVideo.calculate_covariances( all_people, dim );
  
  
  return 0;
  
}







