function [s,e,f] = ieee754(x)
%Determining sign of x
sign=0;
if x<0
    sign=1;
    x=-x;
end

n_exponent=0;
x_1=x;
if abs(x)<1
    while abs(x_1)<1
        n_exponent=n_exponent-1;
        x_1=x/(2.^n_exponent);
    end
else
    while abs(x_1)>=2
        n_exponent=n_exponent+1;
        x_1=x/(2.^n_exponent);
    end
end
%Exponent to 8-bit binary (single precision 127)
exp_127=n_exponent+127;
bit8 = zeros(1, 8);
for n=1:8
    bit8(n)=rem(exp_127,2);
    exp_127=fix(exp_127/2);
end

% Converting fraction to 23-bit mantissa (leading 1 hidden)
fraction=x_1-1;
bit23 = zeros(1, 23);
for n=1:23
    fraction=fraction*2;
    bit23(n)=fix(fraction);
    fraction=fraction-fix(fraction);
end


%Full IEEE 754 binary floating point
s = [sign];
e = [fliplr(bit8)];
f = [bit23];
