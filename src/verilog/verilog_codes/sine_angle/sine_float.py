
theta = input("Enter the value of theta in radians (base 10) : ")

theta_binary = []

theta = float(theta)
temp = theta

#Finding binary value of theta
#Not required in verilog
if (theta >= 0):
	theta_binary.append('0')
else:
	theta_binary.append('1')
	theta = -theta

exponent = 0

#Finding mantissa and exponent of theta
#Shouldn' be required in verilog
while(True):
	if (theta >= 2):
		exponent = exponent + 1
		theta = theta/2
	elif (theta < 1):
		exponent = exponent - 1
		theta = theta*2
	else:
		break

pi_mantissa = 1.5707963267948966
two_pi_exponent = 2

#This is to be done in Verilog
##########################################
if (pi_mantissa < theta):
	to_be_subtracted_exp = exponent
elif (pi_mantissa > theta):
	to_be_subtracted_exp = exponent - 1

to_be_subtracted = pi_mantissa*(2**(to_be_subtracted_exp))

result = temp - to_be_subtracted
print(result)
#########################################

print('Sign : ', theta_binary[0], 'Exponent : ', exponent, 'Mantissa : ', theta)
print(to_be_subtracted_exp)

'''
always @(posedge clk) begin		//angle_normalization

	case (state_angle_normalization) begin

		4'd0 : begin
			if (angle_normalization_start == 1'b1) begin
				state_angle_normalization <= 4'd1;
				end
			else begin
				state_angle_normalization <= 4'd0;
				end
			end

		4'd1 : begin