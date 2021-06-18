% Extracts the Data recorded by the sensors
% Inertial Sensor UTils should be used first to extract the data from the bin file
clear all; 
%% File names, 1 bag file and 3 csv files 

name_bin = '2021-04-28_40m_3f';
name_bag = '2021-04-28_40m_3f' 
name_output = '2021-04-28_40m_3f' 
bagfile = ['Data/' name_bag '.bag']; 
bin_EKF_file = ['Data/' name_bin '_EKF_Log.csv']; % EKF file
bin_GPS_file = ['Data/' name_bin '_GPS_Log.csv']; % GPS file
bin_IMU_file = ['Data/' name_bin '_IMU_Log.csv']; % IMU File

%% Import Data from files
Data_bag = parse2struct(bagfile);
Data_bin.EKF = import_EKF_bin(bin_EKF_file);
Data_bin.IMU = import_IMU_bin(bin_IMU_file); 
Data_bin.GPS = import_GPS_bin(bin_GPS_file);
%% Extract to 'Data' variable
Data.IMU.time.Week = Data_bin.IMU.IMUWeek;
Data.IMU.time.TOW = Data_bin.IMU.IMUTOW;
Data.IMU.acc = [Data_bin.IMU.XAccelx8004 Data_bin.IMU.YAccelx8004 Data_bin.IMU.ZAccelx8004]';
Data.IMU.gyro = [Data_bin.IMU.XGyrox8005 Data_bin.IMU.YGyrox8005 Data_bin.IMU.ZGyrox8005]';
Data.IMU.mag = [Data_bin.IMU.XMagx8006 Data_bin.IMU.YMagx8006 Data_bin.IMU.ZMagx8006]';
Data.IMU.CF =  [Data_bin.IMU.CFQ0x800A Data_bin.IMU.CFQ1x800A Data_bin.IMU.CFQ2x800A Data_bin.IMU.CFQ3x800A]';

%Data.GNSS.GEO
Data.GNSS.time.Week  = Data_bin.GPS.GPSWeek;
Data.GNSS.time.TOW = Data_bin.GPS.GPSTOW;
Data.GNSS.GEO = [Data_bin.GPS.Latx8103 Data_bin.GPS.Lonx8103]';
Data.GNSS.ELLIP =  Data_bin.GPS.HtAbvEllipsx8103';
Data.GNSS.MSL =  Data_bin.GPS.MSLHeightx8103';
Data.GNSS.ACC = [Data_bin.GPS.HorzAccx8103 Data_bin.GPS.VertAccx8103]';

Data.EKF.time.Week  = Data_bin.EKF.EKFWeek;
Data.EKF.time.TOW  = Data_bin.EKF.EKFTOW;
Data.EKF.GEO = [Data_bin.EKF.Latx8201 Data_bin.EKF.Lonx8201 Data_bin.EKF.HtAbvEllipsx8201]';
Data.EKF.GEOunc = [Data_bin.EKF.LLHUCNx8208 Data_bin.EKF.LLHUCEx8208 Data_bin.EKF.LLHUCDx8208]';

Data.EKF.GRAVITY =  Data_bin.EKF.WGS84Gravityx820F;

Data.EKF.Vel = [Data_bin.EKF.VelNx8202 Data_bin.EKF.VelEx8202 Data_bin.EKF.VelDx8202]';
Data.EKF.Velunc = [Data_bin.EKF.VelUCNx8209 Data_bin.EKF.VelUCEx8209 Data_bin.EKF.VelUCDx8209]';

Data.EKF.ORIq = [Data_bin.EKF.q0x8203 Data_bin.EKF.q1x8203 Data_bin.EKF.q2x8203 Data_bin.EKF.q3x8203]';
Data.EKF.ORIunc = [Data_bin.EKF.RollUCx820A Data_bin.EKF.PitchUCx820A Data_bin.EKF.YawUCx820A]';

Data.EKF.ACCB = [Data_bin.EKF.XAccBiasx8207 Data_bin.EKF.YAccBiasx8207 Data_bin.EKF.ZAccBiasx8207]';
Data.EKF.ACCBunc = [Data_bin.EKF.XAccBiasUCx820C Data_bin.EKF.YAccBiasUCx820C Data_bin.EKF.ZAccBiasUCx820C]';
Data.EKF.ACCSF = [Data_bin.EKF.XAccSFx8217 Data_bin.EKF.YAccSFx8217 Data_bin.EKF.ZAccSFx8217]';
Data.EKF.ACCSFunc = [Data_bin.EKF.XAccSFUCx8219 Data_bin.EKF.YAccSFUCx8219 Data_bin.EKF.ZAccSFUCx8219]';

