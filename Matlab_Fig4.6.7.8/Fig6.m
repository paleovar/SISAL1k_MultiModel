% ------------------------------------------
% cp-2021-152: Figure 6
% ------------------------------------------
%% isotopes vs altitude and elevation

NH_idx = SISALv2.latitude(:) > 0;
SH_idx = SISALv2.latitude(:) < 0;

NH_latitude = SISALv2.latitude(NH_idx,:);
NH_d18O = GLOBAL.bootmean_d18O{1}(NH_idx,:);
NH_d13C = GLOBAL.d13C_dweq(NH_idx,:);

SH_latitude = SISALv2.latitude(SH_idx,:);
SH_d18O = GLOBAL.bootmean_d18O{1}(SH_idx,:);
SH_d13C = GLOBAL.d13C_dweq(SH_idx,:);

figure(2);
clf reset;

figure_number = {'a)','b)','c)','d)'};

m_width = 0.41;
m = [0.1,0.54,0.1,0.54,0.1,0.54];
n_height = 0.36;
%ny1 = 0.02; ny2 = 0.04; ny3 = 0.06; % Write n in loop based on this?
n = fliplr([0.02,0.02,0.22,0.22,0.62,0.62]);

set(gcf,'Position',[500 1000 800 600])

for k = 1:4
hS = subplot('Position',[m(k) n(k) m_width n_height]);
if k == 1
    mdl1 = fitlm(SH_latitude(:),SH_d18O(:,1),'linear');
    mdl2 = fitlm(NH_latitude(:),NH_d18O(:,1),'linear');
    mdl = fitlm(SISALv2.latitude(:),GLOBAL.bootmean_d18O{1}(:,1),'linear');
    [Ypred1,YCI1] = predict(mdl1, SH_latitude(:),'alpha',0.1);
    [Ypred2,YCI2] = predict(mdl2, NH_latitude(:),'alpha',0.1);
    sr = [SH_latitude(:),YCI1,Ypred1]; sr1 = sortrows(sr,1);
    sr2 = [NH_latitude(:),YCI2,Ypred2]; sr3 = sortrows(sr2,1);
    h = errorbar(SISALv2.latitude(:),GLOBAL.bootmean_d18O{1}(:,1),...
        GLOBAL.bootmean_d18O{1}(:,1)-GLOBAL.ci{1}(:,1),...
        GLOBAL.bootmean_d18O{1}(:,1)-GLOBAL.ci{1}(:,2),...
        'o','MarkerEdgeColor','k','MarkerFaceColor','k','Color',[169 169 169]./255);
    hold on
    h1 = plot(sr1(:,1),sr1(:,4),'Color',[112,160,205]./255,'LineWidth',2);
    hold on
    h2 = plot(sr1(:,1),sr1(:,2:3),'Color',[196,121,0]./255,'LineStyle','-');
    hold on
    h3 = plot(sr3(:,1),sr3(:,4),'Color',[112,160,205]./255,'LineWidth',2);
    hold on
    h4 = plot(sr3(:,1),sr3(:,2:3),'Color',[196,121,0]./255,'LineStyle','-');
    set(gca,'FontSize',12,'XTickLabel',[],'XLabel',[]);
    ylabel('\delta^1^8O_{dweq} (‰)','Interpreter','tex','FontSize',11);
    ylim([-18 0]);
    str=strcat(['R²=',num2str(round(mdl1.Rsquared.Ordinary,2)),', p=',num2str(round(table2array(mdl1.Coefficients(2,4)),1,'significant'))]);
    str1=strcat(['R²=',num2str(round(mdl2.Rsquared.Ordinary,2)),', p=',num2str(round(table2array(mdl2.Coefficients(2,4)),1,'significant'))]);
    poshS = get(hS,'position'); 
    annotation('textbox',poshS,'String',figure_number{k},'FitBoxToText','on','LineStyle','none','FontSize',12);
    new_pos = poshS; new_pos(1,2)=new_pos(1,2)-0.22; new_pos(1,4)=new_pos(1,4)-0.1;
    annotation('textbox',new_pos,'String',str,'FitBoxToText','on','LineStyle','none','FontSize',10.5);
    new_pos(1,1)=new_pos(1,1)+0.235; 
    annotation('textbox',new_pos,'String',str1,'FitBoxToText','on','LineStyle','none','FontSize',10.5);    
elseif k == 2
    mdl = fitlm(SISALv2.altitude(:),GLOBAL.bootmean_d18O{1}(:,1),'linear');
    [Ypred,YCI] = predict(mdl, SISALv2.altitude(:),'alpha',0.1);
    sr = [SISALv2.altitude(:),YCI,Ypred]; sr1 = sortrows(sr,1);
    h = errorbar(SISALv2.altitude(:),GLOBAL.bootmean_d18O{1}(:,1),...
        GLOBAL.bootmean_d18O{1}(:,1)-GLOBAL.ci{1}(:,1),...
        GLOBAL.bootmean_d18O{1}(:,1)-GLOBAL.ci{1}(:,2),...
        'o','MarkerEdgeColor','k','MarkerFaceColor','k','Color',[169 169 169]./255);
    hold on
    plot(sr1(:,1),sr1(:,4),'Color',[112,160,205]./255,'LineWidth',2);
    hold on
    plot(sr1(:,1),sr1(:,2:3),'Color',[196,121,0]./255,'LineStyle','-');    
    set(gca,'FontSize',12,'XTickLabel',[],'XLabel',[],'YTickLabel',[],'YLabel',[]);
    ylim([-18 0]);
    xlim([-100 4200]);
    str=strcat(['R²=',num2str(round(mdl.Rsquared.Ordinary,2)),', p=',num2str(round(table2array(mdl.Coefficients(2,4)),1,'significant'))]);
    poshS = get(hS,'position'); 
    annotation('textbox',poshS,'String',figure_number{k},'FitBoxToText','on','LineStyle','none','FontSize',12);
    new_pos = poshS; new_pos(1,2)=new_pos(1,2)-0.22; new_pos(1,4)=new_pos(1,4)-0.1;
    annotation('textbox',new_pos,'String',str,'FitBoxToText','on','LineStyle','none','FontSize',10.5);
