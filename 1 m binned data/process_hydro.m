%% 

% This code is designed to determine the depth of the 13CW. It reads in the
% current hydro data, five of the cruises

% Written by Natalya Evans, 1/18/21

%% load data

files={'WOCEhydro3','Clivarhydro3','TN278hydro3','P18hydro3','SKQ2016hydro3','RR1804hydro3','KM1919hydro3'};
for i=1:length(files)
    hydro(i)=load(char(files(i))); % places each OMP .mat output into a structured array.
end

years={'1994','2007','2012','2016','2016','2018','2019'};
years2=[1994,2007,2012,2016,2016,2018,2019];
col=[[0 0.4470 0.7410]',[0.8500 0.3250 0.0980]',[0.9290 0.6940 0.1250]',[0.4940 0.1840 0.5560]',[0.4660 0.6740 0.1880]',[0.3010 0.7450 0.9330]',[0.6350 0.0780 0.1840]',[1 0 0]']; %colors for each year


%% collect data

Tcw=13.41;
Scw=34.95;
Pcw=26.29;

Tthresh=0.1;
Sthresh=0.1;

for i=1:length(files)
    hydro_out(i).unique_lats=unique(round(hydro(i).lat,3,'significant'));
    for j=1:length(hydro_out(i).unique_lats)
        inds=round(hydro(i).lat,3,'significant')==hydro_out(i).unique_lats(j);
        tempvals=hydro(i).CT(inds);
        salvals=hydro(i).SA(inds);
%         inds2=tempvals >= Tcw - Tthresh & tempvals <= Tcw + Tthresh & salvals >= Scw - Sthresh;
        inds2=tempvals >= Tcw - Tthresh & tempvals <= Tcw + Tthresh;

        hydro_out(i).CT(j,1)=mean(tempvals(inds2));
        hydro_out(i).CT(j,2)=std(tempvals(inds2));
        hydro_out(i).CT(j,3)=length(tempvals(inds2));
        depthvals=hydro(i).depth(inds);
        hydro_out(i).depth(j,1)=mean(depthvals(inds2));
        hydro_out(i).depth(j,2)=std(depthvals(inds2));
        hydro_out(i).depth(j,3)=length(depthvals(inds2));
        
    end 
    
%     More specific version
    findind=find(floor(hydro_out(i).unique_lats)==19);
    ave_depths(i,1)=mean(hydro_out(i).depth(1:findind,1),'omitnan');
    ave_depths(i,2)=std(hydro_out(i).depth(1:findind,2),'omitnan');
    ave_depths(i,3)=length(hydro_out(i).depth(1:findind,3))-sum(isnan(hydro_out(i).depth(1:findind,3)));

% All depths
    
%     ave_depths(i,1)=mean(hydro_out(i).depth(:,1),'omitnan');
%     ave_depths(i,2)=std(hydro_out(i).depth(:,2),'omitnan');
%     ave_depths(i,3)=length(hydro_out(i).depth(:,3))-sum(isnan(hydro_out(i).depth(:,3)));
    
 end

%% Plot up data

figure(1)
errorbar(years2,ave_depths(:,1),ave_depths(:,2),'ko-','MarkerFaceColor','k');
axis ij
xlabel('Year')
ylabel('13CW depth/m')

figure(2)
for i=1:length(files)
    errorbar(hydro_out(i).unique_lats,hydro_out(i).depth(:,1),hydro_out(i).depth(:,2),'o-','MarkerFaceColor',col(:,i),'MarkerEdgeColor',col(:,i));
    hold on
end

xlabel('Latitude')
ylabel('13CW depth')
legend(years,'Location','Northwest')
axis ij
hold off
