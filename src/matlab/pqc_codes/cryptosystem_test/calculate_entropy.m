function y = calculate_entropy(filename, key)
    plain_img = imread(filename);
    [nx,ny,nz] = size(plain_img);
    
    figure;
    image(plain_img);

    plain_img_arr = reshape(plain_img,[1, nx*ny*nz]);

    %%%%%% encrypt image %%%%%%%%%%
    cipher_image_arr = encryption(plain_img_arr, key);
    cipher_image = reshape(cipher_image_arr,[nx,ny,nz]);
    cipher_img=uint8(floor((cipher_image)*(255/65535)));

    figure;
    image(cipher_img);

    %%%%%%% calculate entropy %%%%%%%%%
    PR = plain_img(:,:,1);
    PG = plain_img(:,:,2);
    PB = plain_img(:,:,3);
    
    CR = cipher_img(:,:,1);
    CG = cipher_img(:,:,2);
    CB = cipher_img(:,:,3);
    
    ePR = entropy(PR)
    ePG = entropy(PG)
    ePB = entropy(PB)
    
    eCR = entropy(CR)
    eCG = entropy(CG)
    eCB = entropy(CB)
    
end