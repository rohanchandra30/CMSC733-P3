%% Good Luck, Have fun!
clc
clear all
close all

Nimages = 6;
I1 = im2double(imread('../Data/1.jpg'));
I2 = im2double(imread('../Data/2.jpg'));
K = [568.996140852 0 643.21055941; 0 568.988362396 477.982801038; 0 0 1];

%% Part 4 Calculating point correspondences and Fundamental Matrix

points = get_point_cell(Nimages);
[Points,F] = get_pointsandF_after_RANSAC(points);

x1 = Points{1,2}(:,1:2);
x2 = Points{1,2}(:,3:4);
dispMatchedFeatures(I1,I2,x1,x2, 'montage');

%% % Part 5 Calculating Esssential Matrix and the 4 poses of the second Camera

E = EssentialMatrixFromFundamentalMatrix(F{1,2},K);
[Cset,Rset] = ExtractCameraPose(E);


%% % Part 6 Triangulating the 3D points and optimizing them

for i = 1:4
    Xset{i} = LinearTriangulation(K, zeros(3,1), eye(3), Cset{i}, Rset{i}, x1, x2) ;
end

[C, R, X] = DisambiguateCameraPose(Cset, Rset, Xset);

X_opt = NonlinearTriangulation(K, zeros(3,1), eye(3), C, R, x1, x2, X);