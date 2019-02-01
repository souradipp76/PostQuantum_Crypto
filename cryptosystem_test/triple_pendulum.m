function Y = triple_pendulum(ivp, duration, fps)

delta=1/fps;
tspan=0:delta:duration;
%sol=ode45(@triple_pendulum_ODE,tspan, ivp);
sol = triple_pendulum_ODE(delta, duration, ivp);

nframes=duration*fps;
t = linspace(0,duration,nframes+1);
y=sol(1:nframes+1,:)';
Y=sol(1:nframes+1,1:3)';

Y = Y - (floor(Y./(2*pi)).*(2*pi));

Y1=Y(1,:);
Y2=Y(2,:);
Y3=Y(3,:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%
figure;
plot(t,Y3);
grid on
xlabel('Time(t)[seconds]');ylabel('Theta[rad]');
%legend('theta1','theta2','theta3')

phi1=y(1,:)'; dtphi1=y(4,:)';
phi2=y(2,:)'; dtphi2=y(5,:)';
phi3=y(3,:)'; dtphi3=y(6,:)';
l1=ivp(10); l2=ivp(11); l3=ivp(12);

figure;
hold on;
xlabel('X');ylabel('Y');
axis ij;
grid on
plot(l1*sin(phi1),-l1*cos(phi1));
plot(l1*sin(phi1)+l2*sin(phi2),-l1*cos(phi1)-l2*cos(phi2));
plot(l1*sin(phi1)+l2*sin(phi2)+l3*sin(phi3),-l1*cos(phi1)-l2*cos(phi2)-l3*cos(phi3));
legend('theta1','theta2','theta3')
hold off;
%%%%%%%%%%%%%%%%

       
end

