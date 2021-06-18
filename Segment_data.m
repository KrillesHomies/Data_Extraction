%% The scripts cuts the data into segments for the extended kalman filter
% These segments can then be used in the Kalman filter 
% Typically the best results come cutting with a bit of margin
% Each segment is given in relative time starting 0 and in a local tangent
% plane. The reference time (in WEEK,TOW) and position (inlong lat h) can
% be found in Data_N.ReferensStart
%
% The data files are given from the funtion for combining the INS data with
% the ROS data

close all; clear all;
addpath(genpath('Processed_Data'))

% Name of file to load
input_file_name = '2021-04-28_40m_3f.mat';
% Name of file that is saved
output_file_name = 'test.mat';

load(input_file_name)
plot(Data.pressure.pressure);
xlabel('Samples')
xlabel('Pressure')
%% Pick place to cut based on pressure data sample
% Cut = [3500 15000];
%Cut = [2000 5600];

%Cut = [33590 47065];
% Cut = [32000 51000];
% Cut = [58000 70500];
%Cut = [5600 9000];
%Cut = [60000 70000];
%Cut = [30200 50200];
% Cut = [9200 11600];

Cut = [33590 47065];
Cut = [16500 30000];
% Cut = [3500 15000];

%% Extract Pressure Data
Data_N = [];
Data_N.pressure.t = Data.pressure.time.TOW(Cut(1):Cut(2));
Data_N.pressure.press = Data.pressure.pressure(Cut(1):Cut(2));

start_Time = Data_N.pressure.t(1);
end_time = Data_N.pressure.t(end);
Data_N.pressure.t = Data_N.pressure.t - start_Time;

%% Extract EKF Data
[~,i_start_EKF] = min(abs(Data.EKF.time.TOW - start_Time));
[~,i_stop_EKF] = min(abs(Data.EKF.time.TOW - end_time));
Data_N.EKF.t = Data.EKF.time.TOW(i_start_EKF:i_stop_EKF)-start_Time;


Data_N.EKF.ACCB = Data.EKF.ACCB(:,i_start_EKF:i_stop_EKF);
Data_N.EKF.ACCBunc = Data.EKF.ACCBunc(:,i_start_EKF:i_stop_EKF);
Data_N.EKF.ACCSF = Data.EKF.ACCSF(:,i_start_EKF:i_stop_EKF);
Data_N.EKF.ACCSFunc = Data.EKF.ACCSFunc(:,i_start_EKF:i_stop_EKF);

Data_N.EKF.GYROB = Data.EKF.GYROB(:,i_start_EKF:i_stop_EKF);
Data_N.EKF.GYROBunc = Data.EKF.GYROBunc(:,i_start_EKF:i_stop_EKF);
Data_N.EKF.GYROSF = Data.EKF.GYROSF(:,i_start_EKF:i_stop_EKF);
Data_N.EKF.GYROSFunc = Data.EKF.GYROSFunc(:,i_start_EKF:i_stop_EKF);

wgs84 = wgs84Ellipsoid('meters');
lat = Data.EKF.GEO(1,i_start_EKF:i_stop_EKF);
lon = Data.EKF.GEO(2,i_start_EKF:i_stop_EKF);
h =  Data.EKF.GEO(3,i_start_EKF:i_stop_EKF);
lat0 = lat(1);
lon0 = lon(1);
h0 = h(1);
Data_N.ReferensStart.lat = lat0;
Data_N.ReferensStart.lon = lon0;
Data_N.ReferensStart.h = h0;
Data_N.ReferensStart.Week = Data.pressure.time.Week;
Data_N.ReferensStart.Tow = Data.pressure.time.TOW(Cut(1));
[x,y,z] = geodetic2ned(lat,lon,h,lat0,lon0,h0,wgs84);
Data_N.EKF.POS = [x; y; z];
Data_N.EKF.POSunc = Data.EKF.GEOunc(:,i_start_EKF:i_stop_EKF);

