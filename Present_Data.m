

settings = get_settings_pool();
settings.g = -[0 0 9.8184];
settings.window_size = 20;
settings.p = 1004;
% [T, ZUPT] = ZUPT_CAL([Data.IMU.acc; Data.IMU.gyro],settings,'GLRT');
% 
% 
% figure(1)
% plot(Data.IMU.t,T(1:end-1))
% xlabel('Time')
% ylabel('Value')
% title('Zero Velocity Detection')
%%

figure(2)
plot(Data.pressure.time.TOW,(Data.pressure.pressure - min(Data.pressure.pressure))*100/settings.p/norm(settings.g))
xlabel('Time')
ylabel('Depth')
title('Depth estimate from Pressure sensor')

figure(3)
plot(Data.temperature.time.TOW,Data.temperature.temperature)
xlabel('Time')
ylabel('Temp')
title('Tempreture  from Pressure sensor')

figure(5)
plot(Data.EKF.time.TOW,Data.EKF.HARDIRON_OFF)
xlabel('Time')
ylabel('Value')
title('Hard Iron Offsets')

figure(6)
plot(Data.EKF.time.TOW,Data.EKF.GEOunc)
xlabel('Time')
ylabel('Uncertainity')
title('Position Uncertainity (according to filter)')

%[S,H,V] = magcal(Data.IMU.mag');
%mag = (((Data.IMU.mag')*buffer(Data.EKF.SOFTIRON(:,end),[3])  - Data.EKF.HARDIRON_OFF(:,end)'));
mag = (Data.IMU.mag' - H)*S;
figure(7)
h(1) = scatter3(mag(:,1),mag(:,2),mag(:,3))
hold on
h(2) = scatter3(Data.IMU.mag(1,:),Data.IMU.mag(2,:),Data.IMU.mag(3,:))
hold off
title('Magnetometer Data')
xlabel('X')
ylabel('Y')
zlabel('Z')
legend(h,{'Mag ','Mag Uncalibrated'})

figure(4)
plot(Data.IMU.time.TOW,sqrt(sum(Data.IMU.mag.^2)))
xlabel('Time')
ylabel('intensity')
title('Uncalibrated Mag intensity')

figure(9)
plot(Data.IMU.time.TOW,sqrt(sum(mag.^2,2)))
xlabel('Time')
ylabel('Mag intensity')
title('Calibrated Mag intensity')

