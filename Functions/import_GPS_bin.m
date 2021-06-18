function data = import_GPS_bin(filename, dataLines)
%IMPORTFILE Import data from a text file
%  BROF1GPSLOG = IMPORTFILE(FILENAME) reads data from text file FILENAME
%  for the default selection.  Returns the data as a table.
%
%  BROF1GPSLOG = IMPORTFILE(FILE, DATALINES) reads data for the
%  specified row interval(s) of text file FILENAME. Specify DATALINES as
%  a positive scalar integer or a N-by-2 array of positive scalar
%  integers for dis-contiguous row intervals.
%
%  Example:
%  broF1GPSLog = importfile("D:\Kurser-MDH\Exjobb_FOI\DynamikModel\Data\PiRecorded\Data\bro_F1_GPS_Log.csv", [3, Inf]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 26-Apr-2021 14:06:53

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [3, Inf];
end

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 18);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["GPSTFlags", "GPSWeek", "GPSTOW", "Latx8103", "Lonx8103", "HtAbvEllipsx8103", "MSLHeightx8103", "HorzAccx8103", "VertAccx8103", "Flagsx8103", "UTCYearx8108", "UTCMonthx8108", "UTCDayx8108", "UTCHourx8108", "UTCMinutex8108", "UTCSecondx8108", "UTCMillesecondx8108", "Flagsx8108"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
data = readtable(filename, opts);

end