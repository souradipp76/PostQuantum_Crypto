%  Matrices are defined to store the sample data for x, y, and z
D1=[]; 
D2=[];
D3=[];
D4=[]; 
D5=[];
D6=[];

global m1 m2 m3 L1 L2 L3 k1 k2 k3 I1 I2 I3 g;
m1=0.2944;m2=0.1756;m3=0.0947;
L1=0.508;L2=0.254;L3=0.127;
k1=0.005;k2=0;k3=0.0008;
I1=9.526e-3;I2=1.625e-3;I3=1.848e-4;
g=9.81;

theta1 = -0.4603;
theta2 = -1.2051;
theta3 = -1.5165;
dtheta1 = 0;
dtheta2 = 0;
dtheta3 = 0;

for I = 1:3
    D1=[]; 
    D2=[];
    D3=[];
    D4=[]; 
    D5=[];
    D6=[];
    m1=0.2944;m2=0.1756;m3=0.0947;
    L1=0.508;L2=0.254;L3=0.127;
    k1=0.005;k2=0;k3=0.0008;
    I1=9.526e-3;I2=1.625e-3;I3=1.848e-4;
    g=9.81;
    for m=0.1:0.1:1   
        if I == 1
            m1 = m;
        elseif I == 2
            m2 = m;
        else
            m3 = m;
        end
        uo = [theta1 theta2 theta3 dtheta1 dtheta2 dtheta3];
        tfinal=100;
        tspan=[0 tfinal];
         % Calculation
        options=odeset('InitialStep',1,'MaxStep',1);
        [time, A]=ode45(@odefun,tspan,uo,options);
        %A=triple_pendulum_ODE(0.01,100,[uo m1 m2 m3 L1 L2 L3 k1 k2 k3 I1 I2 I3 g]);
        size(A)
        x=A(:,1);
        y=A(:,2);
        z=A(:,3);
        xbar=A(:,4);
        ybar=A(:,5);
        zbar=A(:,6);

        for i=round(length(x)*3/4):length(x)-1 % i=round(length(x)/2):length(x)-1 
        %for i=2:length(x)-1 % i=round(length(x)/2):length(x)-1
            if((x(i)>=x(i-1))&&(x(i)>=x(i+1)))||((x(i)<=x(i-1))&&(x(i)<=x(i+1)))
              D1=[D1;m x(i)];
            end
            if((y(i)>=y(i-1))&&(y(i)>=y(i+1)))||((y(i)<=y(i-1))&&(y(i)<=y(i+1)))
              D2=[D2;m y(i)];
            end
            if((z(i)>=z(i-1))&&(z(i)>=z(i+1)))||((z(i)<=z(i-1))&&(z(i)<=z(i+1)))
              D3=[D3;m z(i)];
            end
            if((xbar(i)>=xbar(i-1))&&(xbar(i)>=xbar(i+1)))||((xbar(i)<=xbar(i-1))&&(xbar(i)<=xbar(i+1)))
              D4=[D4;m xbar(i)];
            end
            if((ybar(i)>=ybar(i-1))&&(ybar(i)>=ybar(i+1)))||((ybar(i)<=ybar(i-1))&&(ybar(i)<=ybar(i+1)))
              D5=[D5;m ybar(i)];
            end
            if((zbar(i)>=zbar(i-1))&&(zbar(i)>=zbar(i+1)))||((zbar(i)<=zbar(i-1))&&(zbar(i)<=zbar(i+1)))
              D6=[D6;m zbar(i)];
            end
        end
        size(D1)
    end

    if I == 1
        csvwrite('D1_m1.csv',D1);
        csvwrite('D2_m1.csv',D2);
        csvwrite('D3_m1.csv',D3);
        csvwrite('D4_m1.csv',D4);
        csvwrite('D5_m1.csv',D5);
        csvwrite('D6_m1.csv',D6);
    elseif I == 2
        csvwrite('D1_m2.csv',D1);
        csvwrite('D2_m2.csv',D2);
        csvwrite('D3_m2.csv',D3);
        csvwrite('D4_m2.csv',D4);
        csvwrite('D5_m2.csv',D5);
        csvwrite('D6_m2.csv',D6);
    else
        csvwrite('D1_m3.csv',D1);
        csvwrite('D2_m3.csv',D2);
        csvwrite('D3_m3.csv',D3);
        csvwrite('D4_m3.csv',D4);
        csvwrite('D5_m3.csv',D5);
        csvwrite('D6_m3.csv',D6);
    end
    
end

