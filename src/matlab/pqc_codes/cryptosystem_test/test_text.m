function test_text(filename, key)

str = fileread(filename);

% binary = reshape(dec2bin(str, 8).'-'0',1,[]);
% binary=fliplr(binary);
% plain_text_arr(1:numel(binary)) = binary
plain_text_arr = uint8(str);

%%%%%% encrypt %%%%%%%%%%
cipher_text_arr = encryption(plain_text_arr,key);

%%%%%% decrypt %%%%%%%%%%
clear_text = decryption(cipher_text_arr,key);
decrypted_text_arr = char(clear_text);


%%%%%%%%% Analysis %%%%%%%%
figure;
grid on;
ph = histogram(plain_text_arr, 256);

figure;
grid on;
scatter(linspace(0,255, 256), ph.Values, 5, 'filled');

figure;
grid on;
scatter(plain_text_arr(1:6000), linspace(0,5999, 6000), 5, 'filled');

figure;
ch = histogram(cipher_text_arr, 65536);

figure;
grid on;
scatter(linspace(0,65535, 65536), ch.Values, 5, 'filled');

figure;
grid on;
scatter(cipher_text_arr(1:6000), linspace(0,5999, 6000), 5, 'filled');


end