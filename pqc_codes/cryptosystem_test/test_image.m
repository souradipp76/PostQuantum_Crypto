function test_image(filename, key)
img = imread(filename);
[nx,ny,nz] = size(img);

img_arr = reshape(img,[1, nx*ny*nz]);

%%%%%% encrypt image %%%%%%%%%%
cipher_image_arr = encryption(img_arr, key);
cipher_image = floor((cipher_image_arr)*(255/65535));
cipher_img=uint8(reshape(cipher_image,[nx,ny,nz]));


%%%%%% decrypt %%%%%%%%%%
clear_image_arr = decryption(cipher_image_arr,key);
recovered_img=uint8(reshape(clear_image_arr,[nx,ny,nz]));



%%%%%%% Analysis %%%%%%%%%
figure;
image(img);

figure;
image(cipher_img);

figure;
image(recovered_img);


end