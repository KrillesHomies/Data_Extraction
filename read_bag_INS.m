%bag = rosbag('Data/2021-03-08-12-53-43.bag')
%bag = rosbag('Data/2021-03-10-10-15-45.bag')
bag = rosbag('Data/2021-03-10-10-13-50.bag')
pressureselect = select(bag, 'topic','/MS5837/pressure');
temperatureselect = select(bag, 'topic','/MS5837/temperature');
imuselect = select(bag, 'topic','/imu/data');
magselect = select(bag, 'topic','/mag');
gps_corr_select = select(bag, 'topic','/gps_corr');
nav_odom_select = select(bag, 'topic','/nav/odom');
nav_status_select = select(bag, 'topic','/nav/status');
filtered_imu_select = select(bag, 'topic','/nav/filtered_imu/data');
gnss1_odom_select = select(bag, 'topic','/gnss1/odom');
gnss1_fix_select = select(bag, 'topic','/gnss1/fix');

pressure_msg = readMessages(pressureselect,'DataFormat','struct');
temperature_msg = readMessages(temperatureselect,'DataFormat','struct');
imu_msg = readMessages(imuselect,'DataFormat','struct');
mag_msg = readMessages(magselect,'DataFormat','struct');
gps_corr_msg = readMessages(gps_corr_select,'DataFormat','struct');
nav_odom_msg = readMessages(nav_odom_select,'DataFormat','struct');
nav_status_msg = readMessages(nav_status_select,'DataFormat','struct');
filtered_imu_msg = readMessages(filtered_imu_select,'DataFormat','struct');
gnss1_odom_msg = readMessages(gnss1_odom_select,'DataFormat','struct');
gnss1_fix_msg = readMessages(gnss1_fix_select,'DataFormat','struct');
%%
pressure = [];
for i=1:size(pressure_msg,1)
    pressure.t(i) = double(pressure_msg{i}.Header.Stamp.Sec) + double(pressure_msg{i}.Header.Stamp.Nsec)*10e-10;
    pressure.FluidPressure(i) = pressure_msg{i}.FluidPressure;
end
plot(pressure.t-min(pressure.t),pressure.FluidPressure')
%%
temp = [];
for i=1:size(temperature_msg,1)
    temp.t(i) = double(temperature_msg{i}.Header.Stamp.Sec) + double(temperature_msg{i}.Header.Stamp.Nsec)*10e-10;
    temp.Temperature(i) = temperature_msg{i}.Temperature_;
end
plot(temp.t-min(temp.t),temp.Temperature')
%%
acc = [];
for i=1:size(imu_msg,1)
    acc.t(i) = double(imu_msg{i}.Header.Stamp.Sec) + double(imu_msg{i}.Header.Stamp.Nsec)*10e-10;
    acc.accX(i) = imu_msg{i}.LinearAcceleration.X;
    acc.accY(i) = imu_msg{i}.LinearAcceleration.Y;
    acc.accZ(i) = imu_msg{i}.LinearAcceleration.Z;
end
plot(acc.t-min(acc.t),acc.accX')
hold on
plot(acc.t-min(acc.t),acc.accY')
plot(acc.t-min(acc.t),acc.accZ')
hold off
%%
ang = [];
for i=1:size(imu_msg,1)
    ang.t(i) = double(imu_msg{i}.Header.Stamp.Sec) + double(imu_msg{i}.Header.Stamp.Nsec)*10e-10;
    ang.angX(i) = imu_msg{i}.AngularVelocity.X;
    ang.angY(i) = imu_msg{i}.AngularVelocity.Y;
    ang.angZ(i) = imu_msg{i}.AngularVelocity.Z;
end
plot(ang.t-min(ang.t),ang.angX')
hold on
plot(ang.t-min(ang.t),ang.angY')
plot(ang.t-min(ang.t),ang.angZ')
hold off
%%
mag = [];
for i=1:size(mag_msg,1)
    mag.t(i) = double(mag_msg{i}.Header.Stamp.Sec) + double(mag_msg{i}.Header.Stamp.Nsec)*10e-10;
    mag.magX(i) = mag_msg{i}.MagneticField.X;
    mag.magY(i) = mag_msg{i}.MagneticField.Y;
    mag.magZ(i) = mag_msg{i}.MagneticField.Z;
end
plot(mag.t-min(mag.t),mag.magX')
hold on
plot(mag.t-min(mag.t),mag.magY')
plot(mag.t-min(mag.t),mag.magZ')
hold off