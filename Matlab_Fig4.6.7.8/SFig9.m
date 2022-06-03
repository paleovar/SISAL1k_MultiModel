% ------------------------------------------
% cp-2021-152: Supplement Figure 9
% ------------------------------------------
%% d13C scatterplot Europe, N/C America, S. America (plotted with MATLAB version R2018b)

figure(8);
clf reset;

figure_number_d13C = {'a)','e)','i)','b)','f)','j)','c)','g)','k)','d)','h)','l)'};
m_width = 0.19;
m = [0.075,0.075,0.075,0.295,0.295,0.295,0.515,0.515,0.515,...
    0.735,0.735,0.735,0.075,0.295,0.515,0.735,0.075,0.295,0.515,0.735];
n_height = 0.12;
n = [0.78,0.60,0.42,0.78,0.60,0.42,0.78,0.60,0.42,...
    0.78,0.60,0.42,0.24,0.24,0.24,0.24,0.12,0.12,0.12,0.12];

edges = 0:200:4000;

set(gcf,'Position',[2000 1000 1000 1000])

for k = 1:12
hS = subplot('Position',[m(k) n(k) m_width n_height]);

if k == 1 || k == 2 || k == 3
    e = errorbar(CONTINENT.europe_bootmean_d13C{k+2}(:,1),CONTINENT.europe_d13C,...
        CONTINENT.europe_bootmean_d13C{k+2}(:,1)-CONTINENT.europe_ci{k+2}(:,1),...
        CONTINENT.europe_bootmean_d13C{k+2}(:,1)-CONTINENT.europe_ci{k+2}(:,2),...
        'horizontal','o','MarkerEdgeColor','k','MarkerFaceColor','k','Color',[169 169 169]./255);
    hold on
    plot(CONTINENT.europe_linreg_d13C{k+2}(:,1),CONTINENT.europe_linreg_d13C{k+2}(:,4),'Color',[112,160,205]./255,'LineWidth',2)
    hold on
    plot(CONTINENT.europe_linreg_d13C{k+2}(:,1),CONTINENT.europe_linreg_d13C{k+2}(:,2:3),'Color',[196,121,0]./255,'LineStyle','-')
    set(gca,'FontSize',12);
    ylabel('\delta^1^3C_{c} (‰)','Interpreter','tex','FontSize',11);
    str=strcat(['R²=',num2str(round(CONTINENT.europe_R_P_d13C{k+2}(1),2)),', p=',num2str(round(CONTINENT.europe_R_P_d13C{k+2}(2),1,'significant'))]);
    if k == 1
        s = discretize(CONTINENT.europe_elevation,edges);
        color_alt = colormap(pink);
        color_alt = color_alt(1:3:end,:); color_alt = color_alt(2:end-1,:);
        for i = 1:length(s)
            color_plot(i,:) = color_alt(s(i),:);
        end
        scatter(CONTINENT.europe_bootmean_d13C{k+2}(:,1),CONTINENT.europe_d13C,...
            40,color_plot,'filled','MarkerEdgeColor','k');
        title('Europe','FontWeight','normal')
        xlabel(['Temperature (' char(176) 'C)'],'FontSize',11); title('');
        xlim([-5 30]); xticks([0:5:25])
        poshS = get(hS,'position'); 
    elseif k == 2
        scatter(CONTINENT.europe_bootmean_d13C{k+2}(:,1),CONTINENT.europe_d13C,...
            40,color_plot,'filled','MarkerEdgeColor','k');
        xlabel('Precipitation (mm)','FontSize',11); title('');
        xlim([100 5500]); B = [1000,5000];
        set(gca,'XScale','log','XTick',B,'XTickLabel',B)
    else
        scatter(CONTINENT.europe_bootmean_d13C{k+2}(:,1),CONTINENT.europe_d13C,...
            40,color_plot,'filled','MarkerEdgeColor','k');
        xlabel('Evaporation (mm)','FontSize',11); title('');
        xlim([100 2500]); B = [100,1000];
        set(gca,'XScale','log','XTick',B,'XTickLabel',B)        
    end   