elseif k == 3
    mdl = fitlm(SISALv2.latitude(:),GLOBAL.d13C_dweq,'linear');
    mdl1 = fitlm(SH_latitude(:),SH_d13C(:,1),'linear');
    mdl2 = fitlm(NH_latitude(:),NH_d13C(:,1),'linear');
    [Ypred1,YCI1] = predict(mdl1, SH_latitude(:),'alpha',0.1);
    [Ypred2,YCI2] = predict(mdl2, NH_latitude(:),'alpha',0.1);
    sr = [SH_latitude(:),YCI1,Ypred1]; sr1 = sortrows(sr,1);
    sr2 = [NH_latitude(:),YCI2,Ypred2]; sr3 = sortrows(sr2,1);
    h = plot(SISALv2.latitude(:),GLOBAL.d13C_dweq,'LineStyle','none','Color','k',...
        'Marker','o','MarkerFaceColor','k');
    hold on
    h1 = plot(sr1(:,1),sr1(:,4),'Color',[112,160,205]./255,'LineWidth',2);
    hold on
    h2 = plot(sr1(:,1),sr1(:,2:3),'Color',[196,121,0]./255,'LineStyle','-');
    hold on
    h3 = plot(sr3(:,1),sr3(:,4),'Color',[112,160,205]./255,'LineWidth',2);
    hold on
    h4 = plot(sr3(:,1),sr3(:,2:3),'Color',[196,121,0]./255,'LineStyle','-');
    set(gca,'FontSize',12);
    ylabel('\delta^1^3C_{c} (‰)','Interpreter','tex','FontSize',11);
    xlabel(['Latitude (' char(176) 'N)'],'Interpreter','tex','FontSize',11);
    ylim([-15 5]);
        str=strcat(['R²=',num2str(round(mdl1.Rsquared.Ordinary,2)),', p=',num2str(round(table2array(mdl1.Coefficients(2,4)),1,'significant'))]);
    str1=strcat(['R²=',num2str(round(mdl2.Rsquared.Ordinary,2)),', p=',num2str(round(table2array(mdl2.Coefficients(2,4)),1,'significant'))]);
    poshS = get(hS,'position'); 
    annotation('textbox',poshS,'String',figure_number{k},'FitBoxToText','on','LineStyle','none','FontSize',12);
    new_pos = poshS; new_pos(1,2)=new_pos(1,2)-0.22; new_pos(1,4)=new_pos(1,4)-0.1;
    annotation('textbox',new_pos,'String',str,'FitBoxToText','on','LineStyle','none','FontSize',10.5);
    new_pos(1,1)=new_pos(1,1)+0.258; 
    annotation('textbox',new_pos,'String',str1,'FitBoxToText','on','LineStyle','none','FontSize',10.5);   
elseif k == 4
    mdl = fitlm(SISALv2.altitude(:),GLOBAL.d13C_dweq,'linear');
    [Ypred,YCI] = predict(mdl, SISALv2.altitude(:),'alpha',0.1);
    sr = [SISALv2.altitude(:),YCI,Ypred]; sr1 = sortrows(sr,1);
    h = plot(SISALv2.altitude(:),GLOBAL.d13C_dweq,'LineStyle','none','Color','k',...
        'Marker','o','MarkerFaceColor','k');
    hold on
    h1 = plot(sr1(:,1),sr1(:,4),'Color',[112,160,205]./255,'LineWidth',2);
    hold on
    h2 = plot(sr1(:,1),sr1(:,2:3),'Color',[196,121,0]./255,'LineStyle','-');    
    set(gca,'FontSize',12,'YTickLabel',[],'YLabel',[]);
    xlabel(['Altitude (m)'],'FontSize',11); title('');
    ylim([-15 5]); xlim([-100 4200]);
    str=strcat(['R²=',num2str(round(mdl.Rsquared.Ordinary,2)),', p=',num2str(round(table2array(mdl.Coefficients(2,4)),1,'significant'))]);
    poshS = get(hS,'position'); 
    annotation('textbox',poshS,'String',figure_number{k},'FitBoxToText','on','LineStyle','none','FontSize',12);
    new_pos = poshS; new_pos(1,2)=new_pos(1,2)-0.22; new_pos(1,4)=new_pos(1,4)-0.1;
    annotation('textbox',new_pos,'String',str,'FitBoxToText','on','LineStyle','none','FontSize',10.5);
end
clear h3 h4 hS i k mdl mdl1 mdl2 new_pos poshS sr sr1 sr2 sr3 ...
    str str1 YCI YCI1 YCI2 Ypred Ypred1 Ypred2

legend('off')
grid on
title([])
end

hL = subplot('Position',[0.1 0.02 0.8 0.1]);
poshL = get(hL,'position'); poshL(1,2)= poshL(1,2)+0.045;
lgd = legend(hL,[h(1),h1(1),h2(1)],'Data','Linear fit','90% conf. bounds'); legend box off;
set(lgd,'position',poshL,'Orientation','horizontal', 'FontSize', 11);
axis(hL,'off');

clear figure_number hL lgd m m_width n n_height poshL

