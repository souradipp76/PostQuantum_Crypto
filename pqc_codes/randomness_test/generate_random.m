clc;
clear;

sym theta

duration=6.5535;
tspan = [0 duration];

m1=0.2944;m2=0.1756;m3=0.0947;
l1=0.508;l2=0.254;l3=0.127;
k1=0.005;k2=0;k3=0.0008;
I1=9.526e-3;I2=1.625e-3;I3=1.848e-4;
g=9.81;

l1 = l1+0.127;l2 = l2+0.127;
params=[m1,m2,m3,l1,l2,l3,I1,I2,I3,k1,k2,k3,g];

theta1 = 2*pi-0.4603;
theta2 = 2*pi-1.2051;
theta3 = 2*pi-1.5165;
dtheta1 = 0;
dtheta2 = 0;
dtheta3 = 0;
fps = 10000;
movie = false;

iniCon = [theta1; theta2; theta3; dtheta1; dtheta2; dtheta3];
ivp = [iniCon;params'];

triple_pendulum(ivp, duration, fps);