elseif k == 4 || k == 5 || k == 6 
    e = errorbar(CONTINENT.ncamerica_bootmean_d13C{k-1}(:,1),CONTINENT.ncamerica_d13C,...
        CONTINENT.ncamerica_bootmean_d13C{k-1}(:,1)-CONTINENT.ncamerica_ci{k-1}(:,1),...
        CONTINENT.ncamerica_bootmean_d13C{k-1}(:,1)-CONTINENT.ncamerica_ci{k-1}(:,2),...
        'horizontal','o','MarkerEdgeColor','k','MarkerFaceColor','k','Color',[169 169 169]./255);
    hold on
    plot(CONTINENT.ncamerica_linreg_d13C{k-1}(:,1),CONTINENT.ncamerica_linreg_d13C{k-1}(:,4),'Color',[112,160,205]./255,'LineWidth',2)
    hold on
    plot(CONTINENT.ncamerica_linreg_d13C{k-1}(:,1),CONTINENT.ncamerica_linreg_d13C{k-1}(:,2:3),'Color',[196,121,0]./255,'LineStyle','-')
    set(gca,'FontSize',12);
    ylabel('\delta^1^3C_{dweq} (‰)','Interpreter','tex','FontSize',11);
    str=strcat(['R²=',num2str(round(CONTINENT.ncamerica_R_P_d13C{k-1}(1),2)),', p=',num2str(round(CONTINENT.ncamerica_R_P_d13C{k-1}(2),1,'significant'))]);
    if k == 4
        s = discretize(CONTINENT.ncamerica_elevation,edges);
        color_alt = colormap(pink);
        color_alt = color_alt(1:3:end,:); color_alt = color_alt(2:end-1,:);
        for i = 1:length(s)
            color_plot1(i,:) = color_alt(s(i),:);
        end
        scatter(CONTINENT.ncamerica_bootmean_d13C{k-1}(:,1),CONTINENT.ncamerica_d13C,...
            40,color_plot1,'filled','MarkerEdgeColor','k');
        title('N./C. America','FontWeight','normal')
        xlabel(['Temperature (' char(176) 'C)'],'FontSize',11); title('');
        xlim([-5 30]); xticks([0:5:25])
        set(gca,'YTickLabel',[],'YLabel',[]);
    elseif k == 5
        scatter(CONTINENT.ncamerica_bootmean_d13C{k-1}(:,1),CONTINENT.ncamerica_d13C,...
            40,color_plot1,'filled','MarkerEdgeColor','k');
        xlabel('Precipitation (mm)','FontSize',11); title('');
        xlim([100 5500]); B = [1000,5000];
        set(gca,'XScale','log','XTick',B,'XTickLabel',B)
        set(gca,'YTickLabel',[],'YLabel',[]);
    else%if k == 4
        scatter(CONTINENT.ncamerica_bootmean_d13C{k-1}(:,1),CONTINENT.ncamerica_d13C,...
            40,color_plot1,'filled','MarkerEdgeColor','k');
        xlabel('Evaporation (mm)','FontSize',11); title('');
        xlim([100 2500]); B = [100,1000];
        set(gca,'XScale','log','XTick',B,'XTickLabel',B)
        set(gca,'YTickLabel',[],'YLabel',[]);
    end   
elseif k == 7 || k == 8 || k == 9
    e = errorbar(CONTINENT.samerica_bootmean_d13C{k-4}(:,1),CONTINENT.samerica_d13C,...
        CONTINENT.samerica_bootmean_d13C{k-4}(:,1)-CONTINENT.samerica_ci{k-4}(:,1),...
        CONTINENT.samerica_bootmean_d13C{k-4}(:,1)-CONTINENT.samerica_ci{k-4}(:,2),...
        'horizontal','o','MarkerEdgeColor','k','MarkerFaceColor','k','Color',[169 169 169]./255);
    hold on
    plot(CONTINENT.samerica_linreg_d13C{k-4}(:,1),CONTINENT.samerica_linreg_d13C{k-4}(:,4),'Color',[112,160,205]./255,'LineWidth',2)
    hold on
    plot(CONTINENT.samerica_linreg_d13C{k-4}(:,1),CONTINENT.samerica_linreg_d13C{k-4}(:,2:3),'Color',[196,121,0]./255,'LineStyle','-')
    set(gca,'FontSize',12);
    ylabel('\delta^1^3C_{dweq} (‰)','Interpreter','tex','FontSize',11);
    str=strcat(['R²=',num2str(round(CONTINENT.samerica_R_P_d13C{k-4}(1),2)),', p=',num2str(round(CONTINENT.samerica_R_P_d13C{k-4}(2),1,'significant'))]);
    if k == 7
        s = discretize(CONTINENT.samerica_elevation,edges);
        color_alt = colormap(pink);
        color_alt = color_alt(1:3:end,:); color_alt = color_alt(2:end-1,:);
        for i = 1:length(s)
            color_plot2(i,:) = color_alt(s(i),:);
        end
        scatter(CONTINENT.samerica_bootmean_d13C{k-4}(:,1),CONTINENT.samerica_d13C,...
            40,color_plot2,'filled','MarkerEdgeColor','k');
        title('S. America','FontWeight','normal')
        xlabel(['Temperature (' char(176) 'C)'],'FontSize',11); title('');
        xlim([-5 30]); xticks([0:5:25])
        set(gca,'YTickLabel',[],'YLabel',[]);
    elseif k == 8
        scatter(CONTINENT.samerica_bootmean_d13C{k-4}(:,1),CONTINENT.samerica_d13C,...
            40,color_plot2,'filled','MarkerEdgeColor','k');
        xlabel('Precipitation (mm)','FontSize',11); title('');
        xlim([100 5500]); B = [1000,5000];
        set(gca,'XScale','log','XTick',B,'XTickLabel',B)
        set(gca,'YTickLabel',[],'YLabel',[]);
    else%if k == 4
        scatter(CONTINENT.samerica_bootmean_d13C{k-4}(:,1),CONTINENT.samerica_d13C,...
            40,color_plot2,'filled','MarkerEdgeColor','k');
        xlabel('Evaporation (mm)','FontSize',11); title('');
        xlim([100 2500]); B = [100,1000];
        set(gca,'XScale','log','XTick',B,'XTickLabel',B)
        set(gca,'YTickLabel',[],'YLabel',[]);
    end 
