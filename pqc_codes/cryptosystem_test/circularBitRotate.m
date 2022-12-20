function y = circularBitRotate(n ,nBits, bitLen)
    binStr = dec2bin(n,bitLen);
    Y = circshift(binStr, nBits);
    y = bin2dec(Y);
end