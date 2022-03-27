function y = encryption(plain_text_arr,key)
    duration = 10;
    num_chars = 256;
    tspan = [0 duration];
    fps = 1000;
    eta = 0.75;
    ivp = key;
    Y = triple_pendulum(ivp, duration, fps);
    Y3 = Y(3,:);
    epsilon = (max(Y3)- min(Y3))/num_chars;
    %epsilon = 2*pi/num_chars;
    
    intervals = {};
    y = [];
    
    for i=1:num_chars
        possibles = [];
        for j=1:length(Y3)
            if ((Y3(j)>=min(Y3)+(i-1)*epsilon) && (Y3(j)<min(Y3)+i*epsilon))
                possibles = [possibles,j];
            end
        end
        if length(possibles)==0
            fprintf("%d\n",i);
        end
        intervals{end+1} = possibles;
    end
    
    for k = 1:length(plain_text_arr)
        d = plain_text_arr(k);
        flag = false;
        index = 1;
        while(flag == false)
            r = rand(1,1);
            c = intervals{1,d+1};
            if r > eta && c(index)
                y = [y,c(index)];
                flag = true;
            else
                index = mod((index+1),(length(c)+1));
                if index == 0
                    index = 1;
                end
            end    
        end
    end
end