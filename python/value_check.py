from pythonds.basic.stack import Stack
import math

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
            
    return  "".join([theta_binary[0], "{0:08b}".format(exponent), decimalToBinary(theta,23)[1:]])

def infixToPostfix(infixexpr):
    prec = {}
    prec["^"] = 4
    prec["*"] = 3
    prec["/"] = 3
    prec["+"] = 2
    prec["-"] = 2
    prec["("] = 1
    opStack = Stack()
    postfixList = []
    
     
    tokenList = infixexpr
    #print(tokenList)

    index=0
    while index<len(tokenList):
        token = tokenList[index]
        #print(index,token)
        if token==' ':
            index = index+1
            continue
        if token in "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz" or token in "0123456789":
            operand = ""
            if token == "s" or token =="c":
                if token =="s":
                    operand = "sin"
                else:
                    operand = "cos" 
                i = index+3
                sinStack = Stack()
                sinStack.push(tokenList[i])
                operand +=tokenList[i]
                i = i+1
                while(not sinStack.isEmpty()):
                    operand += tokenList[i]
                    if tokenList[i] == "(":
                        sinStack.push(tokenList[i])
                    elif tokenList[i] ==')':
                        sinStack.pop()
                    i=i+1       
                postfixList.append(operand)
                index = i-1    
            elif token in "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz":
                if token == "x":
                    operand = tokenList[index]
                    index = index+1
                    operand += tokenList[index]
                    index = index+1
                    operand += tokenList[index]
                    index = index+1
                    operand += tokenList[index]
                    postfixList.append(operand)
                elif token == 'g':
                    operand = tokenList[index] 
                    postfixList.append(operand)    
                else:
                    operand = tokenList[index]
                    index = index+1
                    operand += tokenList[index]
                    postfixList.append(operand)
            else:
                while tokenList[index] in "0123456789":
                    operand += tokenList[index]
                    index+=1 
                postfixList.append(operand)
                index = index-1   
        elif token == '(':
            opStack.push(token)
        elif token == ')':
            if not opStack.isEmpty():
                topToken = opStack.pop()
                while topToken != '(' and not opStack.isEmpty():
                    postfixList.append(topToken)
                    topToken = opStack.pop()
        else:
            while (not opStack.isEmpty()) and (prec[opStack.peek()] >= prec[token]):
                #if opStack.peek()=="^":
                #    opStack.pop()

                postfixList.append(opStack.peek())
                opStack.pop()
            opStack.push(token)
        index = index+1
        #print(postfixList)
        #if not opStack.isEmpty():
        #    print(opStack.peek())    

    while not opStack.isEmpty():
        postfixList.append(opStack.pop())   
    return postfixList


