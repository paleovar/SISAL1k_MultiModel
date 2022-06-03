% ------------------------------------------
% cp-2021-152: Supplement Figure 10
% ------------------------------------------
%% LM (SISAL+sim) vs post-1900 CE (Fohlmeister2020 + obs)

Fohlmeister = readtable('Fohlmeister2020.csv');
Fohlmeister_d13C = table2array(Fohlmeister(:,4));
Fohlmeister_temp = table2array(Fohlmeister(:,5));
Fohlmeister_prec = table2array(Fohlmeister(:,6));
Fohlmeister_altitude = table2array(Fohlmeister(:,7));
figure_number = {'a)','b)','c)'};

figure(9);
clf reset;

m_width = 0.25;
m = [0.105,0.375,0.645,0.105,0.375,0.645];
n_height = 0.21;
n = fliplr([0.75,0.75,0.75,0.65,0.65,0.65]);

set(gcf,'Position',[500 1000 800 600])

for k = 1:3
hS = subplot('Position',[m(k) n(k) m_width n_height]);
if k == 1
    mdl = fitlm(SISALv2.altitude(:),GLOBAL.d13C_dweq,'linear');
    [Ypred,YCI] = predict(mdl, SISALv2.altitude(:),'alpha',0.1);
    sr = [SISALv2.altitude(:),YCI,Ypred]; sr1 = sortrows(sr,1);
    h = plot(SISALv2.altitude(:),GLOBAL.d13C_dweq,'LineStyle','none','Color','k',...
        'Marker','o','MarkerSize',4,'MarkerFaceColor','k');
    hold on
    h2 = plot(sr1(:,1),sr1(:,4),'-k','LineWidth',2);
    hold on
    str=strcat(['R²=',num2str(round(mdl.Rsquared.Ordinary,2)),', p=',num2str(round(table2array(mdl.Coefficients(2,4)),1,'significant'))]);
    hold on
    mdl = fitlm(Fohlmeister_altitude(:),Fohlmeister_d13C(:),'linear');
    [Ypred,YCI] = predict(mdl, Fohlmeister_altitude(:),'alpha',0.1);
    sr = [Fohlmeister_altitude(:),YCI,Ypred]; sr1 = sortrows(sr,1);
    h3 = plot(Fohlmeister_altitude(:),Fohlmeister_d13C(:),'LineStyle','none','Color','k',...
        'Marker','o','MarkerSize',4,'MarkerFaceColor',[202,0,32]./255);
    hold on
    h4 = plot(sr1(:,1),sr1(:,4),'Color',[202,0,32]./255,'LineWidth',2);
    hold on
    str1=strcat(['R²=',num2str(round(mdl.Rsquared.Ordinary,2)),', p=',num2str(round(table2array(mdl.Coefficients(2,4)),1,'significant'))]);
    set(gca,'FontSize',11);
    ylabel('\delta^1^3C_{speleo} (‰)','Interpreter','tex','FontSize',11);
    xlabel(['Altitude (m)'],'Interpreter','tex','FontSize',11); title('');
    xlim([-200 4200]); xticks([0:1000:4000])
elseif k == 2
    e = errorbar(GLOBAL.bootmean_d13C{k+1}(:,1),GLOBAL.d13C_dweq,...
        GLOBAL.bootmean_d13C{k+1}(:,1)-GLOBAL.ci{k+1}(:,1),...
        GLOBAL.bootmean_d13C{k+1}(:,1)-GLOBAL.ci{k+1}(:,2),...
        'horizontal','o','MarkerSize',4,'MarkerEdgeColor','k','MarkerFaceColor','k','Color',[169 169 169]./255);
    hold on
    plot(GLOBAL.linreg_d13C{k+1}(:,1),GLOBAL.linreg_d13C{k+1}(:,4),'Color','k','LineWidth',2)
    hold on
    mdl = fitlm(Fohlmeister_temp(:),Fohlmeister_d13C(:),'linear');
    [Ypred,YCI] = predict(mdl, Fohlmeister_temp(:),'alpha',0.1);
    sr = [Fohlmeister_temp(:),YCI,Ypred]; sr1 = sortrows(sr,1);
    h3 = plot(Fohlmeister_temp(:),Fohlmeister_d13C(:),'LineStyle','none','Color','k',...
        'Marker','o','MarkerSize',4,'MarkerFaceColor',[202,0,32]./255);
    hold on
    h4 = plot(sr1(:,1),sr1(:,4),'Color',[202,0,32]./255,'LineWidth',2);
    set(gca,'FontSize',11);
    ylabel('\delta^1^3C_{speleo} (‰)','Interpreter','tex','FontSize',11);
    str=strcat(['R²=',num2str(round(GLOBAL.R_P_d13C{k+1}(1),2)),', p=',num2str(round(GLOBAL.R_P_d13C{k+1}(2),1,'significant'))]);
    str1=strcat(['R²=',num2str(round(mdl.Rsquared.Ordinary,2)),', p=',num2str(round(table2array(mdl.Coefficients(2,4)),1,'significant'))]);
    set(gca,'YTickLabel',[],'YLabel',[]);
    xlabel(['Temperature (' char(176) 'C)'],'FontSize',11); title('');
    xlim([-5 30]); xticks([0:5:25])
