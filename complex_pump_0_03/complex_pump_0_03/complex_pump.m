%this uses the complex method to optimize a recurrent neural network to
%model a load sensing hydraulic pump.

%
%Copyright (c) 2009, Travis Wiens
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without 
%modification, are permitted provided that the following conditions are 
%met:
%
%    * Redistributions of source code must retain the above copyright 
%      notice, this list of conditions and the following disclaimer.
%    * Redistributions in binary form must reproduce the above copyright 
%      notice, this list of conditions and the following disclaimer in 
%      the documentation and/or other materials provided with the distribution
%      
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
%AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
%IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
%ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
%LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
%CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
%SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
%INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
%CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
%ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
%POSSIBILITY OF SUCH DAMAGE.
%
% If you would like to request that this software be licensed under a less
% restrictive license (i.e. for commercial closed-source use) please
% contact Travis at travis.mlfx@nutaksas.com

save_data=false;%set this to true to save the results 

N_p=12000;%12000 number of data points to use for training (at each iteration)
gen_max=1e5;%1e5 number of generations (i.e. number of evaluations of fitness function)

F_redundant=0.5;%Factor to include redundant individuals (must be >= 0). 
%This helps set the population size. With F_redundant=0, the population will 
%be N_params+1, which is the minimum required for the complex method to
%work
N_neurons=30;%30 total number of neurons, including input and output

bounds_forward=5;% min/max bounds for forward network weights
bounds_feedback=1;% min/max bounds for feedback weights


init_feedback=1;%value to scale feedback weights by, during initialization
NG_init=true;%set to true use Nguyen Widrow initialization for forward 
%weights (set to false to use random values).
overlap=0.7*1;%overlap factor for Nguyen Widrow method

activation_hidden=1;%activation function for hidden neurons
activation_output=2;%output activation function
%activation functions:
%0=sigmoid
%1=tanh
%2=linear
%3=bipolar squash (x/(abs(x)+1))

use_mex=false;%set this to 1 if you want to use the precompiled mex functions (much faster)
%if you want to use this, type "mex rgnn_sim_mex.c" (no quotes) at the Matlab prompt and change
%"use_mex=false" in fit_pump.m to "use_mex=true". You must have a mex compiler set up to do this.

if use_mex
    dt=0.13;%(s) time per iteration (this is for a Core2Duo at 2.13 GHz, N_neurons=30 and N_p=12000)
    fprintf('Approx running time will be %0.2f s = %0.2f min = %0.2f h\n',dt*gen_max,dt*gen_max/60,dt*gen_max/3600)
else
    dt=0.49;%(s) time per iteration (this is for a Core2Duo at 2.13 GHz, N_neurons=30 and N_p=12000)
    fprintf('Approx running time will be %0.2f s = %0.2f min = %0.2f h\nYou may want to use a mex file to improve speed.\nSee code for details.\n',dt*gen_max,dt*gen_max/60,dt*gen_max/3600)
end


%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%
%end parameters
%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%


tic;%start clock

load('Pump_data.mat')
%this file includes:
%Pc_psi: control pressue (psi)
%Ps_psi: source pressure (psi)
%Q_gpm: flow rate (gpm)
%Q_SNN: Li's estimated flow rate. From:
%  L Li, D Bitner, R Burton, G Schoenau, "Experimental study on the use of a 
%  dynamic neural network for modelling a variable load sensing pump,"
%  Bath Symposium on Power Transmission and Motion Control, Sept 2007.



%scale data to -1 to 1
Pc_m=2/(max(Pc_psi)-min(Pc_psi));%scale
Pc_b=-(max(Pc_psi)+min(Pc_psi))/(max(Pc_psi)-min(Pc_psi));%offset
Ps_m=2/(max(Ps_psi)-min(Ps_psi));%scale
Ps_b=-(max(Ps_psi)+min(Ps_psi))/(max(Ps_psi)-min(Ps_psi));%offset
Q_m=2/(max(Q_gpm)-min(Q_gpm));%scale
Q_b=-(max(Q_gpm)+min(Q_gpm))/(max(Q_gpm)-min(Q_gpm));%offset

U=[Pc_psi(1:N_p)*Pc_m+Pc_b Ps_psi(1:N_p)*Ps_m+Ps_b  ones(N_p,1)]';
%input, rescale data to -1 to 1, add ones for bias
Y=Q_gpm(1:N_p)'*Q_m+Q_b;%output, scaled to -1 to 1

fcn_opts=[];
fcn_opts.U=U;%copy to structure to pass to function
fcn_opts.Y=Y;


Q_t=(Y-Q_b)/Q_m;%(gpm) training flow

Q_SNNt=Q_SNN(1:N_p);%(gpm) Li's estimate of training flow
k_skip=100;%ignore first data points
E_SNNgpmt=sqrt(mean((Q_t(k_skip:end)-Q_SNNt(k_skip:end)).^2));%(gpm) RMS error in Li's estimate

Y_SNNt=Q_SNNt*Q_m+Q_b;%rescale Li's estimate
E_SNNt=sqrt(mean((Y(k_skip:end)-Y_SNNt(k_skip:end)).^2));% scaled RMS error in Li's estimate

N_in=size(U,1);%number of inputs
N_out=size(Y,1);%number of outputs

N_params=N_neurons*(N_neurons-N_in);%number of optimization parameters
population=N_params+1+round(F_redundant*N_params);%number of individuals. N_params+1 is minimum

W_bounds=zeros(N_neurons);%matrix of bounds on weights
for j=(N_in+1):N_neurons
	W_bounds(j,1:(j-1))=bounds_forward;% forward weights
	W_bounds(j,j:end)=bounds_feedback;% feedback weights