#expr = "m2^2*sin(2*x(1)-3*x(2))"
expr1 = "0-(2*(((L3^2)*(m3^2)*sin(2*x(1)-2*x(3))*(4*I2-(L2^2)*m2)+(L2^2)*sin(2*x(1)-2*x(2))*(m2+2*m3)*(m2*m3*(L3^2)+4*I3*(m2+2*m3)))*(L1^2)*(x(4)^2)+(L2*(sin(x(1)-x(2))*((m2*m3*(m2+3*m3)*(L3^2)+4*I3*((m2^2)+6*m2*m3+8*(m3^2)))*(L2^2)+4*I2*(m3*(m2+m3)*(L3^2)+4*I3*(m2+2*m3)))+(L3^2)*(m3^2)*sin(x(1)+x(2)-2*x(3))*(4*I2-(L2^2)*m2))*(x(5)^2)-4*k2*L2*(cos(x(1)-x(2))*(m3*(m2+m3)*(L3^2)+4*I3*(m2+2*m3))-(L3^2)*(m3^2)*cos(x(1)+x(2)-2*x(3)))*(x(5)^2)+L3*m3*(sin(x(1)-x(3))*(8*I3*m3*(L2^2)+4*I2*m3*(L3^2)+16*I2*I3)+(L2^2)*sin(x(1)-2*x(2)+x(3))*(m2*m3*(L3^2)+4*I3*(m2+2*m3)))*(x(6)^2)-4*k3*L3*m3*(cos(x(1)-x(3))*(2*m3*(L2^2)+4*I2)-(L2^2)*cos(x(1)-2*x(2)+x(3))*(m2+2*m3))*x(6)-g*(sin(x(1))*((m3*(m1*m2+2*m1*m3+3*m2*m3+(m2^2))*(L3^2)+4*I3*((m2^2)+6*m2*m3+m1*m2+4*(m3^2)+4*m1*m3))*(L2^2)+4*I2*(m3*(m1+2*m2+m3)*(L3^2)+4*I3*(m1+2*m2+2*m3)))+(L3^2)*(m3^2)*(sin(x(1)-2*x(3))*(4*I2-(L2^2)*m2)-2*(L2^2)*cos(2*x(2)-2*x(3))*sin(x(1))*(m1+m2))+(L2^2)*sin(x(1)-2*x(2))*(m2+2*m3)*(m2*m3*(L3^2)+4*I3*(m2+2*m3))))*L1+2*k1*(4*I2*(m3*(L3^2)+4*I3)+(L2^2)*(m3*(m2+2*m3)*(L3^2)+4*I3*(m2+4*m3))-2*(L2^2)*(L3^2)*(m3^2)*cos(2*x(2)-2*x(3)))*x(1)))/(64*I1*I2*I3+8*I3*(L1^2)*(L2^2)*(m2^2)+8*I1*(L2^2)*(L3^2)*(m3^2)+8*I2*(L1^2)*(L3^2)*(m3^2)+32*I3*(L1^2)*(L2^2)*(m3^2)+16*I2*I3*(L1^2)*m1+16*I1*I3*(L2^2)*m2+64*I2*I3*(L1^2)*m2+16*I1*I2*(L3^2)*m3+64*I1*I3*(L2^2)*m3+64*I2*I3*(L1^2)*m3+4*I3*(L1^2)*(L2^2)*m1*m2+4*I2*(L1^2)*(L3^2)*m1*m3+16*I3*(L1^2)*(L2^2)*m1*m3+4*I1*(L2^2)*(L3^2)*m2*m3+16*I2*(L1^2)*(L3^2)*m2*m3+48*I3*(L1^2)*(L2^2)*m2*m3-8*I1*(L2^2)*(L3^2)*(m3^2)*cos(2*x(2)-2*x(3))-2*(L1^2)*(L2^2)*cos(2*x(1)-2*x(2))*(m2+2*m3)*(m2*m3*(L3^2)+4*I3*(m2+2*m3))-2*(L1^2)*(L3^2)*(m3^2)*cos(2*x(1)-2*x(3))*(0-m2*(L2^2)+4*I2)+2*(L1^2)*(L2^2)*(L3^2)*m1*(m3^2)+6*(L1^2)*(L2^2)*(L3^2)*m2*(m3^2)+2*(L1^2)*(L2^2)*(L3^2)*(m2^2)*m3+(L1^2)*(L2^2)*(L3^2)*m1*m2*m3-2*(L1^2)*(L2^2)*(L3^2)*m1*(m3^2)*cos(2*x(2)-2*x(3))-4*(L1^2)*(L2^2)*(L3^2)*m2*(m3^2)*cos(2*x(2)-2*x(3)))"
expr2 = "(2*(((L1^2)*sin(2*x(1)-2*x(2))*(m2+2*m3)*(m2*m3*(L3^2)+4*I3*(m2+2*m3))-(L3^2)*(m3^2)*sin(2*x(2)-2*x(3))*((m1+2*m2)*(L1^2)+4*I1))*(L2^2)*(x(5)^2)+L1*(sin(x(1)-x(2))*((m3*(m1*(m2+m3)+2*m2*(2*m2+3*m3))*(L3^2)+4*I3*(m2+2*m3)*(m1+4*m2+4*m3))*(L1^2)+4*I1*(m3*(m2+m3)*(L3^2)+4*I3*(m2+2*m3)))-(L3^2)*(m3^2)*sin(x(1)+x(2)-2*x(3))*((m1+2*m2)*(L1^2)+4*I1))*L2*(x(4)^2)+4*k1*L1*(cos(x(1)-x(2))*(m3*(m2+m3)*(L3^2)+4*I3*(m2+2*m3))-(L3^2)*(m3^2)*cos(x(1)+x(2)-2*x(3)))*L2*x(4)+(0-L3*m3*(sin(x(2)-x(3))*((m3*(m1+3*m2)*(L3^2)+4*I3*(m1+3*m2+2*m3))*(L1^2)+4*I1*(m3*(L3^2)+4*I3))-(L1^2)*sin(2*x(1)-x(2)-x(3))*(m2*m3*(L3^2)+4*I3*(m2+2*m3)))*(x(6)^2)+4*k3*L3*m3*(cos(x(2)-x(3))*((m1+3*m2+2*m3)*(L1^2)+4*I1)-(L1^2)*cos(2*x(1)-x(2)-x(3))*(m2+2*m3))*x(6)+g*(sin(x(2))*((m2*m3*(2*m2+3*m3)*(L3^2)+8*I3*((m2^2)+3*m2*m3+2*(m3^2)))*(L1^2)+4*I1*(m3*(m2+m3)*(L3^2)+4*I3*(m2+2*m3)))-(L1^2)*sin(2*x(1)-x(2))*(m3*(m1*(m2+m3)+m2*(2*m2+3*m3))*(L3^2)+4*I3*(m2+2*m3)*(m1+2*m2+2*m3))+(L3^2)*(m3^2)*(sin(x(2)-2*x(3))*(m2*(L1^2)+4*I1)+(L1^2)*sin(2*x(1)+x(2)-2*x(3))*(m1+m2))))*L2-2*k2*(4*I1*(m3*(L3^2)+4*I3)+(L1^2)*(m3*(m1+4*m2+2*m3)*(L3^2)+4*I3*(m1+4*m2+4*m3))-2*(L1^2)*(L3^2)*(m3^2)*cos(2*x(1)-2*x(3)))*(x(5)^2)))/(64*I1*I2*I3+8*I3*(L1^2)*(L2^2)*(m2^2)+8*I1*(L2^2)*(L3^2)*(m3^2)+8*I2*(L1^2)*(L3^2)*(m3^2)+32*I3*(L1^2)*(L2^2)*(m3^2)+16*I2*I3*(L1^2)*m1+16*I1*I3*(L2^2)*m2+64*I2*I3*(L1^2)*m2+16*I1*I2*(L3^2)*m3+64*I1*I3*(L2^2)*m3+64*I2*I3*(L1^2)*m3+4*I3*(L1^2)*(L2^2)*m1*m2+4*I2*(L1^2)*(L3^2)*m1*m3+16*I3*(L1^2)*(L2^2)*m1*m3+4*I1*(L2^2)*(L3^2)*m2*m3+16*I2*(L1^2)*(L3^2)*m2*m3+48*I3*(L1^2)*(L2^2)*m2*m3-8*I1*(L2^2)*(L3^2)*(m3^2)*cos(2*x(2)-2*x(3))-2*(L1^2)*(L2^2)*cos(2*x(1)-2*x(2))*(m2+2*m3)*(m2*m3*(L3^2)+4*I3*(m2+2*m3))-2*(L1^2)*(L3^2)*(m3^2)*cos(2*x(1)-2*x(3))*(0-m2*(L2^2)+4*I2)+2*(L1^2)*(L2^2)*(L3^2)*m1*(m3^2)+6*(L1^2)*(L2^2)*(L3^2)*m2*(m3^2)+2*(L1^2)*(L2^2)*(L3^2)*(m2^2)*m3+(L1^2)*(L2^2)*(L3^2)*m1*m2*m3-2*(L1^2)*(L2^2)*(L3^2)*m1*(m3^2)*cos(2*x(2)-2*x(3))-4*(L1^2)*(L2^2)*(L3^2)*m2*(m3^2)*cos(2*x(2)-2*x(3)))"
expr3 = "0-(2*(32*I1*I2*k3*x(6)-L2*L3*m3*(x(5)^2)*(sin(x(2)-x(3))*(((L2^2)*(m1*m2+4*m1*m3+6*m2*m3+(m2^2))+4*I2*(m1+3*m2+2*m3))*(L1^2)+4*I1*(4*I2+(L2^2)*(m2+4*m3)))+(L1^2)*sin(2*x(1)-x(2)-x(3))*(m2+2*m3)*(4*I2-m2*(L2^2)))-L1*L3*m3*(x(4)^2)*(sin(x(1)-x(3))*(8*I1*(m3*(L2^2)+2*I2)+2*(L1^2)*((m1*m3-(m2^2))*(L2^2)+2*I2*(m1+4*m2+4*m3)))-(L2^2)*sin(x(1)-2*x(2)+x(3))*(m2+2*m3)*((m1+2*m2)*(L1^2)+4*I1))+4*k3*(L1^2)*(L2^2)*(m2^2)*x(6)+16*k3*(L1^2)*(L2^2)*(m3^2)*x(6)+8*I2*k3*(L1^2)*m1*x(6)+8*I1*k3*(L2^2)*m2*x(6)+32*I2*k3*(L1^2)*m2*x(6)+32*I1*k3*(L2^2)*m3*x(6)+32*I2*k3*(L1^2)*m3*x(6)-4*k1*L1*L3*m3*x(4)*(cos(x(1)-x(3))*(2*m3*(L2^2)+4*I2)-(L2^2)*cos(x(1)-2*x(2)+x(3))*(m2+2*m3))-16*I1*I2*g*L3*m3*sin(x(3))-4*I2*(L1^2)*(L3^2)*(m3^2)*(x(6)^2)*sin(2*x(1)-2*x(3))-4*I1*(L2^2)*(L3^2)*(m3^2)*(x(6)^2)*sin(2*x(2)-2*x(3))+8*I2*g*(L1^2)*L3*(m3^2)*sin(2*x(1)-x(3))+8*I1*g*(L2^2)*L3*(m3^2)*sin(2*x(2)-x(3))+2*k3*(L1^2)*(L2^2)*m1*m2*x(6)+8*k3*(L1^2)*(L2^2)*m1*m3*x(6)+24*k3*(L1^2)*(L2^2)*m2*m3*x(6)-4*k2*L2*L3*m3*x(5)*(cos(x(2)-x(3))*((m1+3*m2+2*m3)*(L1^2)+4*I1)-(L1^2)*cos(2*x(1)-x(2)-x(3))*(m2+2*m3))-8*I1*g*(L2^2)*L3*(m3^2)*sin(x(3))-8*I2*g*(L1^2)*L3*(m3^2)*sin(x(3))-4*k3*(L1^2)*(L2^2)*(m2^2)*x(6)*cos(2*x(1)-2*x(2))-16*k3*(L1^2)*(L2^2)*(m3^2)*x(6)*cos(2*x(1)-2*x(2))-8*I2*g*(L1^2)*L3*m2*m3*sin(x(3))-16*k3*(L1^2)*(L2^2)*m2*m3*x(6)*cos(2*x(1)-2*x(2))-(L1^2)*(L2^2)*(L3^2)*m1*(m3^2)*(x(6)^2)*sin(2*x(2)-2*x(3))+(L1^2)*(L2^2)*(L3^2)*m2*(m3^2)*(x(6)^2)*sin(2*x(1)-2*x(3))-2*(L1^2)*(L2^2)*(L3^2)*m2*(m3^2)*(x(6)^2)*sin(2*x(2)-2*x(3))+2*g*(L1^2)*(L2^2)*L3*m1*(m3^2)*sin(2*x(1)-x(3))-g*(L1^2)*(L2^2)*L3*(m2^2)*m3*sin(2*x(1)-x(3))+2*g*(L1^2)*(L2^2)*L3*m2*(m3^2)*sin(2*x(2)-x(3))+g*(L1^2)*(L2^2)*L3*(m2^2)*m3*sin(2*x(2)-x(3))+4*I2*g*(L1^2)*L3*m1*m3*sin(2*x(1)-x(3))+8*I2*g*(L1^2)*L3*m2*m3*sin(2*x(1)-x(3))+4*I1*g*(L2^2)*L3*m2*m3*sin(2*x(2)-x(3))-2*g*(L1^2)*(L2^2)*L3*m1*(m3^2)*sin(2*x(1)-2*x(2)+x(3))-2*g*(L1^2)*(L2^2)*L3*m2*(m3^2)*sin(2*x(1)-2*x(2)+x(3))-g*(L1^2)*(L2^2)*L3*(m2^2)*m3*sin(2*x(1)-2*x(2)+x(3))+g*(L1^2)*(L2^2)*L3*(m2^2)*m3*sin(x(3))-g*(L1^2)*(L2^2)*L3*m1*m2*m3*sin(2*x(1)-2*x(2)+x(3))))/(64*I1*I2*I3+8*I3*(L1^2)*(L2^2)*(m2^2)+8*I1*(L2^2)*(L3^2)*(m3^2)+8*I2*(L1^2)*(L3^2)*(m3^2)+32*I3*(L1^2)*(L2^2)*(m3^2)+16*I2*I3*(L1^2)*m1+16*I1*I3*(L2^2)*m2+64*I2*I3*(L1^2)*m2+16*I1*I2*(L3^2)*m3+64*I1*I3*(L2^2)*m3+64*I2*I3*(L1^2)*m3+4*I3*(L1^2)*(L2^2)*m1*m2+4*I2*(L1^2)*(L3^2)*m1*m3+16*I3*(L1^2)*(L2^2)*m1*m3+4*I1*(L2^2)*(L3^2)*m2*m3+16*I2*(L1^2)*(L3^2)*m2*m3+48*I3*(L1^2)*(L2^2)*m2*m3-8*I1*(L2^2)*(L3^2)*(m3^2)*cos(2*x(2)-2*x(3))-2*(L1^2)*(L2^2)*cos(2*x(1)-2*x(2))*(m2+2*m3)*(m2*m3*(L3^2)+4*I3*(m2+2*m3))-2*(L1^2)*(L3^2)*(m3^2)*cos(2*x(1)-2*x(3))*(4*I2-m2*(L2^2))+2*(L1^2)*(L2^2)*(L3^2)*m1*(m3^2)+6*(L1^2)*(L2^2)*(L3^2)*m2*(m3^2)+2*(L1^2)*(L2^2)*(L3^2)*(m2^2)*m3+(L1^2)*(L2^2)*(L3^2)*m1*m2*m3-2*(L1^2)*(L2^2)*(L3^2)*m1*(m3^2)*cos(2*x(2)-2*x(3))-4*(L1^2)*(L2^2)*(L3^2)*m2*(m3^2)*cos(2*x(2)-2*x(3)))"


