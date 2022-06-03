% ------------------------------------------
% cp-2021-152: Supplement Figure 2
% ------------------------------------------
%% %  Individual models d18O-if vs d18O-dweq

figure(5);
clf reset;

figure_number = {'a) ECHAM5-wiso','d) iHadCM3','b) GISS-E2-R','e) isoGSM','c) iCESM','f) MMM'};

m_width = 0.27;
m = [0.075,0.075,0.365,0.365,0.655,0.655,0.075,0.075,0.075,0.365,0.365,0.365,0.655,0.655,0.655];
n_height = 0.165;
n = [0.795,0.57,0.795,0.57,0.795,0.57,0.345,0.12,0.02,0.345,0.12,0.02,...
    0.345,0.12,0.02];

edges = 0:200:4000;

set(gcf,'Position',[2000 1000 1000 1000])

for k = 1:6
hS = subplot('Position',[m(k) n(k) m_width n_height]);

if k == 1
    mdl = fitlm(SISALv2.ECHAM5(:,5),SISALv2.ECHAM5(:,1),'linear');
    [Ypred,YCI] = predict(mdl, SISALv2.ECHAM5(:,5),'alpha',0.1);
    sr = [SISALv2.ECHAM5(:,5),YCI,Ypred]; sr1 = sortrows(sr,1);
    h = plot(SISALv2.ECHAM5(:,5),SISALv2.ECHAM5(:,1),'LineStyle','none','Color','k',...
        'Marker','o','MarkerFaceColor','k');
   
elseif k == 2    
    mdl = fitlm(SISALv2.HadCM3(:,5),SISALv2.HadCM3(:,1),'linear');
    [Ypred,YCI] = predict(mdl, SISALv2.HadCM3(:,5),'alpha',0.1);
    sr = [SISALv2.HadCM3(:,5),YCI,Ypred]; sr1 = sortrows(sr,1);
    h = plot(SISALv2.HadCM3(:,5),SISALv2.HadCM3(:,1),'LineStyle','none','Color','k',...
        'Marker','o','MarkerFaceColor','k');
    
elseif k == 3    
    mdl = fitlm(SISALv2.GISS(:,5),SISALv2.GISS(:,1),'linear');
    [Ypred,YCI] = predict(mdl, SISALv2.GISS(:,5),'alpha',0.1);
    sr = [SISALv2.GISS(:,5),YCI,Ypred]; sr1 = sortrows(sr,1);
    h = plot(SISALv2.GISS(:,5),SISALv2.GISS(:,1),'LineStyle','none','Color','k',...
        'Marker','o','MarkerFaceColor','k');
    
elseif k == 4
    mdl = fitlm(SISALv2.isoGSM(:,5),SISALv2.isoGSM(:,1),'linear');
    [Ypred,YCI] = predict(mdl, SISALv2.isoGSM(:,5),'alpha',0.1);
    sr = [SISALv2.isoGSM(:,5),YCI,Ypred]; sr1 = sortrows(sr,1);
    h = plot(SISALv2.isoGSM(:,5),SISALv2.isoGSM(:,1),'LineStyle','none','Color','k',...
        'Marker','o','MarkerFaceColor','k');
    
elseif k == 5
    mdl = fitlm(SISALv2.CESM(:,5),SISALv2.CESM(:,1),'linear');
    [Ypred,YCI] = predict(mdl, SISALv2.CESM(:,5),'alpha',0.1);
    sr = [SISALv2.CESM(:,5),YCI,Ypred]; sr1 = sortrows(sr,1);
    h = plot(SISALv2.CESM(:,5),SISALv2.CESM(:,1),'LineStyle','none','Color','k',...
        'Marker','o','MarkerFaceColor','k');
    
elseif k == 6    
    e = errorbar(GLOBAL.bootmean_d18O{2}(:,1),GLOBAL.bootmean_d18O{1}(:,1),...
        GLOBAL.bootmean_d18O{1}(:,1)-GLOBAL.ci{1}(:,1),...
        GLOBAL.bootmean_d18O{1}(:,1)-GLOBAL.ci{1}(:,2),...
        GLOBAL.bootmean_d18O{2}(:,1)-GLOBAL.ci{2}(:,1),...
        GLOBAL.bootmean_d18O{2}(:,1)-GLOBAL.ci{2}(:,2),...
        'o','MarkerEdgeColor','k','MarkerFaceColor','k','Color',[169 169 169]./255);
    hold on
    plot(GLOBAL.linreg_d18O{2}(:,1),GLOBAL.linreg_d18O{2}(:,4),'Color',[112,160,205]./255,'LineWidth',2)
    hold on
    plot(GLOBAL.linreg_d18O{2}(:,1),GLOBAL.linreg_d18O{2}(:,2:3),'Color',[196,121,0]./255,'LineStyle','-')

end
if k == 1 || k == 2 || k == 3 || k == 4 || k == 5
hold on
h1 = plot(sr1(:,1),sr1(:,4),'Color',[112,160,205]./255,'LineWidth',2);
hold on
h2 = plot(sr1(:,1),sr1(:,2:3),'Color',[196,121,0]./255,'LineStyle','-'); 
end

set(gca,'FontSize',12); 

xlim([-22 2]);
ylim([-22 2]);

if k == 3 || k == 4 || k == 5 || k == 6
    set(gca,'YLabel',[],'YTickLabel',[]);
else
    ylabel('\delta^{18}O_{dweq}');
end
if k == 1 || k == 3 || k == 5
    set(gca,'XLabel',[],'XTickLabel',[]);
else
    xlabel('\delta^{18}O_{iw}');
end
legend('off')

poshS = get(hS,'position'); 
annotation('textbox',poshS,'String',figure_number{k},'FitBoxToText','on','LineStyle','none','FontSize',12);
new_pos = poshS; new_pos(1,2)=new_pos(1,2)-0.12; new_pos(1,4)=new_pos(1,4)-0.02;
if k == 6
    str1=strcat(['R²=',num2str(round(GLOBAL.R_P_d18O{2}(1),2)),...
        ', p=',num2str(round(GLOBAL.R_P_d18O{2}(2),1,'significant'))]);
    annotation('textbox',new_pos,'String',str1,'FitBoxToText','on','LineStyle','none','FontSize',10.5);
else
    str=strcat(['R²=',num2str(round(mdl.Rsquared.Ordinary,2)),', p=',num2str(round(table2array(mdl.Coefficients(2,4)),1,'significant'))]);
    annotation('textbox',new_pos,'String',str,'FitBoxToText','on','LineStyle','none','FontSize',10.5);
end
grid on
end

hL = subplot('Position',[0.1 0.41 0.78 0.1]);
poshL = get(hL,'position'); poshL(1,2)= poshL(1,2)+0.035;
lgd = legend(hL,[h(1),h1(1),h2(1)],'Data','Linear fit','90% conf. bounds'); legend box off;
set(lgd,'position',poshL,'Orientation','horizontal', 'FontSize', 11);
axis(hL,'off');

clear e edges h h1 h2 hL hS k lgd m m_width mdl n n_height new_pos poshL poshS ...
   sr sr1 str str1 YCI Ypred figure_number