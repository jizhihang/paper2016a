%% Correlo en Windows. Usando Matlab 2015
clear all
%close all
clc
FV = [ 0 60.77 ];
SFV_pca = [0 66.05 ];
SFV_rp =  [0 59.93];

res = [ FV; SFV_pca; SFV_rp];
h = bar([ 0 256],res');

%xlim([140 360])
ylim([40 70])
colormap(cool)
set(gca,'FontSize',24); 
grid on
%l = cell(1,3);
%l{1}='FV'; l{2}='SFV-PCA'; l{3}='SFV-RP';
legend('FV','SFV-PCA', 'SFV-RP' , 'orientation','vertical');
ylabel('NDCG (%)')
xlabel('Visual Dictionary Size')

%To save
width = 8;     % Width in inches
height = 6;    % Height in inches

set(gcf,'InvertHardcopy','on');
set(gcf,'PaperUnits', 'inches');
papersize = get(gcf, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(gcf,'PaperPosition', myfiguresize);

%Nicta
print('/home/johanna-uq/latex-svn/no-svn/icpr_2016/icpr2016_johanna_vApril21/images/results/mulp_256','-depsc2','-r300');
%close all
