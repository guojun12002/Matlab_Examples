function [fitness, x] = fit_rgnn(x,fcn_opts)
%[fitness, x] = fit_rgnn(x,fcn_opts)
%this calculates the fitness for a system identification problem, a
%recurrent generalized neural network.  The fitness is the negative RMS
%error, or, in the case of nan, the number of finite values before nan.
%fcn_opts.U is the input matrix (N_in x N_points)
%fcn_opts.Y is the target output vector (1 x N_points)
%fcn_opts.activation is the activation vector (N_neurons x 1)

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

use_mex=false;%set to true to use precompiled mex functions

N_in=size(fcn_opts.U,1);%number of inputs

W=params_to_W(x,N_in);%convert row vector of params to square W matrix

x0=zeros(size(W,1),1);%initial states

if use_mex
	[Y_hat]=rgnn_sim_mex(fcn_opts.U,W,fcn_opts.activation,x0);%perform NN calculation
else
	[Y_hat]=rgnn_sim(fcn_opts.U,W,fcn_opts.activation,x0);
end

k_skip=100;%skip first few data points

E=sqrt(mean((fcn_opts.Y(k_skip:end)-Y_hat(k_skip:end)).^2));%RMS error

fitness=-E;%maximize the negative error

if isnan(fitness)
	%if the error is "not a number" then the fitness is the number of finite values
	fitness=-(numel(Y_hat)-max(find(~isnan(Y_hat))));
end

