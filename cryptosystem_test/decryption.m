function y = decryption(cipher_text_arr,key)
    duration = 10;
    num_chars = 256;
    tspan = [0 duration];
    fps = 1000;
    delta = 1/fps;
    ivp = key;
    Y = triple_pendulum(ivp, duration, fps);
    Y3 = Y(3,:);
    epsilon = (max(Y3)- min(Y3))/num_chars;
    
    y = [];
    for k = 1:length(cipher_text_arr)
        x = cipher_text_arr(k);
        y_val =  Y3(x);
        d = (y_val - min(Y3))/epsilon;
        y = [y,floor(d)];
    end
end