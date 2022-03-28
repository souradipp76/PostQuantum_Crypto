function Y = triple_pendulum(ivp, duration, fps)
delta=1/fps;
tspan=0:delta:duration;

%%%%%%%%%%%%% Regular Solver %%%%%%%%%%
sol = triple_pendulum_ODE(delta, duration, ivp);

%%%%%% ODE solver %%%%%%%
% uo = [ivp(1,1) ivp(2,1) ivp(3,1) ivp(4,1) ivp(5,1) ivp(6,1)];
% global m1 m2 m3 L1 L2 L3 k1 k2 k3 I1 I2 I3 g;
% m1=ivp(7,1);m2=ivp(8,1);m3=ivp(9,1);
% L1=ivp(10,1);L2=ivp(11,1);L3=ivp(12,1);
% k1=ivp(13,1);k2=ivp(14,1);k3=ivp(15,1);
% I1=ivp(16,1);I2=ivp(17,1);I3=ivp(18,1);
% g=ivp(19,1);
% tfinal=duration*1000;
% tspan=[0 tfinal];
%  % Calculation
% options=odeset('InitialStep',1,'MaxStep',1);
% [time, A]=ode45(@odefun,tspan,uo,options);
% sol = A';      
        
        
nframes=duration*fps;
t = linspace(0,duration,nframes+1);
y=sol(1:nframes+1,:)';
Y=sol(1:nframes+1,1:3)';

csvwrite('theta.csv',y);

% yn = y - (floor(y./(2*pi)).*(2*pi)); 
% Y = Y - (floor(Y./(2*pi)).*(2*pi));

yn = mod(y, 2*pi);
Y = mod(y, 2*pi);

csvwrite('theta_norm.csv',yn);
Y1=Y(1,:);
Y2=Y(2,:);
Y3=Y(3,:);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%
figure;
grid on;
hold on;
plot(t,Y1);
plot(t,Y2);
plot(t,Y3);
xlabel('Time(t)[seconds]');ylabel('Theta[rad]');
legend('theta1','theta2','theta3')
hold off;


% phi1=y(1,:)'; dtphi1=y(4,:)';
% phi2=y(2,:)'; dtphi2=y(5,:)';
% phi3=y(3,:)'; dtphi3=y(6,:)';
% l1=ivp(10); l2=ivp(11); l3=ivp(12);

% figure;
% hold on;
% xlabel('X');ylabel('Y');
% axis ij;
% grid on
% plot(l1*sin(phi1),-l1*cos(phi1));
% plot(l1*sin(phi1)+l2*sin(phi2),-l1*cos(phi1)-l2*cos(phi2));
% plot(l1*sin(phi1)+l2*sin(phi2)+l3*sin(phi3),-l1*cos(phi1)-l2*cos(phi2)-l3*cos(phi3));
% legend('theta1','theta2','theta3')
% hold off;
%%%%%%%%%%%%%%%

       
end

