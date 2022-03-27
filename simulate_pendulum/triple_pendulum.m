function triple_pendulum(ivp, duration, fps, movie)
%clear All; clf;

delta=1/fps;
tspan=0:delta:duration;
%sol=ode45(@triple_pendulum_ODE,tspan, ivp);
sol = triple_pendulum_ODE(delta, duration, ivp);

nframes=duration*fps;
t = linspace(0,duration,nframes+1);
y=sol(1:nframes+1,:)';
Y=sol(1:nframes+1,1:3)';
Y1=Y(1,:);
Y2=Y(2,:);
Y3=Y(3,:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%
figure;
plot(t,Y);
grid on
title('Variation of Angles')
xlabel('Time(t)[seconds]');ylabel('Theta[rad]');
legend('theta1','theta2','theta3')

Y = Y - (floor(Y./(2*pi)).*(2*pi));

figure;
plot(t,Y);
grid on
title('Variation of Normalized Angles')
xlabel('Time(t)[seconds]');ylabel('Theta[rad]');
legend('theta1','theta2','theta3')
   
% figure;
% plot(t,Y(1,:));
% grid on
% figure;
% plot(t,Y(2,:));
% grid on
% figure;
% plot(t,Y(3,:));
% grid on

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
title('Trajectory of Triple Pendulum')
legend('theta1','theta2','theta3')
hold off;
%%%%%%%%%%%%%%%%

% %%%%%%%%%%%%%%%%
% figure;
% hold on;
% xlabel('Frequency(f)[Hz]');ylabel('FFT(Theta)(H)');
% n=length(phi1);
% fshift = (-n/2:n/2-1)*(fps/n);
% f1=fft(phi1);
% f1s=fftshift(f1);
% plot(fshift,abs(f1s));
% f2=fft(phi2);
% f2s=fftshift(f2);
% plot(fshift,abs(f2s));
% f3=fft(phi3);
% f3s=fftshift(f3);
% plot(fshift,abs(f3s));
% grid on
% legend('theta1','theta2','theta3')
% hold off;

%%%%%%%%%%%%%%%
[Pxx1,Fxx1] = periodogram(Y1,hamming(length(Y1)),length(Y1),fps);
[Pxx2,Fxx2] = periodogram(Y2,hamming(length(Y2)),length(Y2),fps);
[Pxx3,Fxx3] = periodogram(Y3,hamming(length(Y3)),length(Y3),fps);
figure;
hold on;
plot(Fxx1,10*log10(Pxx1));
plot(Fxx2,10*log10(Pxx2));
plot(Fxx3,10*log10(Pxx3));
grid on
xlabel('Frequency(f)[Hz]');
ylabel('Power[dB]');
title('Periodogram Power Spectral Density')
legend('theta1','theta2','theta3')
hold off;
% fprintf("Fisher's Kappa Test");
% Y_1 = max(Pxx1);
% Fkappa1 = Y_1./mean(Pxx1(2:end-1))
% Y_2 = max(Pxx2);
% Fkappa2 = Y_2./mean(Pxx2(2:end-1))
% Y_3 = max(Pxx3);
% Fkappa3 = Y_3./mean(Pxx2(2:end-1))
%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%
cir_autocorr1 = ifft(fft(Y1).*conj(fft(Y1)));
cir_autocorr2 = ifft(fft(Y2).*conj(fft(Y2)));
cir_autocorr3 = ifft(fft(Y3).*conj(fft(Y3)));
figure;
plot(cir_autocorr1);
grid on;
xlabel('Frequency(f)[Hz]');
ylabel('Power[dB]');
title('Circular AutoCorrelation of Theta_1');

figure;
plot(cir_autocorr2);
grid on;
xlabel('Frequency(f)[Hz]');
ylabel('Power[dB]');
title('Circular AutoCorrelation of Theta_2');

figure;
plot(cir_autocorr3);
grid on
xlabel('Frequency(f)[Hz]');
ylabel('Power[dB]');
title('Circular AutoCorrelation of Theta_3');
%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%
Z1 = fft(Y1);
N = length(Z1);
Z1(1) = [];
power1 = abs(Z1(1:floor(N/2))).^2;
Z2 = fft(Y2);
Z2(1) = [];
power2 = abs(Z2(1:floor(N/2))).^2;
Z3 = fft(Y3);
Z3(1) = [];
power3 = abs(Z3(1:floor(N/2))).^2;
nyquist = 1/2;
freq = (1:floor(N/2))/floor(N/2)*nyquist;
periodLength = 'second'; %or whatever units your signal was acquired in.
period = 1./freq;

figure;
plot(period,power1);
grid on;
ylabel('Power')
xlabel(['Period (' periodLength 's/Cycle)']);
title('Period Plot of Theta_1');

figure;
plot(period,power2);
grid on;
ylabel('Power')
xlabel(['Period (' periodLength 's/Cycle)']);
title('Period Plot of Theta_2');

figure;
plot(period,power3);
grid on;
ylabel('Power')
xlabel(['Period (' periodLength 's/Cycle)']);
title('Period Plot of Theta_3');
%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5555
% 
% [pval1, fMax1] = test_periodicity(Y1);
% [pval2, fMax2] = test_periodicity(Y2);
% [pval3, fMax3] = test_periodicity(Y3);

% eps=0.0005;
% if fMax1>eps||fMax2>eps||fMax3>eps
%     fprintf("%f,%f,%f->Periodic\n",fMax1,fMax2,fMax3);
% else
% %     fprintf("%f,%f,%f->Not Periodic\n",fMax1,fMax2,fMax3);
% %     if exist('keyset.mat', 'file') == 2
% %         fprintf('Appending..');
% %         save('keyset.mat','ivp','-append');
% %     else
% %         save('keyset.mat','ivp');
% %     end
% %     dlmwrite('test.csv',ivp','delimiter',',','-append');
% end

figure;
h=plot(0,0,'MarkerSize',30,'Marker','.','LineWidth',2);
range=1.1*(l1+l2+l3); axis([-range range -range range]); axis square;
set(gca, {'YDir'}, {'reverse'});
set(gca,'nextplot','replacechildren');
    for i=1:length(phi1)-1
        if (ishandle(h)==1)
            Xcoord=[0,l1*sin(phi1(i)),l1*sin(phi1(i))+l2*sin(phi2(i)),l1*sin(phi1(i))+l2*sin(phi2(i))+l3*sin(phi3(i))];
            Ycoord=[0,-l1*cos(phi1(i)),-l1*cos(phi1(i))-l2*cos(phi2(i)),-l1*cos(phi1(i))-l2*cos(phi2(i))-l3*cos(phi3(i))];
            set(h,'XData',Xcoord,'YData',Ycoord);
            drawnow;
            F(i) = getframe;
            if movie==false
                pause(t(i+1)-t(i));
            end
        end
    end
    if movie==true
        movie2avi(F,'doublePendulumAnimation.avi','compression','Cinepak','fps',fps)
    end
       
end