Data_N.EKF.Vel = Data.EKF.Vel(:,i_start_EKF:i_stop_EKF);
Data_N.EKF.Velunc = Data.EKF.Velunc(:,i_start_EKF:i_stop_EKF);
Data_N.EKF.ORIq = Data.EKF.ORIq(:,i_start_EKF:i_stop_EKF);
Data_N.EKF.ORIunc = Data.EKF.ORIunc(:,i_start_EKF:i_stop_EKF);

Data_N.EKF.EARTH_MAGNETIC_VEC= Data.EKF.MAG_VEC_MOD(:,i_start_EKF:i_stop_EKF);
Data_N.EKF.GRAVITY = Data.EKF.GRAVITY(i_start_EKF:i_stop_EKF);

% Find GPS time stamp
[~,i_start_gps] = min(abs(Data.GNSS.time.TOW - start_Time));
[~,i_stop_gps] = min(abs(Data.GNSS.time.TOW - end_time));

Data_N.GNSS.t = Data.GNSS.time.TOW(i_start_gps:i_stop_gps) - start_Time;
% Transform GPS to ECEF system
lat =  Data.GNSS.GEO(1,i_start_gps:i_stop_gps);
lon =  Data.GNSS.GEO(2,i_start_gps:i_stop_gps);
h =  Data.GNSS.ELLIP(1,i_start_gps:i_stop_gps);
[x,y,z] = geodetic2ned(lat,lon,h,lat0,lon0,h0,wgs84);

Data_N.GNSS.pos = [x; y; z];
Data_N.GNSS.accuracy = Data.GNSS.ACC(:,i_start_gps:i_stop_gps);

% Find IMU time stamp
[~,i_start_imu] = min(abs(Data.IMU.time.TOW - start_Time));
[~,i_stop_imu] = min(abs(Data.IMU.time.TOW - end_time));

Data_N.IMU.t = Data.IMU.time.TOW(i_start_imu:i_stop_imu) - start_Time;
g = 9.80665;
Data_N.IMU.acc = Data.IMU.acc(:,i_start_imu:i_stop_imu) * 9.80665;
Data_N.IMU.gyro = Data.IMU.gyro(:,i_start_imu:i_stop_imu);
Data_N.IMU.mag = Data.IMU.mag(:,i_start_imu:i_stop_imu);
Data_N.IMU.CF = Data.IMU.CF(:,i_start_imu:i_stop_imu);

save(['segmented_Data/' output_file_name],'Data');

%% Add NILUS data according to GPS time stamp % uncomment if nilus data is also used

% load('NILUS_Data_20210428.mat') 
% NILUS_Data_20210428.time = (3 + mod(datenum(NILUS_Data_20210428.time),1))*86400; 
% [~,i_start_NILUS] = min(abs(NILUS_Data_20210428.time - start_Time));
% [~,i_stop_NILUS] = min(abs(NILUS_Data_20210428.time- end_time));
% Data_N.NILUS = NILUS_Data_20210428(i_start_NILUS:i_stop_NILUS,:);
% Data_N.NILUS.position_raw = cell2mat(Data_N.NILUS.position_raw')';
% Data_N.NILUS.position = cell2mat(Data_N.NILUS.position')';
% Data_N.NILUS.time = NILUS_Data_20210428.time(i_start_NILUS:i_stop_NILUS,:) - start_Time;
% [x,y,z] = geodetic2ned(Data_N.NILUS.position_raw(:,1),Data_N.NILUS.position_raw(:,2),ones(size(Data_N.NILUS.position_raw,1),1)*h0,lat0,lon0,h0,wgs84);
% Data_N.NILUS.position_raw_local = [x,y,z];
% [x,y,z] = geodetic2ned(Data_N.NILUS.position(:,1),Data_N.NILUS.position(:,2),ones(size(Data_N.NILUS.position,1),1)*h0,lat0,lon0,h0,wgs84);
% Data_N.NILUS.position_local = [x,y,z];
% Data_N.NILUS.gps_state = ismember(cell2mat(Data_N.NILUS.gps_state),"3d_fix");