Data.EKF.GYROB = [Data_bin.EKF.XGyroBiasx8206 Data_bin.EKF.YGyroBiasx8206 Data_bin.EKF.ZGyroBiasx8206]';
Data.EKF.GYROBunc = [Data_bin.EKF.XGyroBiasUCx820B Data_bin.EKF.YGyroBiasUCx820B Data_bin.EKF.ZGyroBiasUCx820B]';
Data.EKF.GYROSF = [Data_bin.EKF.XGyroSFx8216 Data_bin.EKF.YGyroSFx8216 Data_bin.EKF.ZGyroSFx8216]';
Data.EKF.GYROSFunc = [Data_bin.EKF.XGyroSFUCx8218 Data_bin.EKF.YGyroSFUCx8218 Data_bin.EKF.ZGyroSFUCx8218]';

Data.EKF.MAG_VEC_MOD = [Data_bin.EKF.IntenNx8215 Data_bin.EKF.IntenEx8215 Data_bin.EKF.IntenDx8215]';
Data.EKF.MAG_INCL_DECL = [Data_bin.EKF.Inclx8215 Data_bin.EKF.Declx8215]';

Data.EKF.HARDIRON_OFF = [Data_bin.EKF.XMagAutoHardIronOffsetx8225 Data_bin.EKF.YMagAutoHardIronOffsetx8225 Data_bin.EKF.ZMagAutoHardIronOffsetx8225]';
Data.EKF.HARDIRON_OFFunc = [Data_bin.EKF.XMagAutoHardIronOffsetUCx8228 Data_bin.EKF.YMagAutoHardIronOffsetUCx8228 Data_bin.EKF.ZMagAutoHardIronOffsetUCx8228]';
Data.EKF.SOFTIRON = [Data_bin.EKF.MagAutoSoftIronM11x8226 Data_bin.EKF.MagAutoSoftIronM12x8226 Data_bin.EKF.MagAutoSoftIronM13x8226 ...
                     Data_bin.EKF.MagAutoSoftIronM21x8226 Data_bin.EKF.MagAutoSoftIronM22x8226 Data_bin.EKF.MagAutoSoftIronM23x8226 ...
                     Data_bin.EKF.MagAutoSoftIronM31x8226 Data_bin.EKF.MagAutoSoftIronM32x8226 Data_bin.EKF.MagAutoSoftIronM33x8226 ]';
Data.EKF.SOFTIRONunc = [Data_bin.EKF.MagAutoSoftIronUCM11x8229 Data_bin.EKF.MagAutoSoftIronUCM12x8229 Data_bin.EKF.MagAutoSoftIronUCM13x8229 ...
                     Data_bin.EKF.MagAutoSoftIronUCM21x8229 Data_bin.EKF.MagAutoSoftIronUCM22x8229 Data_bin.EKF.MagAutoSoftIronUCM23x8229 ...
                     Data_bin.EKF.MagAutoSoftIronUCM31x8229 Data_bin.EKF.MagAutoSoftIronUCM32x8229 Data_bin.EKF.MagAutoSoftIronUCM33x8229 ]';

% Transforms Time from raspberry pi to time use in INS unit    
sys2real = fit(Data_bag.GPS_TIME.system_time',Data_bag.GPS_TIME.gps_time','linearinterp');
time = [Data_bag.GPS_corr.system_time' Data_bag.GPS_corr.TOW'];
time = unique(time,'rows');
sys2gps = fit(time(:,1),time(:,2),'linearinterp');

% Extract data from bag 
Data.pressure.time.Week = Data_bag.GPS_corr.WEEK(end);
Data.pressure.time.TOW = sys2gps(sys2real(Data_bag.RAW.pressure.t))';
Data.pressure.pressure = Data_bag.RAW.pressure.FluidPressure;
Data.temperature.time.Week = Data_bag.GPS_corr.WEEK(end);
Data.temperature.time.TOW = sys2gps(sys2real(Data_bag.RAW.temp.t))';
Data.temperature.temperature = Data_bag.RAW.temp.Temperature;

save(['Processed_Data/' name_output '.mat'],'Data');

display('Finnished: Data is stored in Processed_Data folder');
