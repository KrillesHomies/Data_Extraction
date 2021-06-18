%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The code in this sections are used to extract data from the Bag and CSV files  
% and combines the data so that the timestamps are syncrhonised
% The Bin files first need to be extracted with the "InertialSensorUtils_GUI" 
% from Microstain to CSV files. This is done with the QInertialSensorUtils_GUI.exe program
% located in the "InertialSensorUtils_GUI" folder. 
% Data files for the tests can be found in the Data folder
% Most of the data files have already been extracted and the CSV and bag files are located
% in the Data folder. 
%
% The Main.m can be used to extract data from a set of CSV files and a Bag file. Depending 
% on the settings of which data that is exported, then this might need some modifications.
%
% Segment_data.m is used to segment the data for the EKF. Typically good to have margin with GPS data
% for the filter to be able to locate itself (maybe ), but not too much sinces it will become slow
%
% InertialSensorUtils_GUI behövs för att extrahera data från bin filer
% Detta program kan hämtas här: https://s3.amazonaws.com/download.microstrain.com/InertialSensorUtils_GUI_exe.zip
% En kopia ligger också i mappen InertialSensorUtils_GUI
%
% Edited by Kristoffer Lindve 2021-06-08
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%