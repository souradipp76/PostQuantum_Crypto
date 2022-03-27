function diffCrypt(key)

% x = grayCodes(8);
% y = [];
% xn = uint8(x');
% yn = encryption(xn, key);
% y = yn';
% 
% delY = [];
% for i=1:length(y)
%     for j = i+1:length(y)
%         delY = [delY, bitxor(y(i), y(j))];
%     end
% end
% 
% h = histogram(delY, 65536);

key_len = length(key);

m1 = 0:255;
c1 = encryption(m1, key); 

s1 = [];
for i=0:255
    f = halfprecision(key(mod(i, key_len)+1,1));
    s1 = [s1, bitxor(c1(i+1), f)];
end

% b = [];
% for i=0:255
%     b = [b; dec2bin(i, 8) == '1'];
% end
% disp(b);
% 
% m2 = [];
% for i=0:255
%     g = graystep(b(i+1, :), 0);
%     str_g = num2str(g);
%     disp(str_g);
%     m2 = [m2, bin2dec(str_g)];
% end
% 
% c2 = encryption(m2, key);
% 
% delC = bitxor(c1,c2);
% figure;
% H_delC = histogram(delC, 256);
% 
% s1 = [];
% s2 = [];
% key_len = length(key);
% for i=0:255
%     f = halfprecision(key(mod(i, key_len)+1,1));
%     s1 = [s1, bitxor(c1(i+1), f)];
%     s2 = [s2, bitxor(c2(i+1), f)];
% end
% 
% delS = bitxor(c1,c2);
% 
% figure;
% H_delS = histogram(delS, 256);
% 
% 
% m3 = [];
% for i=0:255
%     m3 = [m3, bitcmp(i, 'uint8')];
% end
% 
% c3 = encryption(m3, key);
% 
% delC3 = bitxor(c1,c3);
% 
% figure;
% H_delC3 = histogram(delC3, 256);

m4 = [];
for i=0:255
    m4 = [m4, mod(2*i,256)]; %%% change m4 accordingly to set delta M
end

c4 = encryption(m4, key);

delC4 = [];
for i=1:256
    %disp({c1(i), c4(i), abs(int32(c1(i)) - int32(c4(i)))});
    delC4 = [delC4, mod(abs(int32(c1(i)) - int32(c4(i))), 65536)];
end

figure;
H_delC4 = histogram(delC4, 65536);


s4 = [];
for i=0:255
    f = halfprecision(key(mod(i, key_len)+1,1));
    s4 = [s4, bitxor(c4(i+1), f)];
end

delS4 = [];
for i=1:256
    %disp({s1(i), s4(i), abs(int32(s1(i)) - int32(s4(i)))});
    delS4 = [delS4, mod(abs(int32(s1(i)) - int32(s4(i))), 65536)];
end

figure;
H_delS4 = histogram(delS4, 65536);