elseif k == 3
    e = errorbar(GLOBAL.bootmean_d13C{k+1}(:,1),GLOBAL.d13C_dweq,...
        GLOBAL.bootmean_d13C{k+1}(:,1)-GLOBAL.ci{k+1}(:,1),...
        GLOBAL.bootmean_d13C{k+1}(:,1)-GLOBAL.ci{k+1}(:,2),...
        'horizontal','o','MarkerSize',4,'MarkerEdgeColor','k',...
        'MarkerFaceColor','k','Color',[169 169 169]./255);
    hold on
    plot(GLOBAL.linreg_d13C{k+1}(:,1),GLOBAL.linreg_d13C{k+1}(:,4),'Color','k','LineWidth',2)
    hold on
    mdl = fitlm(Fohlmeister_prec(:),Fohlmeister_d13C(:),'linear');
    [Ypred,YCI] = predict(mdl, Fohlmeister_prec(:),'alpha',0.1);
    sr = [Fohlmeister_prec(:),YCI,Ypred]; sr1 = sortrows(sr,1);
    h3 = plot(Fohlmeister_prec(:),Fohlmeister_d13C(:),'LineStyle','none','Color','k',...
        'Marker','o','MarkerSize',4,'MarkerFaceColor',[202,0,32]./255);
    hold on
    h4 = plot(sr1(:,1),sr1(:,4),'Color',[202,0,32]./255,'LineWidth',2);
    set(gca,'FontSize',11);
    ylabel('\delta^1^3C_{speleo} (‰)','Interpreter','tex','FontSize',11);
    str=strcat(['R²=',num2str(round(GLOBAL.R_P_d13C{k+1}(1),2)),', p=',num2str(round(GLOBAL.R_P_d13C{k+1}(2),1,'significant'))]);
    str1=strcat(['R²=',num2str(round(mdl.Rsquared.Ordinary,2)),', p=',num2str(round(table2array(mdl.Coefficients(2,4)),1,'significant'))]);
    set(gca,'YAxisLocation','right');
    xlabel('Precipitation (mm)','FontSize',11); title('');
    xlim([10 5500]); B = [100,1000,5000];
    set(gca,'XScale','log','XTick',B,'XTickLabel',B)
end
ylim([-17 7]); yticks(-20:5:5);
grid on
legend('off')
poshS = get(hS,'position'); 
annotation('textbox',poshS,'String',figure_number{k},'FitBoxToText','on','LineStyle','none','FontSize',12);
new_pos = poshS; new_pos(1,2)=new_pos(1,2)-0.06; new_pos(1,4)=new_pos(1,4)-0.1;
annotation('textbox',new_pos,'String',str,'FitBoxToText','on','LineStyle','none','FontSize',8.5);
new_pos1 = new_pos; new_pos1(1,2)=new_pos(1,2)-0.018;
annotation('textbox',new_pos1,'String',str1,'FitBoxToText','on','LineStyle','none','FontSize',8.5,'Color',[202,0,32]./255);
end

hL = subplot('Position',[0.075 0.50 0.85 0.1]);
poshL = get(hL,'position'); 
lgd = legend(hL,[h(1),h3(1)],'LM + sim','post-1900 CE + obs','90% conf. bounds'); legend box off;
set(lgd,'position',poshL,'Orientation','horizontal', 'FontSize', 11);
axis(hL,'off');

clear B e Fohlmeister* h* k lgd m m_width mdl n n_height new_pos* posh* ...
   sr* str* YCI Ypred figure_number