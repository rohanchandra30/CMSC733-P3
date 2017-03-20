function [y1,y2,idx] = GetInliersRANSAC(x1,x2)
%% Input:
% x1 and x2: Nx2 matrices whose row represents a correspondence.
%% Output:
% y1 and y2: Nix2 matrices whose row represents an inlier correspondence 
%            where Ni is the number of inliers.
% idx: Nx1 vector that indicates ID of inlier y1.


%% Your Code goes here

n=0;  
msize = size(x1,1);
pts1 = zeros(8,2);
pts2 = zeros(8,2);

for i=1:1000 
  idx = randperm(msize);
% Choose 8 correspondences, x?1 and x?2 randomly 
  for subset = 1:8
      pts1(subset,:) = x1(idx(subset),:);
      pts2(subset,:) = x2(idx(subset),:);
  end    
  
  F = EstimateFundmentalMatrix(pts1, pts2);
  
  S = [];
  for j=1:msize
    if constraint(x2(j,:), F, x1(j,:)) < eps 
        S = [S; j];
    end
  end
  
  if n < size(S,1) 
    n = size(S,1);
    idx = S 
  end
end
y1 = x1(idx);
y2 = x2(idx);
end

function f = constraint(x2, F, x1)
   X2 = [ x2 1];
   X1 = [ x2 1];
   f = abs(X2'*F*X1);
end