import math
exp_len = 8
mantissa_len = 23

sig_mantissa_len = 3

def decimalToBinary(num, k_prec) :
    binary = ""  
    Integral = int(num)  
    fractional = num - Integral 
    while (Integral) : 
        rem = Integral % 2 
        binary += str(rem)  
        Integral //= 2
    binary = binary[ : : -1] 
    binary += '.' 
    while (k_prec) :   
        fractional *= 2
        fract_bit = int(fractional)  
        if (fract_bit == 1) : 
            fractional -= fract_bit  
            binary += '1'
        else : 
            binary += '0'
        k_prec -= 1
  
    return binary

def dec2ieee(theta):
	theta_binary = []
	if (theta >= 0):
		theta_binary.append('0')
	else:
		theta_binary.append('1')
		theta = -theta

	exponent = 127

	#Finding mantissa and exponent of theta
	while(True):
		if (theta >= 2):
			exponent = exponent + 1
			theta = theta/2
		elif (theta < 1 and theta>0):
			exponent = exponent - 1
			theta = theta*2
		else:
			break
	theta -=1
			
	return 	"".join([theta_binary[0], "{0:08b}".format(exponent), decimalToBinary(theta,23)[1:]])


def ieee2dec(b):
	sign = b[0]
	exp = b[1:9]
	mantissa = '1.'+b[9:32]

	sign_val = (-1)**int(sign)
	exp_val = 2**(int(exp,2)-127)
	mantissa_val = 1
	for i in range(1,23):
		mantissa_val+= int(b[31-(23-i)])*(2**(-i))
	# print(sign)
	# print(exp)
	# print(mantissa)
	return sign_val*exp_val*mantissa_val

# print(ieee2dec('11000010111101101110100101111001'))


e = 128
s = 0
for i in range(2**(sig_mantissa_len)):
	val = (s<<(exp_len+mantissa_len))+(e<<mantissa_len)+(i<<(mantissa_len-sig_mantissa_len))
	val_str = "{0:032b}".format(val)
	#print(val_str)
	theta = ieee2dec(val_str)
	ctheta = math.cos(theta)
	stheta = math.sin(theta) 
	print(theta,dec2ieee(ctheta),dec2ieee(stheta))