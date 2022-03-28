clc;
clear;
theta1 = -0.4603;
theta2 = -1.2051;
theta3 = -1.5165;
dtheta1 = 0;
dtheta2 = 0;
dtheta3 = 0;
iv = [theta1 theta2 theta3 dtheta1 dtheta2 dtheta3];
% [T,Res]=lyapunov(3,@lorenz_ext,@ode45,0,0.5,200,[0 1 0],10);
[T,Res]=lyapunov(6,@lorenz_ext,@ode45,0,0.1,10,iv,10);
plot(T,Res);
title('Dynamics of Lyapunov exponents');
xlabel('Time'); ylabel('Lyapunov exponents');
