function y = test_occlusion(filename, key)
img = imread(filename);
[nx,ny,nz] = size(img);

img_arr = reshape(img,[1, nx*ny*nz]);

%%%%%% encrypt image %%%%%%%%%%
cipher_image_arr = encryption(img_arr, key);
cipher_image = reshape(cipher_image_arr,[nx,ny,nz]);
cipher_img=uint8(floor((cipher_image)*(255/65535)));

figure;
image(cipher_img);

%%%%%%%%%%% 10% Occluded %%%%%%%%%%
cipher_image1 = cipher_image(:,:,:);
cipher_image1(1:floor(nx/3.33),1:floor(ny/3.33),:) = 0;
cipher_img1 = uint8(floor((cipher_image1)*(255/65535)));

cipher_image_arr1 = reshape(cipher_image1, [1, nx*ny*nz]);

figure;
image(cipher_img1);

%%%%%% decrypt %%%%%%%%%%
clear_image_arr1 = decryption(cipher_image_arr1, key);
recovered_img1=uint8(reshape(clear_image_arr1,[nx,ny,nz]));

figure;
image(recovered_img1);


% %%%%%%%%%%% 25% Occluded %%%%%%%%%%
% cipher_image2 = cipher_image(:,:,:);
% cipher_image2(1:floor(nx/2),floor(ny/2):ny,:) = 0;
% cipher_img2 = uint8(floor((cipher_image2)*(255/65535)));
% 
% cipher_image_arr2 = reshape(cipher_image2, [1, nx*ny*nz]);
% 
% figure;
% image(cipher_img2);
% 
% %%%%%% decrypt %%%%%%%%%%
% clear_image_arr2 = decryption(cipher_image_arr2, key);
% recovered_img2=uint8(reshape(clear_image_arr2,[nx,ny,nz]));
% 
% figure;
% image(recovered_img2);
% 
% 
% %%%%%%%%%%% 50% Occluded %%%%%%%%%%
% cipher_image3 = cipher_image(:,:,:);
% cipher_image3(floor(nx/2):nx,:,:) = 0;
% cipher_img3 = uint8(floor((cipher_image3)*(255/65535)));
% 
% cipher_image_arr3 = reshape(cipher_image3, [1, nx*ny*nz]);
% 
% figure;
% image(cipher_img3);
% 
% %%%%%% decrypt %%%%%%%%%%
% clear_image_arr3 = decryption(cipher_image_arr3, key);
% recovered_img3=uint8(reshape(clear_image_arr3,[nx,ny,nz]));
% 
% figure;
% image(recovered_img3);


end