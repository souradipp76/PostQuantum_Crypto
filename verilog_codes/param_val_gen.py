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
	if theta == 0:
		return "{0:032b}".format(0)
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


params = [5.8229,5.0781,4.7667,0,0,0,0.2944,0.1765,0.0947,0.5080,0.2540,0.1270,0.0095,0.0016,0.0002,0.0050,0,0.0008,9.8100,10.0000,0.0010,0.0005,40.7488]
eps = 1/params[-1]
#print(params[-1],params[-2])
params[-2] = params[-2]*params[-1]
#print(params)
#print(eps)
for i in range(len(params)):
	print("{0:08x}".format((int(dec2ieee(params[i]),2))))
