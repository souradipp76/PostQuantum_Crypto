from pythonds.basic.stack import Stack

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
    #return " ".join(postfixList)

#expr = "m2^2*sin(2*x(1)-3*x(2))"
expr1 = "0-(2*(((L3^2)*(m3^2)*sin(2*x(1)-2*x(3))*(4*I2-(L2^2)*m2)+(L2^2)*sin(2*x(1)-2*x(2))*(m2+2*m3)*(m2*m3*(L3^2)+4*I3*(m2+2*m3)))*(L1^2)*(x(4)^2)+(L2*(sin(x(1)-x(2))*((m2*m3*(m2+3*m3)*(L3^2)+4*I3*((m2^2)+6*m2*m3+8*(m3^2)))*(L2^2)+4*I2*(m3*(m2+m3)*(L3^2)+4*I3*(m2+2*m3)))+(L3^2)*(m3^2)*sin(x(1)+x(2)-2*x(3))*(4*I2-(L2^2)*m2))*(x(5)^2)-4*k2*L2*(cos(x(1)-x(2))*(m3*(m2+m3)*(L3^2)+4*I3*(m2+2*m3))-(L3^2)*(m3^2)*cos(x(1)+x(2)-2*x(3)))*(x(5)^2)+L3*m3*(sin(x(1)-x(3))*(8*I3*m3*(L2^2)+4*I2*m3*(L3^2)+16*I2*I3)+(L2^2)*sin(x(1)-2*x(2)+x(3))*(m2*m3*(L3^2)+4*I3*(m2+2*m3)))*(x(6)^2)-4*k3*L3*m3*(cos(x(1)-x(3))*(2*m3*(L2^2)+4*I2)-(L2^2)*cos(x(1)-2*x(2)+x(3))*(m2+2*m3))*x(6)-g*(sin(x(1))*((m3*(m1*m2+2*m1*m3+3*m2*m3+(m2^2))*(L3^2)+4*I3*((m2^2)+6*m2*m3+m1*m2+4*(m3^2)+4*m1*m3))*(L2^2)+4*I2*(m3*(m1+2*m2+m3)*(L3^2)+4*I3*(m1+2*m2+2*m3)))+(L3^2)*(m3^2)*(sin(x(1)-2*x(3))*(4*I2-(L2^2)*m2)-2*(L2^2)*cos(2*x(2)-2*x(3))*sin(x(1))*(m1+m2))+(L2^2)*sin(x(1)-2*x(2))*(m2+2*m3)*(m2*m3*(L3^2)+4*I3*(m2+2*m3))))*L1+2*k1*(4*I2*(m3*(L3^2)+4*I3)+(L2^2)*(m3*(m2+2*m3)*(L3^2)+4*I3*(m2+4*m3))-2*(L2^2)*(L3^2)*(m3^2)*cos(2*x(2)-2*x(3)))*x(1)))/(64*I1*I2*I3+8*I3*(L1^2)*(L2^2)*(m2^2)+8*I1*(L2^2)*(L3^2)*(m3^2)+8*I2*(L1^2)*(L3^2)*(m3^2)+32*I3*(L1^2)*(L2^2)*(m3^2)+16*I2*I3*(L1^2)*m1+16*I1*I3*(L2^2)*m2+64*I2*I3*(L1^2)*m2+16*I1*I2*(L3^2)*m3+64*I1*I3*(L2^2)*m3+64*I2*I3*(L1^2)*m3+4*I3*(L1^2)*(L2^2)*m1*m2+4*I2*(L1^2)*(L3^2)*m1*m3+16*I3*(L1^2)*(L2^2)*m1*m3+4*I1*(L2^2)*(L3^2)*m2*m3+16*I2*(L1^2)*(L3^2)*m2*m3+48*I3*(L1^2)*(L2^2)*m2*m3-8*I1*(L2^2)*(L3^2)*(m3^2)*cos(2*x(2)-2*x(3))-2*(L1^2)*(L2^2)*cos(2*x(1)-2*x(2))*(m2+2*m3)*(m2*m3*(L3^2)+4*I3*(m2+2*m3))-2*(L1^2)*(L3^2)*(m3^2)*cos(2*x(1)-2*x(3))*(0-m2*(L2^2)+4*I2)+2*(L1^2)*(L2^2)*(L3^2)*m1*(m3^2)+6*(L1^2)*(L2^2)*(L3^2)*m2*(m3^2)+2*(L1^2)*(L2^2)*(L3^2)*(m2^2)*m3+(L1^2)*(L2^2)*(L3^2)*m1*m2*m3-2*(L1^2)*(L2^2)*(L3^2)*m1*(m3^2)*cos(2*x(2)-2*x(3))-4*(L1^2)*(L2^2)*(L3^2)*m2*(m3^2)*cos(2*x(2)-2*x(3)))"
expr2 = "(2*(((L1^2)*sin(2*x(1)-2*x(2))*(m2+2*m3)*(m2*m3*(L3^2)+4*I3*(m2+2*m3))-(L3^2)*(m3^2)*sin(2*x(2)-2*x(3))*((m1+2*m2)*(L1^2)+4*I1))*(L2^2)*(x(5)^2)+L1*(sin(x(1)-x(2))*((m3*(m1*(m2+m3)+2*m2*(2*m2+3*m3))*(L3^2)+4*I3*(m2+2*m3)*(m1+4*m2+4*m3))*(L1^2)+4*I1*(m3*(m2+m3)*(L3^2)+4*I3*(m2+2*m3)))-(L3^2)*(m3^2)*sin(x(1)+x(2)-2*x(3))*((m1+2*m2)*(L1^2)+4*I1))*L2*(x(4)^2)+4*k1*L1*(cos(x(1)-x(2))*(m3*(m2+m3)*(L3^2)+4*I3*(m2+2*m3))-(L3^2)*(m3^2)*cos(x(1)+x(2)-2*x(3)))*L2*x(4)+(0-L3*m3*(sin(x(2)-x(3))*((m3*(m1+3*m2)*(L3^2)+4*I3*(m1+3*m2+2*m3))*(L1^2)+4*I1*(m3*(L3^2)+4*I3))-(L1^2)*sin(2*x(1)-x(2)-x(3))*(m2*m3*(L3^2)+4*I3*(m2+2*m3)))*(x(6)^2)+4*k3*L3*m3*(cos(x(2)-x(3))*((m1+3*m2+2*m3)*(L1^2)+4*I1)-(L1^2)*cos(2*x(1)-x(2)-x(3))*(m2+2*m3))*x(6)+g*(sin(x(2))*((m2*m3*(2*m2+3*m3)*(L3^2)+8*I3*((m2^2)+3*m2*m3+2*(m3^2)))*(L1^2)+4*I1*(m3*(m2+m3)*(L3^2)+4*I3*(m2+2*m3)))-(L1^2)*sin(2*x(1)-x(2))*(m3*(m1*(m2+m3)+m2*(2*m2+3*m3))*(L3^2)+4*I3*(m2+2*m3)*(m1+2*m2+2*m3))+(L3^2)*(m3^2)*(sin(x(2)-2*x(3))*(m2*(L1^2)+4*I1)+(L1^2)*sin(2*x(1)+x(2)-2*x(3))*(m1+m2))))*L2-2*k2*(4*I1*(m3*(L3^2)+4*I3)+(L1^2)*(m3*(m1+4*m2+2*m3)*(L3^2)+4*I3*(m1+4*m2+4*m3))-2*(L1^2)*(L3^2)*(m3^2)*cos(2*x(1)-2*x(3)))*(x(5)^2)))/(64*I1*I2*I3+8*I3*(L1^2)*(L2^2)*(m2^2)+8*I1*(L2^2)*(L3^2)*(m3^2)+8*I2*(L1^2)*(L3^2)*(m3^2)+32*I3*(L1^2)*(L2^2)*(m3^2)+16*I2*I3*(L1^2)*m1+16*I1*I3*(L2^2)*m2+64*I2*I3*(L1^2)*m2+16*I1*I2*(L3^2)*m3+64*I1*I3*(L2^2)*m3+64*I2*I3*(L1^2)*m3+4*I3*(L1^2)*(L2^2)*m1*m2+4*I2*(L1^2)*(L3^2)*m1*m3+16*I3*(L1^2)*(L2^2)*m1*m3+4*I1*(L2^2)*(L3^2)*m2*m3+16*I2*(L1^2)*(L3^2)*m2*m3+48*I3*(L1^2)*(L2^2)*m2*m3-8*I1*(L2^2)*(L3^2)*(m3^2)*cos(2*x(2)-2*x(3))-2*(L1^2)*(L2^2)*cos(2*x(1)-2*x(2))*(m2+2*m3)*(m2*m3*(L3^2)+4*I3*(m2+2*m3))-2*(L1^2)*(L3^2)*(m3^2)*cos(2*x(1)-2*x(3))*(0-m2*(L2^2)+4*I2)+2*(L1^2)*(L2^2)*(L3^2)*m1*(m3^2)+6*(L1^2)*(L2^2)*(L3^2)*m2*(m3^2)+2*(L1^2)*(L2^2)*(L3^2)*(m2^2)*m3+(L1^2)*(L2^2)*(L3^2)*m1*m2*m3-2*(L1^2)*(L2^2)*(L3^2)*m1*(m3^2)*cos(2*x(2)-2*x(3))-4*(L1^2)*(L2^2)*(L3^2)*m2*(m3^2)*cos(2*x(2)-2*x(3)))"
expr3 = "0-(2*(32*I1*I2*k3*x(6)-L2*L3*m3*(x(5)^2)*(sin(x(2)-x(3))*(((L2^2)*(m1*m2+4*m1*m3+6*m2*m3+(m2^2))+4*I2*(m1+3*m2+2*m3))*(L1^2)+4*I1*(4*I2+(L2^2)*(m2+4*m3)))+(L1^2)*sin(2*x(1)-x(2)-x(3))*(m2+2*m3)*(4*I2-m2*(L2^2)))-L1*L3*m3*(x(4)^2)*(sin(x(1)-x(3))*(8*I1*(m3*(L2^2)+2*I2)+2*(L1^2)*((m1*m3-(m2^2))*(L2^2)+2*I2*(m1+4*m2+4*m3)))-(L2^2)*sin(x(1)-2*x(2)+x(3))*(m2+2*m3)*((m1+2*m2)*(L1^2)+4*I1))+4*k3*(L1^2)*(L2^2)*(m2^2)*x(6)+16*k3*(L1^2)*(L2^2)*(m3^2)*x(6)+8*I2*k3*(L1^2)*m1*x(6)+8*I1*k3*(L2^2)*m2*x(6)+32*I2*k3*(L1^2)*m2*x(6)+32*I1*k3*(L2^2)*m3*x(6)+32*I2*k3*(L1^2)*m3*x(6)-4*k1*L1*L3*m3*x(4)*(cos(x(1)-x(3))*(2*m3*(L2^2)+4*I2)-(L2^2)*cos(x(1)-2*x(2)+x(3))*(m2+2*m3))-16*I1*I2*g*L3*m3*sin(x(3))-4*I2*(L1^2)*(L3^2)*(m3^2)*(x(6)^2)*sin(2*x(1)-2*x(3))-4*I1*(L2^2)*(L3^2)*(m3^2)*(x(6)^2)*sin(2*x(2)-2*x(3))+8*I2*g*(L1^2)*L3*(m3^2)*sin(2*x(1)-x(3))+8*I1*g*(L2^2)*L3*(m3^2)*sin(2*x(2)-x(3))+2*k3*(L1^2)*(L2^2)*m1*m2*x(6)+8*k3*(L1^2)*(L2^2)*m1*m3*x(6)+24*k3*(L1^2)*(L2^2)*m2*m3*x(6)-4*k2*L2*L3*m3*x(5)*(cos(x(2)-x(3))*((m1+3*m2+2*m3)*(L1^2)+4*I1)-(L1^2)*cos(2*x(1)-x(2)-x(3))*(m2+2*m3))-8*I1*g*(L2^2)*L3*(m3^2)*sin(x(3))-8*I2*g*(L1^2)*L3*(m3^2)*sin(x(3))-4*k3*(L1^2)*(L2^2)*(m2^2)*x(6)*cos(2*x(1)-2*x(2))-16*k3*(L1^2)*(L2^2)*(m3^2)*x(6)*cos(2*x(1)-2*x(2))-8*I2*g*(L1^2)*L3*m2*m3*sin(x(3))-16*k3*(L1^2)*(L2^2)*m2*m3*x(6)*cos(2*x(1)-2*x(2))-(L1^2)*(L2^2)*(L3^2)*m1*(m3^2)*(x(6)^2)*sin(2*x(2)-2*x(3))+(L1^2)*(L2^2)*(L3^2)*m2*(m3^2)*(x(6)^2)*sin(2*x(1)-2*x(3))-2*(L1^2)*(L2^2)*(L3^2)*m2*(m3^2)*(x(6)^2)*sin(2*x(2)-2*x(3))+2*g*(L1^2)*(L2^2)*L3*m1*(m3^2)*sin(2*x(1)-x(3))-g*(L1^2)*(L2^2)*L3*(m2^2)*m3*sin(2*x(1)-x(3))+2*g*(L1^2)*(L2^2)*L3*m2*(m3^2)*sin(2*x(2)-x(3))+g*(L1^2)*(L2^2)*L3*(m2^2)*m3*sin(2*x(2)-x(3))+4*I2*g*(L1^2)*L3*m1*m3*sin(2*x(1)-x(3))+8*I2*g*(L1^2)*L3*m2*m3*sin(2*x(1)-x(3))+4*I1*g*(L2^2)*L3*m2*m3*sin(2*x(2)-x(3))-2*g*(L1^2)*(L2^2)*L3*m1*(m3^2)*sin(2*x(1)-2*x(2)+x(3))-2*g*(L1^2)*(L2^2)*L3*m2*(m3^2)*sin(2*x(1)-2*x(2)+x(3))-g*(L1^2)*(L2^2)*L3*(m2^2)*m3*sin(2*x(1)-2*x(2)+x(3))+g*(L1^2)*(L2^2)*L3*(m2^2)*m3*sin(x(3))-g*(L1^2)*(L2^2)*L3*m1*m2*m3*sin(2*x(1)-2*x(2)+x(3))))/(64*I1*I2*I3+8*I3*(L1^2)*(L2^2)*(m2^2)+8*I1*(L2^2)*(L3^2)*(m3^2)+8*I2*(L1^2)*(L3^2)*(m3^2)+32*I3*(L1^2)*(L2^2)*(m3^2)+16*I2*I3*(L1^2)*m1+16*I1*I3*(L2^2)*m2+64*I2*I3*(L1^2)*m2+16*I1*I2*(L3^2)*m3+64*I1*I3*(L2^2)*m3+64*I2*I3*(L1^2)*m3+4*I3*(L1^2)*(L2^2)*m1*m2+4*I2*(L1^2)*(L3^2)*m1*m3+16*I3*(L1^2)*(L2^2)*m1*m3+4*I1*(L2^2)*(L3^2)*m2*m3+16*I2*(L1^2)*(L3^2)*m2*m3+48*I3*(L1^2)*(L2^2)*m2*m3-8*I1*(L2^2)*(L3^2)*(m3^2)*cos(2*x(2)-2*x(3))-2*(L1^2)*(L2^2)*cos(2*x(1)-2*x(2))*(m2+2*m3)*(m2*m3*(L3^2)+4*I3*(m2+2*m3))-2*(L1^2)*(L3^2)*(m3^2)*cos(2*x(1)-2*x(3))*(4*I2-m2*(L2^2))+2*(L1^2)*(L2^2)*(L3^2)*m1*(m3^2)+6*(L1^2)*(L2^2)*(L3^2)*m2*(m3^2)+2*(L1^2)*(L2^2)*(L3^2)*(m2^2)*m3+(L1^2)*(L2^2)*(L3^2)*m1*m2*m3-2*(L1^2)*(L2^2)*(L3^2)*m1*(m3^2)*cos(2*x(2)-2*x(3))-4*(L1^2)*(L2^2)*(L3^2)*m2*(m3^2)*cos(2*x(2)-2*x(3)))"

