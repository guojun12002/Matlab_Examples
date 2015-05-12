function [W]=initializegnn_static(m,n,N_h,overlapfactor)
%[W]=initializegnn_static(m,n,N_h)
%this initializes a static Generalized Neural Network using something like 
%the Nguyen Widrow method [1]
%m=number of inputs (including a 1 for bias)
%n=number of outputs
%N_h=number of hidden neurons
%this is for bipolar activation functions
%
%Reference:
%Nguyen, D. and Widrow, B. "Improving the Learning Speed of 2-Layer
%Neural Networks By Choosing Initial Values for the Adaptive Weights", 
%Proceedings of the International Joint Conference on Neural Networks, San 
%Diego, pp. 21-26, 1990.

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

if nargin<4
	overlapfactor=0.7;%how much neurons overlap
end

W=zeros(n+m+N_h);

for i=1+m:(n+m+N_h)
    %use Nguyen Widrow
    N_inputs=i-2;%inputs to neuron (except 1)
    W_temp=2*rand(1,N_inputs)-1;%random direction (note this is biased away from axes)
    W_mag=overlapfactor*((n+m+N_h)/2)^(1/N_inputs);%magnitude of weight vector
    W_temp=W_mag/(sqrt(sum(W_temp.^2)))*W_temp;%scale direction to magnitude
    W(i,1:m-1)=W_temp(1:m-1);%skip over x=1 at m
    W(i,m+1:N_inputs+1)=W_temp(m:end);
    W(i,m)=(2*rand-1)*W_mag;
end

