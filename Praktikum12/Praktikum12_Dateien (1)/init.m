function [ ] = init( )

% Load and convert original image to grayscale.
clear A I
A = imread('original','jpg');
I = rgb2gray(A);
figure
imshow(I)

% Save converted image.
imwrite(I,'grayscale.jpg');

disp('Info: Image is successfully converted.')
end