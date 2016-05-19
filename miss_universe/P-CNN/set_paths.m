function [path_dataset] = set_paths(pc, svm_type)

%% wanda
if strcmp( pc, 'wanda')
    %VL
    %run('/home/johanna/toolbox/vlfeat-0.9.20/toolbox/vl_setup');
    
       
    %libSVM
    if strcmp( svm_type, 'libsvm')
        addpath('/home/johanna/toolbox/libsvm-3.20/matlab')
    end
    
    
    if strcmp( svm_type, 'linear')
        addpath('/home/johanna/toolbox/liblinear-2.1/matlab');
        
    end
    
    
    %Path for Original dataset
    path_dataset  = '/home/johanna/codes/datasets_codes/MissUniverse/';
    
   

end

%% UQ
if strcmp( pc, 'uq')
    %VL
    run('/home/johanna-uq/Toolbox/vlfeat-0.9.20/toolbox/vl_setup');
    
   
    
    if strcmp( svm_type, 'libsvm')
        %libSVM
        addpath('/home/johanna-uq/Toolbox/libsvm-320/matlab');
    end
    
    
    if strcmp( svm_type, 'linear')
        %libLinear
        addpath('/home/johanna-uq/Toolbox/liblinear-2.1/matlab');
        
    end
    
    
    %Path for Original dataset
    path_dataset  = '/home/johanna-uq/codes/datasets_codes/MissUniverse/';
    
    
end


%% home
if strcmp( pc, 'home')
    %VL
    run('/media/johanna/HD1T/Toolbox/vlfeat-0.9.20/toolbox/vl_setup');
    
  
    if strcmp( svm_type, 'libsvm')
        %libSVM
        addpath('/media/johanna/HD1T/Toolbox/libsvm-3.20/matlab');
    end
    
    
    if strcmp( svm_type, 'linear')
        %libLinear
        addpath('/media/johanna/HD1T/Toolbox/liblinear-2.1/matlab');
        
    end
     
    
    
    %Path for Original dataset
    path_dataset  = '/media/johanna/HD1T/codes/datasets_codes/MissUniverse/';
    
   
end