elseif k == 10 || k == 11 || k == 12
    e = errorbar(CONTINENT.easia_bootmean_d13C{k-7}(:,1),CONTINENT.easia_d13C,...
        CONTINENT.easia_bootmean_d13C{k-7}(:,1)-CONTINENT.easia_ci{k-7}(:,1),...
        CONTINENT.easia_bootmean_d13C{k-7}(:,1)-CONTINENT.easia_ci{k-7}(:,2),...
        'horizontal','o','MarkerEdgeColor','k','MarkerFaceColor','k','Color',[169 169 169]./255);
    hold on
    plot(CONTINENT.easia_linreg_d13C{k-7}(:,1),CONTINENT.easia_linreg_d13C{k-7}(:,4),'Color',[112,160,205]./255,'LineWidth',2)
    hold on
    plot(CONTINENT.easia_linreg_d13C{k-7}(:,1),CONTINENT.easia_linreg_d13C{k-7}(:,2:3),'Color',[196,121,0]./255,'LineStyle','-')
    set(gca,'FontSize',12);
    ylabel('\delta^1^3C_{c} (‰)','Interpreter','tex','FontSize',11);
    str=strcat(['R²=',num2str(round(CONTINENT.easia_R_P_d13C{k-7}(1),2)),', p=',num2str(round(CONTINENT.easia_R_P_d13C{k-7}(2),1,'significant'))]);
    set(gca,'YAxisLocation','right');
    if k == 10
        s = discretize(CONTINENT.easia_elevation,edges);
        color_alt = colormap(pink);
        color_alt = color_alt(1:3:end,:); color_alt = color_alt(2:end-1,:);
        for i = 1:length(s)
            color_plot2(i,:) = color_alt(s(i),:);
        end
        scatter(CONTINENT.easia_bootmean_d13C{k-7}(:,1),CONTINENT.easia_d13C,...
            40,color_plot2,'filled','MarkerEdgeColor','k');
        title('S. America','FontWeight','normal')
        xlabel(['Temperature (' char(176) 'C)'],'FontSize',11); title('');
        xlim([-5 30]); xticks([0:5:25])
    elseif k == 11
        scatter(CONTINENT.easia_bootmean_d13C{k-7}(:,1),CONTINENT.easia_d13C,...
            40,color_plot2,'filled','MarkerEdgeColor','k');
        xlabel('Precipitation (mm)','FontSize',11); title('');
        xlim([100 5500]); B = [1000,5000];
        set(gca,'XScale','log','XTick',B,'XTickLabel',B)
    else
        scatter(CONTINENT.easia_bootmean_d13C{k-7}(:,1),CONTINENT.easia_d13C,...
            40,color_plot2,'filled','MarkerEdgeColor','k');
        xlabel('Evaporation (mm)','FontSize',11); title('');
        xlim([100 2500]); B = [100,1000];
        set(gca,'XScale','log','XTick',B,'XTickLabel',B)        
    end
end

ylim([-15 5]);
legend('off')
poshS = get(hS,'position'); 
annotation('textbox',poshS,'String',figure_number_d13C{k},'FitBoxToText','on','LineStyle','none','FontSize',12);
new_pos = poshS; new_pos(1,2)=new_pos(1,2)-0.12; new_pos(1,4)=new_pos(1,4)+0.021;
annotation('textbox',new_pos,'String',str,'FitBoxToText','on','LineStyle','none','FontSize',10.5);
grid on
end

clear B color_alt color_plot* e edges hS i k lgd m m_width n n_height new_pos poshS ...
    s str figure_number_d18O