pstfix = infixToPostfix(expr1)
print(pstfix)

param_dict={}
p= [5.8229,5.0781,4.7667,0,0,0,0.2944,0.1765,0.0947,0.5080,0.2540,0.1270,0.009526,0.001625,0.0001848,0.0050,0,0.0008,9.8100,10.0000,0.0010,0.0005,40.7488]

param_dict['x(1)'] = p[0];
param_dict['x(2)'] = p[1];
param_dict['x(3)'] = p[2];
param_dict['x(4)'] = p[3];
param_dict['x(5)'] = p[4];
param_dict['x(6)'] = p[5];

param_dict['m1'] = p[6];
param_dict['m2'] = p[7];
param_dict['m3'] = p[8];
param_dict['L1'] = p[9];
param_dict['L2'] = p[10];
param_dict['L3'] = p[11];
param_dict['I1'] = p[12];
param_dict['I2'] = p[13];
param_dict['I3'] = p[14];
param_dict['k1'] = p[15];
param_dict['k2'] = p[16];
param_dict['k3'] = p[17];
param_dict['g'] = p[18];


trig_dict={}

trig_dict["2*x(1)-2*x(3)"]=2*p[0]-2*p[2]
trig_dict["2*x(1)-2*x(2)"]=2*p[0]-2*p[1]
trig_dict["x(1)-x(2)"]=p[0]-p[1]
trig_dict["x(1)+x(2)-2*x(3)"]=p[0]+p[1]-2*p[2]
trig_dict["x(1)-x(3)"]=p[0]-p[2]
trig_dict["x(1)-2*x(2)+x(3)"]=p[0]-2*p[1]+p[2]
trig_dict["x(1)"]=p[0]
trig_dict["x(1)-2*x(3)"]=p[0]-2*p[2]
trig_dict["2*x(2)-2*x(3)"]=2*p[1]-2*p[2]
trig_dict["x(1)-2*x(2)"]=p[0]-2*p[1]
trig_dict["x(2)"]=p[1]
trig_dict["x(2)-x(3)"]=p[1]-p[2]
trig_dict["2*x(1)-x(2)-x(3)"]=2*p[0]-p[1]-p[2]
trig_dict["2*x(1)-x(2)"]=2*p[0]-p[1]
trig_dict["x(2)-2*x(3)"]=p[1]-2*p[2]
trig_dict["2*x(1)+x(2)-2*x(3)"]=2*p[0]-p[1]-2*p[2]
trig_dict["x(3)"]=p[2]
trig_dict["2*x(1)-x(3)"]=2*p[0]-p[2]
trig_dict["2*x(2)-x(3)"]=2*p[1]-p[2]
trig_dict["2*x(1)-2*x(2)+x(3)"]=2*p[0]-2*p[1]+p[2]

valStack = Stack()

for item in pstfix:
    if(item.isdigit()):
        xval = int(item,10)
        valStack.push(xval)
    elif(item[0]=='x'):
        valStack.push(param_dict[item])
    elif(item[0]=='s'):
        valStack.push(math.sin(trig_dict[item[4:-1]]))
    elif(item[0]=='c'):
        valStack.push(math.cos(trig_dict[item[4:-1]]))
    elif(item=="^"):
        xval2=valStack.pop()
        xval1=valStack.pop()
        valStack.push(xval1**xval2)
    elif(item=="*"):
        xval2=valStack.pop()
        xval1=valStack.pop()
        valStack.push(xval1*xval2)
    elif(item=="+"):
        xval2=valStack.pop()
        xval1=valStack.pop()
        valStack.push(xval1+xval2)  
    elif(item=="-"):
        xval2=valStack.pop()
        xval1=valStack.pop()
        valStack.push(xval1-xval2)
    elif(item=="/"):
        xval2=valStack.pop()
        xval1=valStack.pop()
        valStack.push(xval1/(1.0*xval2))
    else:
        valStack.push(param_dict[item])
    t = valStack.peek()
    print(t)
   
    #print("{0:08x}".format((int(dec2ieee(t),2))))  
