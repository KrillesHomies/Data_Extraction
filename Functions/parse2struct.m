function [Data] = parse2struct(name)
% name = 'Data/bro_F1.bag'
% Extracts Data from a bag file into a readable format
bag = rosbag(name);
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
gnss1_time_ref_select = select(bag, 'topic','/gnss1/time_ref');

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
gnss1_time_ref_msg = readMessages(gnss1_time_ref_select,'DataFormat','struct');

Data = [];
%%
for i=1:size(pressure_msg,1)
    Data.RAW.pressure.t(i) = double(pressure_msg{i}.Header.Stamp.Sec) + double(pressure_msg{i}.Header.Stamp.Nsec)*10e-10;
    Data.RAW.pressure.FluidPressure(i) = pressure_msg{i}.FluidPressure;
end
for i=1:size(temperature_msg,1)
    Data.RAW.temp.t(i) = double(temperature_msg{i}.Header.Stamp.Sec) + double(temperature_msg{i}.Header.Stamp.Nsec)*10e-10;
    Data.RAW.temp.Temperature(i) = temperature_msg{i}.Temperature_;
end
for i=1:size(imu_msg,1)
    Data.RAW.IMU.t(i) = double(imu_msg{i}.Header.Stamp.Sec) + double(imu_msg{i}.Header.Stamp.Nsec)*10e-10;
    Data.RAW.IMU.acc(:,i) = [imu_msg{i}.LinearAcceleration.X; imu_msg{i}.LinearAcceleration.Y; imu_msg{i}.LinearAcceleration.Z];
    Data.RAW.IMU.ang(:,i) = [imu_msg{i}.AngularVelocity.X; imu_msg{i}.AngularVelocity.Y; imu_msg{i}.AngularVelocity.Z];
end
for i=1:size(mag_msg,1)
    Data.RAW.mag.t(i) = double(mag_msg{i}.Header.Stamp.Sec) + double(mag_msg{i}.Header.Stamp.Nsec)*10e-10;
    Data.RAW.mag.mag(:,i) = [mag_msg{i}.MagneticField.X; mag_msg{i}.MagneticField.Y; mag_msg{i}.MagneticField.Z];
end
for i=1:size(gnss1_fix_msg,1)
    Data.RAW.GNSS.t(i) = double(gnss1_fix_msg{i}.Header.Stamp.Sec) + double(gnss1_fix_msg{i}.Header.Stamp.Nsec)*10e-10;
    Data.RAW.GNSS.POS(:,i) = [gnss1_fix_msg{i}.Latitude; gnss1_fix_msg{i}.Longitude; gnss1_fix_msg{i}.Altitude];
    Data.RAW.GNSS.HDOP(i) = gnss1_fix_msg{i}.PositionCovariance(1);
    Data.RAW.GNSS.VDOP(i) = gnss1_fix_msg{i}.PositionCovariance(9);
end
for i=1:size(nav_odom_msg,1)
    Data.FILT.state.t(i) = double(nav_odom_msg{i}.Header.Stamp.Sec) + double(nav_odom_msg{i}.Header.Stamp.Nsec)*10e-10;
    Data.FILT.state.POS(:,i) = [nav_odom_msg{i}.Pose.Pose.Position.X; nav_odom_msg{i}.Pose.Pose.Position.Y; nav_odom_msg{i}.Pose.Pose.Position.Z];
    Data.FILT.state.ORI(:,i) = [nav_odom_msg{i}.Pose.Pose.Orientation.X; nav_odom_msg{i}.Pose.Pose.Orientation.Y; nav_odom_msg{i}.Pose.Pose.Orientation.Z; nav_odom_msg{i}.Pose.Pose.Orientation.W];
    Data.FILT.state.LIN_VEL(:,i) = [nav_odom_msg{i}.Twist.Twist.Linear.X; nav_odom_msg{i}.Twist.Twist.Linear.Y; nav_odom_msg{i}.Twist.Twist.Linear.Z];
    Data.FILT.state.ANG_VEL(:,i) = [nav_odom_msg{i}.Twist.Twist.Angular.X; nav_odom_msg{i}.Twist.Twist.Angular.Y; nav_odom_msg{i}.Twist.Twist.Angular.Z];
end
for i=1:size(filtered_imu_msg,1)
    Data.FILT.IMU.t(i) = double(filtered_imu_msg{i}.Header.Stamp.Sec) + double(filtered_imu_msg{i}.Header.Stamp.Nsec)*10e-10;
    Data.FILT.IMU.acc(:,i) = [filtered_imu_msg{i}.LinearAcceleration.X; filtered_imu_msg{i}.LinearAcceleration.Y; filtered_imu_msg{i}.LinearAcceleration.Z];
    Data.FILT.IMU.ang(:,i) = [filtered_imu_msg{i}.AngularVelocity.X; filtered_imu_msg{i}.AngularVelocity.Y; filtered_imu_msg{i}.AngularVelocity.Z];
end
for i=1:size(gnss1_time_ref_msg,1)
    Data.GPS_TIME.system_time(i) = double(gnss1_time_ref_msg{i}.Header.Stamp.Sec) + double(gnss1_time_ref_msg{i}.Header.Stamp.Nsec)*10e-10;
    Data.GPS_TIME.gps_time(i) = double(gnss1_time_ref_msg{i}.TimeRef.Sec) + double(gnss1_time_ref_msg{i}.TimeRef.Nsec)*10e-10;
end
for i=1:size(gps_corr_msg,1)
    Data.GPS_corr.system_time(i) = double(gps_corr_msg{i}.Header.Stamp.Sec) + double(gps_corr_msg{i}.Header.Stamp.Nsec)*10e-10;
    Data.GPS_corr.TOW(i) = gps_corr_msg{i}.GpsCor.GpsTow;
    Data.GPS_corr.WEEK(i) = gps_corr_msg{i}.GpsCor.GpsWeekNumber;
end
end