end
bounds=W_to_param(W_bounds,N_in);%this function converts the square W matrix to a row vector
bounds=[-bounds; bounds];%bounds on the paramters
	
fcn_opts.activation=activation_hidden*ones(N_neurons,1);%activation functions 
fcn_opts.activation(end)=activation_output;%
activation=fcn_opts.activation;

%initialize population
if NG_init==1 %us Nguyen Widrom intialization for feedforward weights
	x_start=zeros(population,N_params);
	for i=1:population
		W=initializegnn_static(N_in,1,N_neurons-N_in-N_out,overlap);%Nguyen Widrow method
		for j=(N_in+1):N_neurons
			W(j,j:end)=init_feedback*randn(size(W(j,j:end)));%random feedback terms
		end
		x_start(i,:)=W_to_param(W,N_in);%copy weights to population
	end
else%do it randomly
	x_start=zeros(population,N_params);
	for i=1:population
		W=3*randn(N_neurons);%forward terms
		for j=(N_in+1):N_neurons
			W(j,j:end)=init_feedback*randn(size(W(j,j:end)));%feedback terms
		end
		x_start(i,:)=W_to_param(W,N_in);%copy weights to population
	end
end
fit_start=[];%leace initial fitness blank (complex_method.m will do it)
	
disp('initialized');

%%%%%%%%%%%%%%%%%%%%
 %Do Complex Method!%
  %%%%%%%%%%%%%%%%%%%%


fcn_name='fit_rgnn';%fit_rgnn is the fitness function

complex_opts=[];%use default optimization parameters

%do it!
[x_best, fit_best, x_pop, fit_pop stats]=complexmethod(fcn_name,bounds,gen_max,x_start,fit_start,fcn_opts,complex_opts);

timtoc=toc;%stop timer

fprintf('Total time=%f s. Time per generation=%f s\n',timtoc,timtoc/gen_max);

W=params_to_W(x_best,N_in);%convert row of best parameters to square matrix

[Y_hat x]=rgnn_sim(U,W,activation);%simulate network using training data and best weights
%Y_hat is the scaled estimated flow rate

E_t=sqrt(mean((Y(k_skip:end)-Y_hat(k_skip:end)).^2));%RMS error (scaled)

Q_hatt=(Y_hat-Q_b)/Q_m;%(gpm) estimated flow
E_tgpm=sqrt(mean((Q_t(k_skip:end)-Q_hatt(k_skip:end)).^2));%(gpm) RMS error

fprintf('RMS E_train = %f = %f gpm\n',E_t,E_tgpm);

figure(1)
h1=plot([Y;Y_hat]','.','markersize',1);
xlabel('time (samples)')
ylabel('Scaled Flow')
legend(h1,'Target','Estimate')


figure(2)
semilogy(-stats.trace_fitness,'.')
xlabel('Generation')
ylabel('RMS Error')

N_pv=[12000 17000];%data points to use for verification
x0=zeros(size(W,1),1);%initial neuron states

U_v=[Pc_psi(N_pv(1):N_pv(2))*Pc_m+Pc_b Ps_psi(N_pv(1):N_pv(2))*Ps_m+Ps_b ones(N_pv(2)-N_pv(1)+1,1)]'; 
%verification inputs

if use_mex
	[Y_hatv]=rgnn_sim_mex(U_v,W,activation,x0);%simulate network
else
	[Y_hatv]=rgnn_sim(U_v,W,activation,x0);%simulate network
end

Y_v=Q_gpm(N_pv(1):N_pv(2))'*Q_m+Q_b;%target verification output
Q_v=(Y_v-Q_b)/Q_m;%(gpm) target verfication flow
Q_hatv=(Y_hatv-Q_b)/Q_m;%(gpm) estimated flow

E_v=sqrt(mean((Y_v(k_skip:end)-Y_hatv(k_skip:end)).^2));%verification error

E_vgpm=sqrt(mean((Q_v(k_skip:end)-Q_hatv(k_skip:end)).^2));%(gpm) verification error

fprintf('RMS E_verification = %f = %f gpm\n',E_v,E_vgpm);



figure(6)
plot([Y_v;Y_hatv]','.','markersize',1)
xlabel('time (samples)')
ylabel('Scaled Flow')


Q_SNNv=Q_SNN(N_pv(1):N_pv(2));%(gpm)verification flow from Li's work
E_SNNgpmv=sqrt(mean((Q_v(k_skip:end)-Q_SNNv(k_skip:end)).^2));%RMSE

fprintf('For comparison to Li model: RMS E_SNNt=%f gpm E_SNNv=%f gpm\n',E_SNNgpmt,E_SNNgpmv);



%now lets look at the square wave response
N_p3=600;%number of points for square wave

U3=[0.5+0.3*sign(sin(0.005*pi*2*(1:N_p3)));0.4+0.25*sign(sin(0.001*pi*2*(1:N_p3)));ones(1,N_p3)];%square wave input

if use_mex
	[Y_hat3]=rgnn_sim_mex(U3,W,activation,x0);
else
	[Y_hat3]=rgnn_sim(U3,W,activation,x0);
end

figure(7)
plot(Y_hat3','.')

if save_data==1
  fname=['complex_data' datestr(now,30) '.mat'];
  save(fname,'W','activation','Pc_m','Pc_b','Ps_m','Ps_b','Q_m','Q_b','Y','Y_hat','U','U_v','Q_v','Q_hatv','Q_t','Q_hatt','besttrace','Y_v','Y_hatv','Y_hat3','SNN','Q_SNNv','Q_SNNt','E_t','E_tgpm','E_v','E_vgpm','E_SNNgpmt','E_SNNgpmv','timtoc')
end

