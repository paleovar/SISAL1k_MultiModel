% ------------------------------------------
% cp-2021-152: Supplement Figure 4
% ------------------------------------------
%% Altitude regional

figure(6);
clf reset;

figure_number = {'a)','d)','b)','e)','c)','f)'};

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
    mdl = fitlm(REGION.tropics_elevation(:),tropics.bootmean_d18O{1}(:,1),'linear');
    [Ypred,YCI] = predict(mdl, REGION.tropics_elevation(:),'alpha',0.1);
    sr = [REGION.tropics_elevation(:),YCI,Ypred]; sr1 = sortrows(sr,1);
    h = errorbar(REGION.tropics_elevation(:),tropics.bootmean_d18O{1}(:,1),...
        tropics.bootmean_d18O{1}(:,1)-tropics.ci{1}(:,1),...
        tropics.bootmean_d18O{1}(:,1)-tropics.ci{1}(:,2),...
        'o','MarkerEdgeColor','k','MarkerFaceColor','k','Color',[169 169 169]./255);
    title('Tropics');
    ylabel('\delta^{18}O_{dweq}');
    
elseif k == 2    
    mdl = fitlm(REGION.tropics_elevation(:),REGION.tropics_d13C,'linear');
    [Ypred,YCI] = predict(mdl, REGION.tropics_elevation(:),'alpha',0.1);
    sr = [REGION.tropics_elevation(:),YCI,Ypred]; sr1 = sortrows(sr,1);
    h = plot(REGION.tropics_elevation(:),REGION.tropics_d13C,'LineStyle','none','Color','k',...
        'Marker','o','MarkerFaceColor','k');
    ylabel('\delta^{13}C_{c}');
    
elseif k == 3    
    mdl = fitlm(REGION.subtropics_elevation(:),subtropics.bootmean_d18O{1}(:,1),'linear');
    [Ypred,YCI] = predict(mdl, REGION.subtropics_elevation(:),'alpha',0.1);
    sr = [REGION.subtropics_elevation(:),YCI,Ypred]; sr1 = sortrows(sr,1);
    h = errorbar(REGION.subtropics_elevation(:),subtropics.bootmean_d18O{1}(:,1),...
        subtropics.bootmean_d18O{1}(:,1)-subtropics.ci{1}(:,1),...
        subtropics.bootmean_d18O{1}(:,1)-subtropics.ci{1}(:,2),...
        'o','MarkerEdgeColor','k','MarkerFaceColor','k','Color',[169 169 169]./255);
    title('Subtropics');
    
elseif k == 4
    mdl = fitlm(REGION.subtropics_elevation(:),REGION.subtropics_d13C,'linear');
    [Ypred,YCI] = predict(mdl, REGION.subtropics_elevation(:),'alpha',0.1);
    sr = [REGION.subtropics_elevation(:),YCI,Ypred]; sr1 = sortrows(sr,1);
    h = plot(REGION.subtropics_elevation(:),REGION.subtropics_d13C,'LineStyle','none','Color','k',...
        'Marker','o','MarkerFaceColor','k');
    
elseif k == 5
    mdl = fitlm(REGION.extratropics_elevation(:),extratropics.bootmean_d18O{1}(:,1),'linear');
    [Ypred,YCI] = predict(mdl, REGION.extratropics_elevation(:),'alpha',0.1);
    sr = [REGION.extratropics_elevation(:),YCI,Ypred]; sr1 = sortrows(sr,1);
    h = errorbar(REGION.extratropics_elevation(:),extratropics.bootmean_d18O{1}(:,1),...
        extratropics.bootmean_d18O{1}(:,1)-extratropics.ci{1}(:,1),...
        extratropics.bootmean_d18O{1}(:,1)-extratropics.ci{1}(:,2),...
        'o','MarkerEdgeColor','k','MarkerFaceColor','k','Color',[169 169 169]./255);
    title('Extratropics');
    
elseif k == 6    
    mdl = fitlm(REGION.extratropics_elevation(:),REGION.extratropics_d13C,'linear');
    [Ypred,YCI] = predict(mdl, REGION.extratropics_elevation(:),'alpha',0.1);
    sr = [REGION.extratropics_elevation(:),YCI,Ypred]; sr1 = sortrows(sr,1);
    h = plot(REGION.extratropics_elevation(:),REGION.extratropics_d13C,'LineStyle','none','Color','k',...
        'Marker','o','MarkerFaceColor','k');
end
hold on
h1 = plot(sr1(:,1),sr1(:,4),'Color',[112,160,205]./255,'LineWidth',2);
hold on
h2 = plot(sr1(:,1),sr1(:,2:3),'Color',[196,121,0]./255,'LineStyle','-');    
set(gca,'FontSize',12,'YTickLabel',[]); 
if k == 1 || k == 3 || k == 5
    ylim([-18 0]);
elseif k == 2 || k == 4 || k == 6
    ylim([-15 5]);
    xlabel(['Altitude (m)'],'FontSize',11); 
end
if k == 3 || k == 4 || k == 5 || k == 6
    xlim([-75 2700]);
elseif k == 1 || k == 2
    xlim([-100 4200]);
end
legend('off')
str=strcat(['R²=',num2str(round(mdl.Rsquared.Ordinary,2)),', p=',num2str(round(table2array(mdl.Coefficients(2,4)),1,'significant'))]);
poshS = get(hS,'position'); 
annotation('textbox',poshS,'String',figure_number{k},'FitBoxToText','on','LineStyle','none','FontSize',12);
new_pos = poshS; new_pos(1,2)=new_pos(1,2)-0.12; new_pos(1,4)=new_pos(1,4)-0.02;
annotation('textbox',new_pos,'String',str,'FitBoxToText','on','LineStyle','none','FontSize',10.5);
grid on
end

hL = subplot('Position',[0.1 0.41 0.78 0.1]);
poshL = get(hL,'position'); poshL(1,2)= poshL(1,2)+0.045;
lgd = legend(hL,[h(1),h1(1),h2(1)],'Data','Linear fit','90% conf. bounds'); legend box off;
set(lgd,'position',poshL,'Orientation','horizontal', 'FontSize', 11);
axis(hL,'off');

clear edges h h1 h2 hL hS k lgd m m_width mdl n n_height new_pos poshL poshS ...
   sr sr1 str YCI Ypred figure_number