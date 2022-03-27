function y = decryption(cipher_text_arr,key)
    duration = 6.5535;
    num_chars = 256;
    tspan = [0 duration];
    fps = 10000;
    delta = 1/fps;
    ivp = key;
    key_len = length(key(:,1)); 
    if isfile("theta_norm.csv")
        X = csvread('theta_norm.csv',0,0);
        disp(size(X));
    else
        X = triple_pendulum(ivp, duration, fps);
    end 
    
    X1 = X(1,:);
    X2 = X(2,:);
    X3 = X(3,:);
    
    %%%%%%%%%%% select Y as a combination of X1,X2,X3 %%%%%%%%%
    Y = X3;
    
    Ymax = max(Y);
    Ymin = min(Y);
    epsilon = (Ymax+delta - Ymin)/num_chars;
    %epsilon = 2*pi/num_chars;
    
    
    %%%%%%%%%%%%% Decryption %%%%%%%%%%%%%
    y = [];    
    
    %%%%%%%%%% selecting f(key) %%%%%%%
    %f = halfprecision((key(1,1)));
    %for K=2:length(key)
    %    f = bitxor(f, halfprecision(key(K,1)));
    %end
     
    for i = 1:length(cipher_text_arr)
        c = cipher_text_arr(i);
        f = halfprecision(key(mod(i-1, key_len)+1, 1));
        
        %%%% Operations %%%%%
%         C = bitxor(c, f);
%         C = circularBitRotate(C, mod(i,16), 16);
%         C = bitxor(C, f);
%         C = circularBitRotate(C, mod(i,16), 16);
%         C = bitxor(C, f);
%         C = circularBitRotate(C, mod(i,16), 16);
        
        y_val =  Y(C+1);
        d = floor((y_val - Ymin)/epsilon);
        y = [y, d];
    end
end