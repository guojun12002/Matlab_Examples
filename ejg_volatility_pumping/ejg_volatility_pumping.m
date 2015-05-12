%EJG_VOLATILITY_PUMPING  Demonstrate volatility pumping with risky assets.
%
%  Volatility pumping, as it was coined by Luenberger, "Investment
%  Science", (1998), is a phenomenon whereby the volatility of assets 
%  can drive long-term expected growth. 
%
%  Based on the paper "Benchmarking and Rebalancing" by Daniel Gabay and
%  Daniel Herlemont, yats.com, 19 Septembre 2007, this script reproduces 
%  example 1, showing the long-term rebalancing excess growth rate g*.
%
%  By default the long-term (asymptotic) growth rate of the risky asset is
%  zero since the volatility balances the drift, and the return of the
%  riskless asset is also zero.
%
%  By adjusting parameters such as the volatilities, drift and relative
%  weights it is possible to see how the rebalanced portfolio path compares
%  to a buy and hold porfolio path.  Since the asset correlations are zero
%  we can use a reduced, simplified, form of the excess growth rate to plot
%  the asymptotic bounded out performance curve.
%
%  This script has been generalised so that the assets can have differing
%  volatilities and drifts however it is assumed, for simplicity, that
%  they are uncorrelated.
%
%
%Edward J. Grace <edward.grace@gmail.com>

%
% $Author: graceej $ $Date: 2010/08/09 11:57:18 $
% $Revision: 1.4 $
%



% Copyright (c) 2010, Edward J. Grace
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or 
% without modification, are permitted provided that the following 
% conditions are met:
%  
%     * Redistributions of source code must retain the above 
%       copyright notice, this list of conditions and the following 
%       disclaimer.
%     * Redistributions in binary form must reproduce the above 
%       copyright notice, this list of conditions and the following 
%       disclaimer in the documentation and/or other materials 
%       provided with the distribution.
%     * Neither the name of the Imperial College London nor the 
%       names of its contributors may be used to endorse or 
%       promote products derived  this software without specific 
%       prior written permission.
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND 
% CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, 
% INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF 
% MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
% DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS 
% BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
% EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED 
% TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
% DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON 
% ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR 
% TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
% THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF 
% SUCH DAMAGE.

%% Helper functions.

% Assuming a time vector t from t=0 to t=T generated with linspace,
% generate a Brownian Motion path starting from zero with volatility sigma. 
gen_bm_path = @(t) cumsum([0 randn(1,length(t)-1).*sqrt(diff(t))]);
 
% Assuming a time vector t from t=0 to t=T generated with linspace,
% generate a geometrical Brownian motion path with drift r and volatility
% sigma.
gen_gbm_path = @(t,r,sigma) exp((r-sigma^2/2).*t + sigma.*gen_bm_path(t));

% Generate the terminal price distribution for geometrical brownian motion.
% This is obviously log-normally distributed.
price_terminal_rnd = @(T,r,sigma,M,N) exp(sigma*randn(M,N)  + (r - sigma^2/2)*T);
 
%% Initial conditions.

% Volatility of risky / riskless asset.
sigma = [0.5 0];
% Continuously compounded growth rate of risky / riskless asset.
r = [0.125 0];
% Fraction of portfolio wealth in risky asset to hold when rebalancing.
f_risky = 0.5;
% Maximum time.
T = 80;
% Number of integration steps.
N = 10000;
% Time vector for Euler integration.
t = linspace(0,T,N);

%% Preliminary steps

% First demonstrate that the mean of the log of the terminal wealth for
% large T is zero -- in other words the long-term growth rate for a risky
% asset is zero.  We expect this since the volatility balances the growth
% rate of the risky asset in the limit of large T.
s_terminal_1 = price_terminal_rnd(T,r(1),sigma(1),1000000,1);
s_terminal_2 = price_terminal_rnd(T,r(2),sigma(2),1000000,1);
figure(1);
clf;
subplot(2,1,1);
hist(log(s_terminal_1),51);
grid on;
xlabel('log(Terminal Wealth) for asset 1');
ylabel('Freq');
subplot(2,1,2);
hist(log(s_terminal_2),51);
grid on;
xlabel('log(Terminal Wealth) for asset 2');
ylabel('Freq');
% Technically this should be tested for statistical significance of course!
fprintf('Continuously compounded growth rate r_eff of asset 1 and 2 %0.2f, %0.2f\n',mean(log(s_terminal_1)),mean(log(s_terminal_2)));

%% Simulate price paths.

% Generate a price path for two assets, one is risky and has no net
% long-term growth the other is riskless.
p(:,1) = gen_gbm_path(t,r(1),sigma(1));
p(:,2) = gen_gbm_path(t,r(2),sigma(2));

% Define weight vector.
w = [f_risky (1-f_risky)];
% Preallocate quantity of holding.
q  = zeros(size(p)).';
% Check that weight vector sums to unity.
assert(sum(w) == 1,'Weight vector must sum to unity');
% Determine initial quantity of holdings.
q(:,1) = w./p(1,:);
% We then simulate the conditional Markov chain iteratively.
for n=2:length(t), 
    % The rebalancing is a normalised projection operation.
    q(:,n) = p(n,:)*q(:,n-1)*w./p(n,:); 
end

% Determine the effective growth rate, the covariance matrix is diagonal in
% this case because we have no asset correlations.  Consequently we can
% simplify the formula of Fernholz (2002).
%
g_star = 0.5*(sum(w*diag(sigma)^2) - w*diag(sigma)^2*w.');


%% Now plot the relative wealth of the two price paths.

% Plot the relative wealth 
figure(2);
clf;
% Wealth path following a rebalancing strategy.
w_re_path = sum(q.*p.'); 
% Wealth path following a buy and hold strategy.
w_bh_path = sum(bsxfun(@times,q(:,1),p.'));
% Plot relative of wealth paths and bounded excess growth rate.  Usually
% this would be plotted on a log scale, however the linear scale shows the
% effect of pulling towards the long-term growth rate more strikingly.
plot(t,w_re_path./w_bh_path,t,exp(g_star*t),'-') 
legend('Example path','exp(g^\ast t)',2)
xlabel('t (au)');
ylabel('w_{re}(t)/w_{bh}(t)');
grid on;
title(sprintf('Example of relative growth path\ng^\\ast = %0.3f%%',g_star*100));

%% CVS Log of changes.
%
% $Log: ejg_volatility_pumping.m,v $
% Revision 1.4  2010/08/09 11:57:18  graceej
% * Added BSD license.
%
%
