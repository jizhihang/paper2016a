#include <omp.h>
#include <stdio.h>
#include <opencv2/opencv.hpp>
#include <fstream>
#include <iostream>
#include <armadillo>
#include <iomanip>
#include <vector>
#include <hdf5.h>
#include "omp.h"

using namespace std;
using namespace arma;



//WANDA
const std::string path  = "/home/johanna/codes/codes-git/paper2016a/trunk/kth/";



const std::string peopleList = "people_list.txt";
const std::string  actionNames = "actionNames.txt";

///kth
// int ori_col = 160;
// int ori_row = 120;





int
main(int argc, char** argv)
{
  

  int dim = 4237; 
  int N_cent = 256; // as per Improved Trajectories Features
  
  field<string> all_people;
  all_people.load(peopleList);
  
  field<std::string> actions;
  actions.load( actionNames );  
  
  int n_actions = actions.n_rows;
  int n_total_peo =  all_people.n_rows;
  
  vec people_train;
  people_train 	<<  1  <<  4  <<  11 <<  12 <<  13 << 14 << 15 <<  16 
		<<  17 <<  18 <<  19 <<  20 <<  21 << 23 << 24 <<  25 << endr;

 int n_peo_tr = people_train.n_elem;
  
  mat uni_features;
  
  int idx;
  
  
  
  
  // Folder where I have saved the # of covariances per person_action
  std::stringstream load_folder_covs;
  load_folder_covs << path << "overlapped_covariances/Covs/sc1/scale1-shift0";
  vec vecNumCovs;
  
  for (int pe = 0; pe< n_peo_tr; ++pe)
  {
    idx = people_train(pe);

    for (int act=0; act<n_actions; ++act)
    {

      
    std::stringstream load_vecNumCovs;
    load_vecNumCovs << load_folder_covs.str() << "/NumCov_" <<  all_people(idx) << "_" << actions(act) <<  ".dat";
    vecNumCovs.load( load_vecNumCovs.str(), raw_ascii ) ; 
    
    int num_points = conv_to< int >::from(vecNumCovs);
    
    mat vectors_video_i;
    vectors_video_i.zeros(num_points);

    for (int c =0; c < num_points; ++c )
    {
      std::stringstream load_projected_point_i;
      load_projected_point_i << path <<  "KPCA-RP/projected_points_dim/pp_" << all_people(idx) << "_" << actions(act) << "_segm" << c << '.h5'; 
      
      //pac : people, action, projected_point (cov_c)
      vec vector_pac;
      vector_pac.load( load_projected_point_i.str(), hdf5_binary );
      vectors_video_i.col(i) = vector_pac;
  }
  
  uni_features	 = join_rows( uni_features, vectors_video_i );

  
  
  cout << "Final r&c "<<  uni_features.n_rows << " & " << uni_features.n_cols << endl;
  
  // **************************universal GMM*******************************
  
   bool is_finite = uni_features.is_finite();
 
    if (!is_finite )
    {
      cout << "is_finite?? " << is_finite << endl;
      cout << uni_features.n_rows << " " << uni_features.n_cols << endl;
      getchar();
    
    }
  
  
  cout << "universal GMM" << endl;
  gmm_diag gmm_model;
  gmm_diag bg_model;
  
  
  
  bool status_em = false;
  int rep_em=0;
  
  
  int km_iter = 10;
  int em_iter  = 5;
  double var_floor = 1e-10;
  bool print_mode = true;
  
  
  
  
  while (!status_em)
  {
    bool status_kmeans = false;
    //int rep_km = 0;
    
    while (!status_kmeans)
    {
      arma_rng::set_seed_random();
      
      status_kmeans = gmm_model.learn(uni_features, N_cent, eucl_dist, random_subset, km_iter, 0, var_floor, print_mode);   //Only Kmeans
      bg_model = gmm_model;
      //rep_km++;
    }
    
    
    status_em = gmm_model.learn(uni_features, N_cent, eucl_dist, keep_existing, 0, em_iter, var_floor, print_mode);   
    rep_em++;
    
    if (rep_em==9)
    {
      status_em = true;
      gmm_model = bg_model;
      
    }
    
  }
  
  
  cout <<"EM was repeated " << rep_em << endl;
  
  std::stringstream tmp_ss5;
  tmp_ss5 << "./universal_GMM/UniversalGMM_Ng" << N_cent << "_dim" <<dim << "_sc1"; 
  cout << "Saving GMM in " << tmp_ss5.str() << endl;
  gmm_model.save( tmp_ss5.str() );
  cout << endl;
  
  mat means;
  mat covs;
  vec weights;	
  
  means = gmm_model.means;
  covs  = gmm_model.dcovs;
  weights = gmm_model.hefts.t();	
  
  //Saving statistics
  std::stringstream ss_weigths;
  ss_weigths << "./universal_GMM/weights_Ng" << N_cent << "_dim" << dim << "_sc1" << ".dat"; 
  
  std::stringstream ss_means;
  ss_means << "./universal_GMM/means_Ng" << N_cent << "_dim" <<dim << "_sc1" << ".dat"; 
  
  std::stringstream ss_covs;
  ss_covs << "./universal_GMM/covs_Ng" << N_cent << "_dim" <<dim << "_sc1" << ".dat"; 
  
  weights.save( ss_weigths.str(), raw_ascii );
  means.save( ss_means.str(), raw_ascii );
  covs.save(ss_covs.str(), raw_ascii);
  
  
  
  return 0;
  
}
