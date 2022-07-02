% This code is designed to read a set of csv files containing numeric data,
% load them into Matlab, then use nlleasqr.m to fit them to the function
% described in modfunc.m. Both of these helper function were obtained from
% supplemental code on the Cambridge website for the textbook "Modeling 
% Methods for Marine Science", under the "resources" tab. The link is
% below.

% This code makes a few assumptions about the structure of the csv data.
% For one, it assumes the filename text, which it uses throughout to load
% files, name table columns, and as a legend in the plot. It assumes the
% structure of the data in the csvs, which is two columns with x-data and
% y-data. This should be edited easily, I hope. It also repeats the x-data
% in the final table, which is arbitrary, and if some indices are changed
% for nlleasqr, that can be easily fixed. There are some common plotting
% commands at the bottom for the figure

% One of the issues with tables is that variables added to tables need to
% all have the same number of rows. If this is not the case, it might be
% possible to add NaN to the space spots, then cut the NaN's before data
% fitting.

% https://www.cambridge.org/us/academic/subjects/earth-and-environmental-science/oceanography-and-marine-science/modeling-methods-marine-science?format=HB&isbn=9780521867832

% Script written by Natalya Evans
% Generated 4 September 2020

% Modified 1/25/21 to read in CLIVAR hydro data in csv format, using a
% spreadsheet called "lat_long" which has the station, latitude, and
% londitude extracted



%% Set up list of files to read
clear all % clears workspace so there aren't any issues

files=ls; % all file names
[numfiles ~]=size(files); % number of files

meta=xlsread('lat_long.xlsx');
stn=meta(:,1);
lat=meta(:,2);
long=meta(:,3);

% Selecting which files are csv's
for i=1:numfiles
    if isempty(strfind(convertCharsToStrings(files(i,:)),'.csv'))==0 %checks if it contains a ".csv" and if it does, returns a number so therefore not empty
        temp=files(i,:); % save filename
        temp(temp==' ')=[]; % remove spaces from filename
        csvfiles(i,:)=temp; % save char array of file names
    end
end

% ADJUST THIS
csvfiles(1:2,:)=[]; % for some reason, I'm getting two leading blank file names, so I cut them out here

%% Import data from files in csvfiles into a table for convenience

% I had to make some assumptions about your data structure and naming
% conventions here that you will want to edit 

% base case - load the first case to define the table
tempdata=readtable(csvfiles(1,:)); % reads in the first file
data=tempdata;
data(1,:)=[]; % remove the unit headers
data.lat=ones(size(data(:,1)))*lat(1);
data.long=ones(size(data(:,1)))*long(1);
data.stn=ones(size(data(:,1)))*stn(1);
% data=tempdata(:,1:2); % creates the output table that will contain all the data. ASSUMES ONLY 2 COLUMNS, 1:2
% data.Properties.VariableNames{'Var1'}=strcat('x',csvfiles(1,1:8)); % can't include periods or weird characterss
% data.Properties.VariableNames{'Var2'}=strcat('y',csvfiles(1,1:8)); % can't include periods or weird characterss

% You will probably want to change how you name variables in your table

[numfiles ~]=size(csvfiles); % number of files to iterate over

for i=2:numfiles % starts at 2 because of the base case
    tempdata=readtable(csvfiles(i,:)); %read in csv as table
    tempdata(1,:)=[]; % remove the unit headers
    tempdata.lat=ones(size(tempdata(:,1)))*lat(i);
    tempdata.long=ones(size(tempdata(:,1)))*long(i);
    tempdata.stn=ones(size(tempdata(:,1)))*stn(i);
    tempdata2=tempdata;
%     tempdata2=tempdata(:,1:2); % makes sure that only the first two columns are carried over, CHECK THIS
%     tempdata2.Properties.VariableNames{'Var1'}=strcat('x',csvfiles(i,1:8)); % gives each column a unique name based on the data. can't include periods or weird characterss
%     tempdata2.Properties.VariableNames{'Var2'}=strcat('y',csvfiles(i,1:8)); % gives each column a unique name based on the data. can't include periods or weird characterss
    data = vertcat(data, tempdata2);
%     data=[data tempdata2]; % concatenates temp data into the final table
end

% writetable(data,'P_18_hydro.xlsx');

%% fit the data to a model function and plot it

% [dummy numruns]=size(data); % determine the number of deconvolutions that will be performed
% 
% % I ASSUME THAT ALL THE ODD VALUES ARE X AND EVEN VALUES ARE Y IN THE
% % TABLE, YOU CAN ADJUST THIS
% 
% fig1=figure(1); % generates the figure to fill (unecessary) but defines it to save at end if you would like to
% 
% pin=[0,0,0]'; % initial guess at coefficients
% 
% for i=1:numruns/2
%     inds=[2*i-1,2*i]; % defines the x and y indices
%     
%     % Perform the fit using the fit function 'modfunc'
%     [f,p,kvg,iter,corp,covp,covr,stdresid,Z,r2]=nlleasqr(table2array(data(:,inds(1))),table2array(data(:,inds(2))),pin,'modfunc');
%     
%     x_sim=[min(table2array(data(:,inds(1)))):(max(table2array(data(:,inds(1))))-min(table2array(data(:,inds(1)))))/100:max(table2array(data(:,inds(1))))]; % define a variable that will run across the x-axis to scale for the deconvolution, so far 100 points between the min and max
%     out = p(1) + p(2)*exp(p(3)*x_sim); % fit fn, or part of it for deconvolution, from modfunc
%     
%     plot(x_sim,out,'k-','MarkerFaceColor','k');
%     hold on % prevents the plot from being overwritten, so you can superimpose plots!
% 
% end
% 
% hold off % stops plotting on the same plot
% 
% % Common plotting commands
% 
% xlabel('stuff')
% ylabel('stuff')
% title('This is a _{subscript} and this is a ^{superscript}')
% legend(csvfiles,'Location','Northwest') % use compass directions
% grid on
% box on
% % savefig('fig1') %saves figure
