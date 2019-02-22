def ieee_float(theta):
	theta_binary = []
	if (theta >= 0):
		theta_binary.append('0')
	else:
		theta_binary.append('1')
		theta = -theta

	exponent = 0

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
	return 	theta_binary[0], exponent, theta	

theta = input("Enter the value of theta in radians (base 10) : ")

theta = float(theta)
temp = theta

sign,exp,man = ieee_float(theta)

print(sign,exp,man)


exp_len = 8
mantissa_len = 23


pi = 3.14159265359
delta = pi/1024

theta1 = theta+delta

for  i in range(1024):
	print(ieee_float(pi-i*delta))
# print(ieee_float(theta1))
# print(ieee_float(theta1+delta))