for J = 1:3
    D1=[]; 
    D2=[];
    D3=[];
    D4=[]; 
    D5=[];
    D6=[];
    m1=0.2944;m2=0.1756;m3=0.0947;
    L1=0.508;L2=0.254;L3=0.127;
    k1=0.005;k2=0;k3=0.0008;
    I1=9.526e-3;I2=1.625e-3;I3=1.848e-4;
    g=9.81;
    for L=0.1:0.1:1   
        if J == 1
            L1 = L;
        elseif J == 2
            L2 = L;
        else
            L3 = L;
        end
        uo = [theta1 theta2 theta3 dtheta1 dtheta2 dtheta3];
        tfinal=100;
        tspan=[0 tfinal];
         % Calculation
        options=odeset('InitialStep',1,'MaxStep',1);
        [time, A]=ode45(@odefun,tspan,uo,options);
        %A=triple_pendulum_ODE(0.01,100,[uo m1 m2 m3 L1 L2 L3 k1 k2 k3 I1 I2 I3 g]);
        size(A)
        x=A(:,1);
        y=A(:,2);
        z=A(:,3);
        xbar=A(:,4);
        ybar=A(:,5);
        zbar=A(:,6);

        for i=round(length(x)*3/4):length(x)-1 % i=round(length(x)/2):length(x)-1 
        %for i=2:length(x)-1 % i=round(length(x)/2):length(x)-1
            if((x(i)>=x(i-1))&&(x(i)>=x(i+1)))||((x(i)<=x(i-1))&&(x(i)<=x(i+1)))
              D1=[D1;L x(i)];
            end
            if((y(i)>=y(i-1))&&(y(i)>=y(i+1)))||((y(i)<=y(i-1))&&(y(i)<=y(i+1)))
              D2=[D2;L y(i)];
            end
            if((z(i)>=z(i-1))&&(z(i)>=z(i+1)))||((z(i)<=z(i-1))&&(z(i)<=z(i+1)))
              D3=[D3;L z(i)];
            end
            if((xbar(i)>=xbar(i-1))&&(xbar(i)>=xbar(i+1)))||((xbar(i)<=xbar(i-1))&&(xbar(i)<=xbar(i+1)))
              D4=[D4;L xbar(i)];
            end
            if((ybar(i)>=ybar(i-1))&&(ybar(i)>=ybar(i+1)))||((ybar(i)<=ybar(i-1))&&(ybar(i)<=ybar(i+1)))
              D5=[D5;L ybar(i)];
            end
            if((zbar(i)>=zbar(i-1))&&(zbar(i)>=zbar(i+1)))||((zbar(i)<=zbar(i-1))&&(zbar(i)<=zbar(i+1)))
              D6=[D6;L zbar(i)];
            end
        end
        size(D1)
    end

    if J == 1
        csvwrite('D1_L1.csv',D1);
        csvwrite('D2_L1.csv',D2);
        csvwrite('D3_L1.csv',D3);
        csvwrite('D4_L1.csv',D4);
        csvwrite('D5_L1.csv',D5);
        csvwrite('D6_L1.csv',D6);
    elseif J == 2
        csvwrite('D1_L2.csv',D1);
        csvwrite('D2_L2.csv',D2);
        csvwrite('D3_L2.csv',D3);
        csvwrite('D4_L2.csv',D4);
        csvwrite('D5_L2.csv',D5);
        csvwrite('D6_L2.csv',D6);
    else
        csvwrite('D1_L3.csv',D1);
        csvwrite('D2_L3.csv',D2);
        csvwrite('D3_L3.csv',D3);
        csvwrite('D4_L3.csv',D4);
        csvwrite('D5_L3.csv',D5);
        csvwrite('D6_L3.csv',D6);
    end
    
end

