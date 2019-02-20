function triple_pendulum(ivp, duration, fps)

delta=1/fps;
sol = triple_pendulum_ODE(delta, duration, ivp);

nframes=duration*fps;
t = linspace(0,duration,nframes+1);
y=sol(1:nframes+1,:)';
Y=sol(1:nframes+1,1:3)';
figure;
plot(t,Y);
grid on

Y1=Y(1,:);
%Y1 = Y1 - (floor(Y1./(2*pi)).*(2*pi));
Y2=Y(2,:);
%Y2 = Y2 - (floor(Y2./(2*pi)).*(2*pi));
Y3=Y(3,:);
%Y3 = Y3 - (floor(Y3./(2*pi)).*(2*pi));

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
    dlmwrite('key_test.csv',ivp','delimiter',',','-append');
end
       
end

