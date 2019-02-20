clc
clear

sym theta

duration=10;
tspan = [0 duration];


M = [-0.05:0.01:0.1];
L = [0:0.127:1];
K = [0:0.001:0.01];

m1=0.2944;m2=0.1765;m3=0.0947;
l1=0.508;l2=0.254;l3=0.127;
k1=0.005;k2=0;k3=0.0008;
I1=9.526e-3;I2=1.625e-3;I3=1.848e-4;
g=9.81;

for i1=1:length(M)
    for i2=1:length(M)
        for i3=1:length(M)
            for j1=1:length(L)
                for j2=1:length(L)
                    for j3=1:length(L)
                        %for r1=1:length(K)
                            %for r2=1:length(K)
                                %for r3=1:length(K)
                                    m1 = m1+M(i1);m2 = m2+M(i2);m3 = m3+M(i3);
                                    l1 = l1+L(j1);l2 = l2+L(j2);l3 = l3+L(j3);
                                    %k1 = k1+K(r1);k2 = k2+K(r2);k3 = k3+K(r3);
                                    I1 = (m1*l1^2)/3;I2 = (m2*l2^2)/3;I3 = (m3*l3^2)/3;
                                    %if(m1>=0&&m2>=0&&m3>=0&&l1>=0&&l2>=0&&l3>=0&&k1>=0&&k2>=0&&k3>=0)
                                        params=[m1,m2,m3,l1,l2,l3,I1,I2,I3,k1,k2,k3,g];
                                        theta1 = -0.4603;
                                        theta2 = -1.2051;
                                        theta3 = -1.5165;
                                        dtheta1 = 0;
                                        dtheta2 = 0;
                                        dtheta3 = 0;
                                        fps = 1000;

                                        iniCon = [theta1; theta2; theta3; dtheta1; dtheta2; dtheta3];
                                        ivp = [iniCon;params'];
                                        triple_pendulum(ivp, duration, fps);
                                    % end
                                %end
                            %end
                        %end
                    end
                end
            end
        end
    end
end