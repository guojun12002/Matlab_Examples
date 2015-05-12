function [p,q,r] = padelog(c,z0)
%   PADELOG(c,z0) finds an expansion of the form
%   
%      p(z) +  r{1}(z) log(1-z/z0(1)) + ... + r{m}(z) log(1-z/z0(m))
%     ----------------------------------------------------------
%                              q(z)
%                              
%                       N+1  
%          =  f(z) + O(z   ),  z->0
%
%   for polynomials p, q, r{1},..., r{m}. Here f(z) is a  polynomial
%   of degree N, whose coefficients are given in ascending degree in
%   c. The points in vector z0 represent the locations of jumps in f.

N = length(c)-1;
m = length(z0);

% Figure out the degrees of the polynomials. 
nq = ceil((N-m)/(m+1.5));
s = floor((N-m-nq)/(m+1));
nr = s*ones(1,m);
np = N-m-nq-sum(nr);

% Taylor coeffs of log terms
k = (1:N)';
for s = 1:m
  l{s} = [0;-1./(k.*z0(s).^k)];
end

% The polynomials q and r{:} are found from the highest-order coeffs
row = [c(np+2:-1:max(1,np-nq+2)); zeros(nq-np-1,1)];
C = toeplitz(c(np+2:N+1),row);
L = cell(1,m);
for s = 1:m
  row = [l{s}(np+2:-1:max(1,np-nr(s)+2));zeros(nr(s)-np-1,1)];
  L{s} = toeplitz(l{s}(np+2:N+1),row);
end

% Find a vector v satisfying [C -L{1} ... -L{m}]*v = 0
Z = null(cat(2,-C,L{:}));   % vector(s) in nullspace
qr = Z(:,end);
qr = qr/qr(min(find(qr)));  % normalization

% Pull out polynomials
q = qr(1:nq+1);
idx = nq+1;
r = cell(1,m);
for s = 1:m
  r{s} = qr(idx+(1:nr(s)+1));
  idx = idx + nr(s)+1;
end

% Remaining polynomial is found using low-order terms
C = toeplitz(c(1:np+1),[c(1) zeros(1,nq)]);
p = C*q;
for s = 1:m
  L = toeplitz(l{s}(1:np+1),[l{s}(1) zeros(1,nr(s))]);
  p = p - L*r{s};
end
