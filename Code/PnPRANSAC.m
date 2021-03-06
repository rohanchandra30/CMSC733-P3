function [C,R,idx] = PnPRANSAC(X, x, K)
%% Inputs
% K : camera calibration matrix
% X : 3D coordinates
% x : image pixel coordinates
%% Outputs
% C : camera center
% R : Rotation matrix
% idx : inlier index

%% Your code goes here

n=0;  

ptsX = zeros(6,3);
ptsx = zeros(6,2);
C = [];
  for i=1:1000 
   msize = size(x,1);  
   indx = randperm(msize);
% Choose 6 correspondences, X? and x?, randomly
   for subset = 1:6
      ptsX(subset,:) = X(indx(subset),:);
      ptsx(subset,:) = x(indx(subset),:);
   end    
  
   [c, r] = LinearPnP(ptsX, ptsx, K);
    
   S = [];
   for j=1:msize
     T = (r'*c).* -1;  
     P = K*[r T];  
     if compute_error(P, x(j,:), X(j,:)) < eps
        S = [S; j];
     end
    end
  
    if n < size(S,1) 
     n = size(S,1);
     idx = S; 
     C = c;
     R = r;
    end
    
  end

end

function error = compute_error(P, x, X)
   X = [X ones(size(X,1))];
   x_new = P*X';
   x_new = x_new./x_new(3,:);
   u = x_new(1,:);
   v = x_new(2,:);
   error = sqrt((x(:,1)' - u).^2 + (x(:,2)' - v)); 
end

