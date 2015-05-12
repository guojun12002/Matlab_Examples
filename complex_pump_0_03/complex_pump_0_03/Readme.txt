This package includes files for modelling nonlinear dynamic systems using a recurrent generalized neural network.  The learning scheme uses the complex method of nonlinear nonderivative optimization, thereby avoiding the problems of computing the derivative of an infinite impulse response filter such as a recurrent neural network.  

The example given is the modelling of a load-sensing hydraulic pump.  The model output is the pump flow, as a response to inputs of pump pressure and the pressure in the control piston. Real experimental data is included. 

For further details, refer to:
T. Wiens, R. Burton, G. Schoenau, D. Bitner, "Recursive Generalized Neural Networks (RGNN) for the Modeling of a Load Sensing Pump," Bath Symposium on Power Transmission and Motion Control, Sept 2008.
http://homepage.usask.ca/~tkw954/
http://www.nutaksas.com

Note that this package requires the "Complex Method of Optimization" package in your path, available from http://www.mathworks.com/matlabcentral/fileexchange/loadAuthor.do?objectType=author&objectId=1103920

This package is released under a BSD license (see files for details).  If you would like to request a commerical (or other) license, please feel free to contact travis.mlfx@nutaksas.com.

Files:
-complex_pump.m: This is the pump modelling top-level script.  There are a number of parameters you can safely adjust, including the number of neurons and number of generations. You can run it as is, but be warned, it takes about 14 hours to run on my computer (Core2Duo at 2.13 GHz).  You can speed it up by reducing the number of neurons or generations (reduced accuracy) or by compiling the rgnn_sim_mex.c mex file and changing use_mex=false to true in line 33 and line 28 of fit_rgnn.m
-fit_rgnn.m: This function calculates the fitness of a set of weights, by calculating the RMS error between the target output and the calculated neural network output.
-rgnn_sim.m: This function performs the rgnn calcuations
-fit_rgnn_mex.c: This mex file performs the same calculation as rgnn_sim.m, but does it much faster.  Must be compiled with "mex".
-initializegnn_static.m: This function is used to initialize a static generalized neural network, using something like the Nguyen Widrow method.  It can be used to initialize the forward weights of a recurrent neural network.
-params_to_W.m: Rearranges the row vector of parameters into a square W matrix.
-W_to_param.m: Rearranges the square W matrix into a row vector.
-Pump_data.mat: Data file includes experimental data, as well Li's previous SNN model estimate, from L. Li, D. Bitner, R. Burton, G. Schoenau, "Experimental study on the use of a dynamic neural network for modelling a variable load sensing pump," Bath Symposium on Power Transmission and Motion Control, Sept 2007.
-Readme.txt: this file