for k = 1:3
    D1=[]; 
    D2=[];
    D3=[];
    D4=[]; 
    D5=[];
    D6=[];
    m1=0.2944;m2=0.1756;m3=0.0947;
    L1=0.508;L2=0.254;L3=0.127;
    k1=0.005;k2=0;k3=0.0008;
    I1=9.526e-3;I2=1.625e-3;I3=1.848e-4;
    g=9.81;
    for K=0.1:0.1:1   
        if k == 1
            k1 = K;
        elseif k == 2
            k2 = K;
        else
            k3 = K;
        end
        uo = [theta1 theta2 theta3 dtheta1 dtheta2 dtheta3];
        tfinal=100;
        tspan=[0 tfinal];
         % Calculation
        options=odeset('InitialStep',1,'MaxStep',1);
        [time, A]=ode45(@odefun,tspan,uo,options);
        %A=triple_pendulum_ODE(0.01,100,[uo m1 m2 m3 L1 L2 L3 k1 k2 k3 I1 I2 I3 g]);
        size(A)
        x=A(:,1);
        y=A(:,2);
        z=A(:,3);
        xbar=A(:,4);
        ybar=A(:,5);
        zbar=A(:,6);

        for i=round(length(x)*3/4):length(x)-1 % i=round(length(x)/2):length(x)-1 
        %for i=2:length(x)-1 % i=round(length(x)/2):length(x)-1
            if((x(i)>=x(i-1))&&(x(i)>=x(i+1)))||((x(i)<=x(i-1))&&(x(i)<=x(i+1)))
              D1=[D1;K x(i)];
            end
            if((y(i)>=y(i-1))&&(y(i)>=y(i+1)))||((y(i)<=y(i-1))&&(y(i)<=y(i+1)))
              D2=[D2;K y(i)];
            end
            if((z(i)>=z(i-1))&&(z(i)>=z(i+1)))||((z(i)<=z(i-1))&&(z(i)<=z(i+1)))
              D3=[D3;K z(i)];
            end
            if((xbar(i)>=xbar(i-1))&&(xbar(i)>=xbar(i+1)))||((xbar(i)<=xbar(i-1))&&(xbar(i)<=xbar(i+1)))
              D4=[D4;K xbar(i)];
            end
            if((ybar(i)>=ybar(i-1))&&(ybar(i)>=ybar(i+1)))||((ybar(i)<=ybar(i-1))&&(ybar(i)<=ybar(i+1)))
              D5=[D5;K ybar(i)];
            end
            if((zbar(i)>=zbar(i-1))&&(zbar(i)>=zbar(i+1)))||((zbar(i)<=zbar(i-1))&&(zbar(i)<=zbar(i+1)))
              D6=[D6;K zbar(i)];
            end
        end
        size(D1)
    end

    if k == 1
        csvwrite('D1_k1.csv',D1);
        csvwrite('D2_k1.csv',D2);
        csvwrite('D3_k1.csv',D3);
        csvwrite('D4_k1.csv',D4);
        csvwrite('D5_k1.csv',D5);
        csvwrite('D6_k1.csv',D6);
    elseif k == 2
        csvwrite('D1_k2.csv',D1);
        csvwrite('D2_k2.csv',D2);
        csvwrite('D3_k2.csv',D3);
        csvwrite('D4_k2.csv',D4);
        csvwrite('D5_k2.csv',D5);
        csvwrite('D6_k2.csv',D6);
    else
        csvwrite('D1_k3.csv',D1);
        csvwrite('D2_k3.csv',D2);
        csvwrite('D3_k3.csv',D3);
        csvwrite('D4_k3.csv',D4);
        csvwrite('D5_k3.csv',D5);
        csvwrite('D6_k3.csv',D6);
    end
    
end

% figure;
% plot(D1(:,1),D1(:,2),'*','MarkerEdgeColor','b','MarkerSize',1)
% set(gcf,'color','w')
% title('Bifur (x,a) detail')
% xlabel('a','FontName', 'Times New Roman','FontSize',14,'FontWeight','bold','Color','k')
% ylabel('x','FontName', 'Times New Roman','FontSize',14,'FontWeight','bold','Color','k')
% 
% figure;
% plot(D2(:,1),D2(:,2),'*','MarkerEdgeColor','b','MarkerSize',1)
% set(gcf,'color','w')
% title('Bifur (y,a) detail')
% xlabel('a','FontName', 'Times New Roman','FontSize',14,'FontWeight','bold','Color','k')
% ylabel('y','FontName', 'Times New Roman','FontSize',14,'FontWeight','bold','Color','k')
% 
% figure;
% plot(D3(:,1),D3(:,2),'*','MarkerEdgeColor','b','MarkerSize',1)
% set(gcf,'color','w')
% title('Bifur (z,a) detail')
% xlabel('a','FontName', 'Times New Roman','FontSize',14,'FontWeight','bold','Color','k')
% ylabel('z','FontName', 'Times New Roman','FontSize',14,'FontWeight','bold','Color','k')
% 
% figure;
% plot(D4(:,1),D4(:,2),'*','MarkerEdgeColor','b','MarkerSize',1)
% set(gcf,'color','w')
% title('Bifur (xbar,a) detail')
% xlabel('a','FontName', 'Times New Roman','FontSize',14,'FontWeight','bold','Color','k')
% ylabel('xbar','FontName', 'Times New Roman','FontSize',14,'FontWeight','bold','Color','k')
% 
% figure;
% plot(D5(:,1),D5(:,2),'*','MarkerEdgeColor','b','MarkerSize',1)
% set(gcf,'color','w')
% title('Bifur (ybar,a) detail')
% xlabel('a','FontName', 'Times New Roman','FontSize',14,'FontWeight','bold','Color','k')
% ylabel('ybar','FontName', 'Times New Roman','FontSize',14,'FontWeight','bold','Color','k')
% 
% figure;
% plot(D6(:,1),D6(:,2),'*','MarkerEdgeColor','b','MarkerSize',1)
% set(gcf,'color','w')
% title('Bifur (zbar,a) detail')
% xlabel('a','FontName', 'Times New Roman','FontSize',14,'FontWeight','bold','Color','k')
% ylabel('zbar','FontName', 'Times New Roman','FontSize',14,'FontWeight','bold','Color','k')

