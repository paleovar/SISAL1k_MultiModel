% ------------------------------------------
% cp-2021-152: Figure 4
% ------------------------------------------
%% Isotope offset speleo-dweq minus simulated d18O

% Entity mean
% Temperature=2, Precipitation=5, Evaporation=10, dweq=1, modelISOT=6, wp=7, wif=8
yy{1} = SISALv2.ECHAM5(:,5)-SISALv2.ECHAM5(:,1);
yy{2} = SISALv2.GISS(:,5)-SISALv2.GISS(:,1);
yy{3} = SISALv2.CESM(:,5)-SISALv2.CESM(:,1);
yy{4} = SISALv2.HadCM3(:,5)-SISALv2.HadCM3(:,1);
yy{5} = SISALv2.isoGSM(:,5)-SISALv2.isoGSM(:,1);

zz{1} = SISALv2.ECHAM5(:,5);
zz{2} = SISALv2.GISS(:,5); 
zz{3} = SISALv2.CESM(:,5);
zz{4} = SISALv2.HadCM3(:,5);
zz{5} = SISALv2.isoGSM(:,5);

yymedian{1} = nanmedian(yy{1});
yymedian{2} = nanmedian(yy{2});
yymedian{3} = nanmedian(yy{3});
yymedian{4} = nanmedian(yy{4});
yymedian{5} = nanmedian(yy{5});

zzmedian{1} = nanmedian(zz{1});
zzmedian{2} = nanmedian(zz{2});
zzmedian{3} = nanmedian(zz{3});
zzmedian{4} = nanmedian(zz{4});
zzmedian{5} = nanmedian(zz{5});

% Bootstrap CI of mean
Nb = 2000;

yy_ci_general = cell(5,1);
yy_bootmean_general = cell(5,1);
for i = 1:length(yy_ci_general)
    for j = 1:length(yy{i})
        data = yy{i};
        [CI,bootstat] = bootci(Nb,{@nanmedian,data},'Alpha',0.1);
        yy_ci_general{i}(j,1) = CI(1);
        yy_ci_general{i}(j,2) = CI(2);
        yy_bootmean_general{i}(j,:) = bootstat(:);
    end
end
clear bootstat CI data n i j

data = SISALv2.d18O(:,2);
[SISALv2.d18O_ci_general,SISALv2.d18O_bootmean_general] = bootci(Nb,{@nanmean,data},'Alpha',0.1);

clear bootstat CI data n i j

% Colors
colorbar_ipcc = [112,160,205;0,52,102;178,178,178;0,121,0;196,121,0]./255;

figure(1);
clf reset;
set(gcf,'Position',[1000 1000 800 400])
tiledlayout(1,2,'TileSpacing','none');

hS = nexttile;
for i = 1:length(zz)
    [f,xi] = ksdensity(zz{i});
    ff{i} = f;
    xxi{i} = xi;
end
[f_s,xi_s] = ksdensity(SISALv2.d18O(:,2));

for j = 1:length(zz)
    h = plot(xxi{j},ff{j},'Color',colorbar_ipcc(j,:),'LineWidth',4);
    hold on
    xline(zzmedian{j},'LineStyle','--','LineWidth',1.5,...
        'Color',colorbar_ipcc(j,:),'HandleVisibility','off');
end
hold on
hh = plot(xi_s,f_s,'k','LineWidth',4);
hold on
xi_s_median = nanmedian(SISALv2.d18O(:,2));
xline(xi_s_median,'--k','linewidth',1.5);
legend('ECHAM5-wiso','GISS-E2-R','iCESM','iHadCM3','isoGSM','SISALv2','Location','northwest')
legend boxoff
ylim([0 0.3])
xlim([-22 3])
xticks(-20:5:0)
ylabel('Density','Interpreter','tex','FontSize',11);
xlabel('\delta^{18}O','Interpreter','tex','FontSize',11);
poshS = get(hS,'position'); 
annotation('textbox',poshS,'String','a)','FitBoxToText','on','LineStyle','none','FontSize',12);

hS = nexttile;
for i = 1:length(yy)
    [f,xi] = ksdensity(yy{i});
    ff{i} = f;
    xxi{i} = xi;
end
for j = 1:length(yy)
    h = plot(xxi{j},ff{j},'Color',colorbar_ipcc(j,:),'LineWidth',4);
    hold on
    xline(yymedian{j},'LineStyle','--','LineWidth',1.5,...
        'Color',colorbar_ipcc(j,:),'HandleVisibility','off');
end
xlabel('\Delta\delta^{18}O','Interpreter','tex','FontSize',11);
ylim([0 0.3])
xlim([-12 12])
xticks(-10:5:10)
set(gca,'YTickLabel',[],'YLabel',[]);
poshS = get(hS,'position'); 
annotation('textbox',poshS,'String','b)','FitBoxToText','on','LineStyle','none','FontSize',12);

clear colorbar_ipcc f f_s ff h hh hS i j Nb poshS xi xi_s xi_s_median xxi 