function y = encryption(plain_text_arr,key)
    duration = 6.5535;
    num_chars = 256;
    tspan = [0 duration];
    fps = 10000;
    delta = 1/fps;
    eta = 0.99;
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

%     intervals = {};
%     for i=1:num_chars
%         possibles = [];
%         for j=1:length(Y3)
%             if ((Y3(j)>=min(Y3)+(i-1)*epsilon) && (Y3(j)<min(Y3)+i*epsilon))
%                 possibles = [possibles,j];
%             end
%         end
%         if length(possibles)==0
%             fprintf("%d\n",i);
%         end
%         intervals{end+1} = possibles;
%     end
%     
%     disp(intervals);
   
    %%%%%%% generate lookup table %%%%%%%
    lookup_table = cell(num_chars, 1);
    for i=1:num_chars
        lookup_table{i} = [];
    end
    
    for j=1:length(Y)
        y_val = Y(j);
        D = floor((y_val - Ymin)/epsilon);
        d = D+1;
        lookup_values = lookup_table{d};
        lookup_values = [lookup_values, j-1];
        lookup_table{d} = lookup_values;
    end 
%     disp("Lookup Table");
%     disp(lookup_table);
    
    %%%%%%%%%%%%% Encryption %%%%%%%%%%%%%
    y = [];
    
    %%%%%%%%%% selecting f(key) %%%%%%%
    %f = halfprecision(key(1,1));
    %for K=2:length(key)
    %    f = bitxor(f, halfprecision(key(K,1)));
    %end
    
    for i = 1:length(plain_text_arr)
        p = plain_text_arr(i);
        flag = false;
        index = 1;
        while(flag == false)
            r = rand(1,1);
            %fprintf("Random num generated: %f\n", r);
            lookup_values = lookup_table{p+1};
            %c = intervals{1,d+1};
            
            %%%%select random between 0 to 1 and compare with eta %%%
            if r > eta && lookup_values(index)
                %fprintf("Index selected: %d, Value: %d\n", index, lookup_values(index));
                C = lookup_values(index);
                f = halfprecision(key(mod(i-1, key_len)+1,1));
                
                %%%% Operations %%%%%
                C = circularBitRotate(C,-mod(i,16),16);
                C = bitxor(C,f);
%                 C = circularBitRotate(C,-mod(i,16),16);
%                 C = bitxor(C,f);
%                 C = circularBitRotate(C,-mod(i,16),16);
%                 C = bitxor(C,f);
                
                y = [y, C];
                flag = true;
            else
                index = mod((index+1),(length(lookup_values)+1));
                if index == 0
                    index = 1;
                end
            end  

            %%%%% select random index %%%%%        
%             len = length(lookup_values);
%             r2 = randi([1, len],1,1);
%             %fprintf("Random num generated for length %d: %d\n", len, r2);
%             C = lookup_values(r2);
%             %fprintf("Iteration: %d: key:%d\n", index, f);
%             yy = bitxor(C,bitror(f, k));
%             y = [y, yy];
%             flag= true;
        end
    end
end