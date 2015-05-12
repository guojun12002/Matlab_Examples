function [Y_hat x]=rgnn_sim(U,W,activation,x,n)
%[Y_hat x]=rgnn_sim(U,W,activation,x,n)
%this calculates feedback gnn with selectable activation function
%U=input (one column is one time step) The last row should be ones
%W=weights
%activation=vector of activation functions:
%	0=sigmoid
%	1=tanh
%	2=linear
%	3=bipolar squash (x/(abs(x)+1))
%n=number of outputs

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

if nargin<5
    n=1;%default to one output
end

if nargin<4
    x=zeros(size(W,1));
end

if nargin<3
    activation=ones(size(W,1),1);%default to tanh
    activation(end)=2;%linear output
end

if n~=1
	error('This function currently only works with single outputs (n=1)')
end

[N_t1 N_t2]=size(W);
if N_t1~=N_t2
    error('W must be square')
end
N_t=N_t1;
[m K]=size(U);%number of inputs, number of time steps
N=N_t1-n;%number of input + hidden neurons
x=zeros(N+n,K);%initialize neuron outputs
Y_hat=zeros(n,K);%initialize network outputs

for k=1:K;%loop through time steps
    if k>1
	x(:,k)=x(:,k-1);
    end
    x(1:m,k)=U(:,k);%copy inputs to net

    for i=m+1:N_t;%loop through neurons
        net=0;
        for j=1:N_t;%calculate wieghted sum
            net=net+W(i,j)*x(j,k);
        end
        if activation(i)==0;%%sigmoid
          x(i,k)=1/(1+exp(-net));
	elseif activation(i)==1;%tanh
	  x(i,k)=tanh(net);
	elseif activation(i)==2;%linear
	  x(i,k)=net;
	elseif activation(i)==3;%bipolar squash
	  x(i,k)=net/(abs(net)+1);
        else
          error('Unknown Activation function')
	end
    end
    Y_hat(:,k)=x(N+1:n+N,k);%output
end


 
