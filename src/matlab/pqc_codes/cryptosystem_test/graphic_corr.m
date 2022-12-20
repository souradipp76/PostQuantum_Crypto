function y = graphic_corr(filename, key)
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
    
    %%%%%%%%%% calculate horizontal correlation %%%%%%%%%%
    PR = reshape(img(:,:,1), [1, nx*ny]);
    PG = reshape(img(:,:,2), [1, nx*ny]);
    PB = reshape(img(:,:,3), [1, nx*ny]);
    ind = randsample(1:(nx-1)*(ny), 5000);
    
    %[r, c] = ind2sub([nx, ny],ind(1));
    
    indr = mod(ind, nx);
    indc = floor(ind./nx);
    indr = indr+1;
    ind1 = indr+indc*nx;
    
    %[r, c] = ind2sub([nx, ny],ind1(1));
    
    figure;
    PR1 = PR(ind);
    PR2 = PR(ind1);
    scatter(PR1, PR2, 10, 'r','filled');
    xlabel('Pixel Value at (x,y)');ylabel('Pixel Value at (x+1,y)');
    xlim([0 255]); ylim([0 255]);
    
    figure;
    PG1 = PG(ind);
    PG2 = PG(ind1);
    scatter(PG1, PG2, 10, 'g','filled');
    xlabel('Pixel Value at (x,y)');ylabel('Pixel Value at (x+1,y)');
    xlim([0 255]); ylim([0 255]);
    
    figure;
    PB1 = PB(ind);
    PB2 = PB(ind1);
    scatter(PB1, PB2,  10, 'b','filled');
    xlabel('Pixel Value at (x,y)');ylabel('Pixel Value at (x+1,y)');
    xlim([0 255]); ylim([0 255]);
   
    
    CR = reshape(cipher_img(:,:,1), [1, nx*ny]);
    CG = reshape(cipher_img(:,:,2), [1, nx*ny]);
    CB = reshape(cipher_img(:,:,3), [1, nx*ny]);
    
    figure;
    CR1 = CR(ind);
    CR2 = CR(ind1);
    scatter(CR1, CR2, 10, 'r','filled');
    xlabel('Pixel Value at (x,y)');ylabel('Pixel Value at (x+1,y)');
    xlim([0 255]); ylim([0 255]);
    
    figure;
    CG1 = CG(ind);
    CG2 = CG(ind1);
    scatter(CG1, CG2, 10, 'g','filled');
    xlabel('Pixel Value at (x,y)');ylabel('Pixel Value at (x+1,y)');
    xlim([0 255]); ylim([0 255]);
    
    figure;
    CB1 = CB(ind);
    CB2 = CB(ind1);
    scatter(CB1, CB2,  10, 'b','filled');
    xlabel('Pixel Value at (x,y)');ylabel('Pixel Value at (x+1,y)');
    xlim([0 255]); ylim([0 255]);
    
    rPR = corrcoef(double(PR1), double(PR2))
    rPG = corrcoef(double(PG1), double(PG2))
    rPB = corrcoef(double(PB1), double(PB2))
    
    
    rCR = corrcoef(double(CR1), double(CR2))
    rCG = corrcoef(double(CG1), double(CG2))
    rCB = corrcoef(double(CB1), double(CB2))
end