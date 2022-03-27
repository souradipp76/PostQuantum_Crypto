function Y3 = triple_pendulum(ivp, duration, fps)

delta=1/fps;
sol = triple_pendulum_ODE(delta, duration, ivp);

nframes=duration*fps;
t = linspace(0,duration,nframes+1);
y=sol(1:nframes+1,:)';
Y=sol(1:nframes+1,1:3)';

figure;
plot(t,Y);
grid on
xlabel('Time(t)[seconds]');ylabel('Theta[rad]');
legend('theta1','theta2','theta3')

%%%%%%%%%%%%%%%%%%%%%%%
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
pause;
%%%%%%%%%%%%%%%%%%%



Y = Y - (floor(Y./(2*pi)).*(2*pi));
figure;
plot(t,Y(3,:));
grid on
pause;

Y1=Y(1,:);
Y2=Y(2,:);
Y3=Y(3,:);
Y1 = Y1 - (floor(Y1./(2*pi)).*(2*pi));
Y2 = Y2 - (floor(Y2./(2*pi)).*(2*pi));
Y3 = Y3 - (floor(Y3./(2*pi)).*(2*pi));

[pval1, fMax1] = test_periodicity(Y1);
[pval2, fMax2] = test_periodicity(Y2);
[pval3, fMax3] = test_periodicity(Y3);

% figure;
% plot(t,Y1,Y2,Y3);
% grid on
pause

eps=0.0005;
if fMax1>eps||fMax2>eps||fMax3>eps
    fprintf("%f,%f,%f->Periodic\n",fMax1,fMax2,fMax3);
else
    fprintf("%f,%f,%f->Not Periodic\n",fMax1,fMax2,fMax3);
    num_chars = 256;
    epsilon = (max(Y3)- min(Y3))/num_chars;
    
    intervals = {};
    flag = 1;
    for i=1:num_chars
        possibles = [];
        for j=1:length(Y3)
            if ((Y3(j)>=min(Y3)+(i-1)*epsilon) && (Y3(j)<min(Y3)+i*epsilon))
                possibles = [possibles,j];
            end
        end
        if isempty(possibles)
            flag = 0;
            fprintf("%d\n",i);
            break;
        end
        intervals{end+1} = possibles;
    end
    if flag == 1
        fprintf("Accepted\n");
        key_list = [ivp',duration,delta,min(Y3),1/epsilon];
        dlmwrite('key_test.csv',key_list,'delimiter',',','-append');
    end
end
       
end