pstfix = infixToPostfix(expr1)
print(pstfix)


pstfix_binary =[]

for ele in pstfix:
    if ele ==' ':
        continue
    y=0
    if ele[0] in "0123456789":
        x = int(ele)
        if x==1:
            y+=1
        elif x==2:
            y+=2
        elif x==3:
            y+=3
        elif x==4:
            y+=4
        elif x==6:
            y+=5
        elif x==8:
            y+=6
        elif x==12:
            y+=7
        elif x==16:
            y+=8
        elif x==24:
            y+=9
        elif x==32:
            y+=10
        elif x==48:
            y+=11   
        elif x==64:
            y+=12
    elif ele[0] in "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz":
        if ele[0] == "s" or ele[0] == "c":
            y+=192
            if ele[0]=="c":
                y+=32
            if ele[4:-1] == "2*x(1)-2*x(2)":
                y+=1
            elif ele[4:-1] == "x(1)-x(2)":
                y+=2
            elif ele[4:-1] == "x(1)+x(2)-2*x(3)":
                y+=3
            elif ele[4:-1] == "x(1)-x(3)":
                y+=4
            elif ele[4:-1] == "x(1)-2*x(2)+x(3)":
                y+=5
            elif ele[4:-1] == "x(1)":
                y+=6
            elif ele[4:-1] == "x(1)-2*x(3)":
                y+=7
            elif ele[4:-1] == "2*x(2)-2*x(3)":
                y+=8
            elif ele[4:-1] == "x(1)-2*x(2)":
                y+=9
            elif ele[4:-1] == "x(2)":
                y+=10
            elif ele[4:-1] == "x(2)-x(3)":
                y+=11
            elif ele[4:-1] == "2*x(1)-x(2)-x(3)":
                y+=12
            elif ele[4:-1] == "2*x(1)-x(2)":
                y+=13
            elif ele[4:-1] == "x(2)-2*x(3)":
                y+=14
            elif ele[4:-1] == "2*x(1)+x(2)-2*x(3)":
                y+=15
            elif ele[4:-1] == "x(3)":
                y+=16
            elif ele[4:-1] == "2*x(1)-x(3)":
                y+=17
            elif ele[4:-1] == "2*x(2)-x(3)":
                y+=18
            elif ele[4:-1] == "2*x(1)-2*x(2)+x(3)":
                y+=19                                                         
        elif ele[0]=="x":
            y+=96
            if ele == "x(1)":
                y+=0
            elif ele == "x(2)":
                y+=1
            elif ele == "x(3)":
                y+=2
            elif ele == "x(4)":
                y+=3
            elif ele == "x(5)":
                y+=4
            elif ele == "x(6)":
                y+=5
        else:    
            y += 64   
            if ele == "m2":
                y+=1
            elif ele == "m3":
                y+=2
            elif ele == "L1":
                y+=3
            elif ele == "L2":
                y+=4
            elif ele == "L3":
                y+=5
            elif ele == "I1":
                y+=6
            elif ele == "I2":
                y+=7
            elif ele == "I3":
                y+=8
            elif ele == "k1":
                y+=9
            elif ele == "k2":
                y+=10
            elif ele == "k3":
                y+=11
            elif ele == "g":
                y+=12
    else:
        y += 128
        if ele == "*":
            y+=1
        elif ele == "/":
            y+=2
        elif ele == "+":
            y+=3
        elif ele =="-":
            y+=4
    #print(ele,y)                    
    pstfix_binary.append('{0:02x}'.format(y))

pstfix_binary.append('{0:02x}'.format(255))
# print(pstfix_binary)
sz = len(pstfix_binary)
# print(sz)
for k in range(sz):
    print('10\'b{0:010b}: data <= 8\'h'.format(k)+pstfix_binary[k]+";")
#pf_binary = ''.join(pstfix_binary)
#print(pf_binary) 


