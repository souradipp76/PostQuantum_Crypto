function [NPCR, UACI] = calculate_NPCR_UACI(filename, key)
    img = imread(filename);
    [nx,ny,nz] = size(img);
    
    figure;
    image(img);

    img_arr = reshape(img,[1, nx*ny*nz]);

    %%%%%% encrypt image %%%%%%%%%%
    cipher_image_arr = encryption(img_arr, key);
    cipher_image = reshape(cipher_image_arr,[nx,ny,nz]);
    cipher_img=uint8(floor((cipher_image)*(255/65535)));

    figure;
    image(cipher_img);

    img1 = img(:,:,:);
    r = randi([1 nx],1);
    c = randi([1 ny],1);
    
    img1(r, c, 1) = img1(r, c, 1) + 1;
    
    r = randi([1 nx],1);
    c = randi([1 ny],1);
    img1(r, c, 2) = img1(r, c, 2) + 1;
    
    r = randi([1 nx],1);
    c = randi([1 ny],1);
    img1(r, c, 3) = img1(r, c, 3) + 1;
    
    img_arr1 = reshape(img1,[1, nx*ny*nz]);
    %%%%%% encrypt image %%%%%%%%%%
    cipher_image_arr1 = encryption(img_arr1, key);
    cipher_image1 = reshape(cipher_image_arr1,[nx,ny,nz]);
    cipher_img1=uint8(floor((cipher_image1)*(255/65535)));
    
    figure;
    image(cipher_img1);
    
%     res = NPCR_and_UACI(cipher_img1, cipher_img, 1, 255)
%     NPCR = res.npcr_score;
%     UACI = res.uaci_score;
%     
    bdiff = double(cipher_img1~= cipher_img);
    NPCR = sum(bdiff(:));
    NPCR = NPCR*100/(nx*ny*nz);
    
    bdiffR = bdiff(:,:,1);
    NPCR_R = sum(bdiffR(:));
    NPCR_R = NPCR_R*100/(nx*ny)
    
    bdiffG = bdiff(:,:,2);
    NPCR_G = sum(bdiffG(:));
    NPCR_G = NPCR_G*100/(nx*ny)
    
    bdiffB = bdiff(:,:,3);
    NPCR_B = sum(bdiffB(:));
    NPCR_B = NPCR_B*100/(nx*ny)
    
    idiff = abs(double(cipher_img1) - double(cipher_img));
    UACI = sum(idiff(:));
    UACI = UACI*100/(255*nx*ny*nz);
    
    
    idiffR = idiff(:,:,1);
    UACI_R = sum(idiffR(:));
    UACI_R = UACI_R*100/(255*nx*ny)
    
    idiffG = idiff(:,:,2);
    UACI_G = sum(idiffG(:));
    UACI_G = UACI_G*100/(255*nx*ny)
    
    idiffB = idiff(:,:,3);
    UACI_B = sum(idiffB(:));
    UACI_B = UACI_B*100/(255*nx*ny)
end