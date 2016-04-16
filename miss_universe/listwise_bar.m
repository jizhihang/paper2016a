clear all
close all
clc
FV = [ 60.77 60.97];
SFV_pca = [66.05 57.31];
SFV_rp = [57.91 59.93];

res = [ FV; SFV_pca; SFV_rp];
h = bar([256 512],res');

ylim([40 70])
colormap(cool)
set(gca,'FontSize',15); 
grid on
l = cell(1,3);
l{1}='FV    '; l{2}='SFV-PCA  '; l{3}='SFV-RP  ';
legend(h,l, 'orientation','vertical', 'Position', [0.58,0.80,0.35,0]);

%To save
%width = 7;     % Width in inches
%height = 6;    % Height in inches

%set(gcf,'InvertHardcopy','on');
%set(gcf,'PaperUnits', 'inches');
%papersize = get(gcf, 'PaperSize');
%left = (papersize(1)- width)/2;
%bottom = (papersize(2)- height)/2;
%myfiguresize = [left, bottom, width, height];
%set(gcf,'PaperPosition', myfiguresize);

%Nicta
%print('/home/johanna/latex-svn/wacv_2016_b/v18/images/experiments/all_shifts_kth_2','-depsc2','-r300');
print('/home/johanna-uq/latex-svn/cypress/papers2016/icpr2016_johanna/images/results/mulp','-depsc2','-r300');
%close all
