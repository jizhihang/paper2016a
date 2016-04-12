close all
clear all
clc
Vec_Ng = [128 256 512 1024];

FV      = [52.10 52.63 52.16 52.03]; %c=0.1
SFV_pca = [50.41 56.73 51.81 50.98]; %c = 10
SFV_rp  = [51.90 53.68 46.92 47.87]; % c=10


plot(FV, '-bd', 'LineWidth',3,'MarkerSize',10);
ylim([44 58.5])
xlim([0.9 4.1])
hold on
plot( SFV_pca, '--ko', 'LineWidth',3,'MarkerSize',10);
plot( SFV_rp, '-mh', 'LineWidth',3,'MarkerSize',10);

%title('KTH','FontSize',20);
legend('FV','SFV-PCA', 'SFV-RP', 'Location', 'southwest','orientation','vertical');

ylabel('accuracy (%)','FontSize',20)
xlabel('K','FontSize',20)
set(gca, 'XTick',[1 2 3 4]);
set(gca, 'XTickLabel', Vec_Ng)
set(gca,'FontSize',20); 
grid

%To save
width = 7;     % Width in inches
height = 6;    % Height in inches

set(gcf,'InvertHardcopy','on');
set(gcf,'PaperUnits', 'inches');
papersize = get(gcf, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(gcf,'PaperPosition', myfiguresize);

%Nicta
%print('/home/johanna/latex-svn/wacv_2016_b/v18/images/experiments/all_shifts_kth_2','-depsc2','-r300');
print('/home/johanna-uq/codes/codes-git/papers_latex/icpr_2016/v6/images/results/acc_nGaussians','-depsc2','-r300');
close all


