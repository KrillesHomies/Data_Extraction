function data = import_IMU_bin(filename, dataLines)
%IMPORTFILE Import data from a text file
%  BROF1IMULOG = IMPORTFILE(FILENAME) reads data from text file FILENAME
%  for the default selection.  Returns the data as a table.
%
%  BROF1IMULOG = IMPORTFILE(FILE, DATALINES) reads data for the
%  specified row interval(s) of text file FILENAME. Specify DATALINES as
%  a positive scalar integer or a N-by-2 array of positive scalar
%  integers for dis-contiguous row intervals.
%
%  Example:
%  broF1IMULog = importfile("D:\Kurser-MDH\Exjobb_FOI\DynamikModel\Data\PiRecorded\Data\bro_F1_IMU_Log.csv", [3, Inf]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 26-Apr-2021 14:09:04

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [3, Inf];
end

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 16);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["IMUTFlags", "IMUWeek", "IMUTOW", "XAccelx8004", "YAccelx8004", "ZAccelx8004", "XGyrox8005", "YGyrox8005", "ZGyrox8005", "XMagx8006", "YMagx8006", "ZMagx8006", "CFQ0x800A", "CFQ1x800A", "CFQ2x800A", "CFQ3x800A"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
data = readtable(filename, opts);

end