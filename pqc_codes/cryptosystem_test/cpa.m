function y = cpa(filename, key)

    img = imread(filename);
    [nx,ny,nz] = size(img);
    black_img = zeros([nx, ny, nz]);
    
    image(black_img);
    black_img_arr = reshape(black_img, [1, nx*ny*nz]);
    black_cipher_img_arr = encryption(black_img_arr, key);
    
    black_cipher_image = reshape(black_cipher_img_arr,[nx,ny,nz]);
    black_cipher_img=uint8(floor((black_cipher_image)*(255/65535)));
    
    image(black_cipher_img);
end