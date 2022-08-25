%% Intro

% Pyticles plotter written by Natalya Evans on 2022 Jan 23 to recreate fig
% 5 from Margolskee et al. (2019)

%% 13CW plot

pdens_high=25.75;
pdens_low=27;

load('southern_boundary_particle_counter')
figure(1)
subplot(3,1,1)
contourf(map_x,map_y-1000,particle_counter,[0,0.1:0.01:2],'LineStyle','None');
hold on
C=contour(map_x,map_y-1000,particle_counter,[0,0.2],'k--');
hT=clabel(C,0.2);
hT(2).String='67%';
hT(4).String='67%';
C=contour(map_x,map_y-1000,particle_counter,[0,0.5],'k-');
hT=clabel(C,0.5);
hT(2).String='44%';
hT(4).String='44%';
set(gca,'YDir','reverse');
cmap=cmocean('-ice');
cmap(1,:)=[1,1,1]; % white background
colormap(cmap);
caxis([0 2])
ylim([25.75 27])
yticks([25.8 26 26.2 26.4 26.6 26.8 27.0])
yticklabels({'25.8' '26.0' '26.2' '26.4' '26.6' '26.8' '27'})
grid on
ylabel('Potential Density/kg m^{-3}')
xlabel(['Longitude/' char(176) 'E'])
title('Percent Particle Entry')
hold off


load('northwest_boundary_particle_counter')
figure(1)
subplot(3,1,2)
contourf(map_x,map_y-1000,particle_counter,[0,0.1:0.01:2],'LineStyle','None');
hold on
[C,c]=contour(map_x,map_y-1000,particle_counter,[0,0.10],'k--');
hT=clabel(C,0.10);
hT(2).String='20.2%';
hT(4).String='20.2%';
hT(6).String='20.2%';
C=contour(map_x,map_y-1000,particle_counter,[0,0.3],'k-');
hT=clabel(C,0.3);
hT(2).String='15.8%';
hT(4).String='15.8%';
set(gca,'YDir','reverse');
colormap(cmap);
caxis([0 2])
ylim([26 27])
yticks([25.8 26 26.2 26.4 26.6 26.8 27.0 27.2])
yticklabels({'25.8' '26.0' '26.2' '26.4' '26.6' '26.8' '27.0'})
grid on
ylabel('Potential Density/kg m^{-3}')
ylabel(['Latitude/' char(176) 'N'])
hold off


%% Plot this one sidewise

figure(2)
subplot(1,2,1)
contourf(map_y-1000,map_x,particle_counter,[0,0.1:0.01:2],'LineStyle','None');
hold on
C=contour(map_y-1000,map_x,particle_counter,[0,0.10],'k--');
hT=clabel(C,0.10);
hT(2).String='20.2%';
hT(4).String='20.2%';
hT(6).String='20.2%';

C=contour(map_y-1000,map_x,particle_counter,[0,0.3],'k-');
hT=clabel(C,0.3);
hT(2).String='15.8%';
hT(4).String='15.8%';
colormap(cmap);
caxis([0 2])
xlim([26 27])
xticks([25.8 26 26.2 26.4 26.6 26.8 27.0 27.2])
xticklabels({'25.8' '26.0' '26.2' '26.4' '26.6' '26.8' '27.0'})
grid on
xlabel('Potential Density/kg m^{-3}')
ylabel(['Latitude/' char(176) 'N'])
title('Percent Particle Entry')
hold off

