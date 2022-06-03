% ------------------------------------------
% cp-2021-152: Supplement Figure 8
% ------------------------------------------
%% d18O scatterplot Europe, N/C America, S. America (plotted with MATLAB version R2018b)

figure(7);
clf reset;

figure_number_d18O = {'a)','e)','i)','m)','b)','f)','j)','n)','c)','g)','k)','o)',...
    'd)','h)','l)','p)'};
m_width = 0.19;
m = [0.075,0.075,0.075,0.075,0.295,0.295,0.295,0.295,0.515,0.515,0.515,0.515,...
    0.735,0.735,0.735,0.735,0.075,0.295,0.515,0.735];
n_height = 0.12;
n = [0.78,0.60,0.42,0.24,0.78,0.60,0.42,0.24,0.78,0.60,0.42,0.24,...
    0.78,0.60,0.42,0.24,0.12,0.12,0.12,0.12];

edges = 0:200:4000;

set(gcf,'Position',[2000 1000 1000 1000])

for k = 1:16
hS = subplot('Position',[m(k) n(k) m_width n_height]);

if k == 1 || k == 2 || k == 3 || k == 4
    e = errorbar(CONTINENT.europe_bootmean_d18O{k+1}(:,1),CONTINENT.europe_bootmean_d18O{1}(:,1),...
        CONTINENT.europe_bootmean_d18O{1}(:,1)-CONTINENT.europe_ci{1}(:,1),...
        CONTINENT.europe_bootmean_d18O{1}(:,1)-CONTINENT.europe_ci{1}(:,2),...
        CONTINENT.europe_bootmean_d18O{k+1}(:,1)-CONTINENT.europe_ci{k+1}(:,1),...
        CONTINENT.europe_bootmean_d18O{k+1}(:,1)-CONTINENT.europe_ci{k+1}(:,2),...
        'o','MarkerEdgeColor','k','MarkerFaceColor','k','Color',[169 169 169]./255);
    hold on
    plot(CONTINENT.europe_linreg_d18O{k+1}(:,1),CONTINENT.europe_linreg_d18O{k+1}(:,4),'Color',[112,160,205]./255,'LineWidth',2)
    hold on
    plot(CONTINENT.europe_linreg_d18O{k+1}(:,1),CONTINENT.europe_linreg_d18O{k+1}(:,2:3),'Color',[196,121,0]./255,'LineStyle','-')
    set(gca,'FontSize',12);
    ylabel('\delta^1^8O_{dweq} (‰)','Interpreter','tex','FontSize',11);
    str=strcat(['R²=',num2str(round(CONTINENT.europe_R_P_d18O{k+1}(1),2)),...
        ', p=',num2str(round(CONTINENT.europe_R_P_d18O{k+1}(2),1,'significant'))]);
    if k == 1
        title('Europe','FontWeight','normal')
        xlabel(['\delta^1^8O_{iw} (‰)'],'Interpreter','tex','FontSize',11); 
        xlim([-18 0]);
        poshS = get(hS,'position'); 
    elseif k == 2
        s = discretize(CONTINENT.europe_elevation,edges);
        color_alt = colormap(pink);
        color_alt = color_alt(1:3:end,:); color_alt = color_alt(2:end-1,:);
        for i = 1:length(s)
            color_plot(i,:) = color_alt(s(i),:);
        end
        scatter(CONTINENT.europe_bootmean_d18O{k+1}(:,1),CONTINENT.europe_bootmean_d18O{1}(:,1),...
            40,color_plot,'filled','MarkerEdgeColor','k');
        xlabel(['Temperature (' char(176) 'C)'],'FontSize',11); title('');
        xlim([-5 30]); xticks([0:5:25])
        poshS = get(hS,'position'); 
    elseif k == 3
        scatter(CONTINENT.europe_bootmean_d18O{k+1}(:,1),CONTINENT.europe_bootmean_d18O{1}(:,1),...
            40,color_plot,'filled','MarkerEdgeColor','k');
        xlabel('Precipitation (mm)','FontSize',11); title('');
        xlim([100 5500]); B = [1000,5000];
        set(gca,'XScale','log','XTick',B,'XTickLabel',B)
    else
        scatter(CONTINENT.europe_bootmean_d18O{k+1}(:,1),CONTINENT.europe_bootmean_d18O{1}(:,1),...
            40,color_plot,'filled','MarkerEdgeColor','k');
        xlabel('Evaporation (mm)','FontSize',11); title('');
        xlim([100 2500]); B = [100,1000];
        set(gca,'XScale','log','XTick',B,'XTickLabel',B)        
    end   
elseif k == 5 || k == 6 || k == 7 || k == 8
    e = errorbar(CONTINENT.ncamerica_bootmean_d18O{k-3}(:,1),CONTINENT.ncamerica_bootmean_d18O{1}(:,1),...
        CONTINENT.ncamerica_bootmean_d18O{1}(:,1)-CONTINENT.ncamerica_ci{1}(:,1),...
        CONTINENT.ncamerica_bootmean_d18O{1}(:,1)-CONTINENT.ncamerica_ci{1}(:,2),...
        CONTINENT.ncamerica_bootmean_d18O{k-3}(:,1)-CONTINENT.ncamerica_ci{k-3}(:,1),...
        CONTINENT.ncamerica_bootmean_d18O{k-3}(:,1)-CONTINENT.ncamerica_ci{k-3}(:,2),...
        'o','MarkerEdgeColor','k','MarkerFaceColor','k','Color',[169 169 169]./255);
    hold on
    plot(CONTINENT.ncamerica_linreg_d18O{k-3}(:,1),CONTINENT.ncamerica_linreg_d18O{k-3}(:,4),'Color',[112,160,205]./255,'LineWidth',2)
    hold on
    plot(CONTINENT.ncamerica_linreg_d18O{k-3}(:,1),CONTINENT.ncamerica_linreg_d18O{k-3}(:,2:3),'Color',[196,121,0]./255,'LineStyle','-')
    set(gca,'FontSize',12);
    ylabel('\delta^1^8O_{dweq} (‰)','Interpreter','tex','FontSize',11);
    str=strcat(['R²=',num2str(round(CONTINENT.ncamerica_R_P_d18O{k-3}(1),2)),...
        ', p=',num2str(round(CONTINENT.ncamerica_R_P_d18O{k-3}(2),1,'significant'))]);    
    if k == 5
        title('N./C. America','FontWeight','normal')
        xlabel(['\delta^1^8O_{iw} (‰)'],'Interpreter','tex','FontSize',11);
        xlim([-18 0]);
        set(gca,'YTickLabel',[],'YLabel',[]);
    elseif k == 6
        s = discretize(CONTINENT.ncamerica_elevation,edges);
        color_alt = colormap(pink);
        color_alt = color_alt(1:3:end,:); color_alt = color_alt(2:end-1,:);
        for i = 1:length(s)
            color_plot1(i,:) = color_alt(s(i),:);
        end
        scatter(CONTINENT.ncamerica_bootmean_d18O{k-3}(:,1),CONTINENT.ncamerica_bootmean_d18O{1}(:,1),...
            40,color_plot1,'filled','MarkerEdgeColor','k');
        xlabel(['Temperature (' char(176) 'C)'],'FontSize',11); title('');
        xlim([-5 30]); xticks([0:5:25])
        set(gca,'YTickLabel',[],'YLabel',[]);
    elseif k == 7
        scatter(CONTINENT.ncamerica_bootmean_d18O{k-3}(:,1),CONTINENT.ncamerica_bootmean_d18O{1}(:,1),...
            40,color_plot1,'filled','MarkerEdgeColor','k');
        xlabel('Precipitation (mm)','FontSize',11); title('');
        xlim([100 5500]); B = [1000,5000];
        set(gca,'XScale','log','XTick',B,'XTickLabel',B)
        set(gca,'YTickLabel',[],'YLabel',[]);
    else
        scatter(CONTINENT.ncamerica_bootmean_d18O{k-3}(:,1),CONTINENT.ncamerica_bootmean_d18O{1}(:,1),...
            40,color_plot1,'filled','MarkerEdgeColor','k');
        xlabel('Evaporation (mm)','FontSize',11); title('');
        xlim([100 2500]); B = [100,1000];
        set(gca,'XScale','log','XTick',B,'XTickLabel',B)
        set(gca,'YTickLabel',[],'YLabel',[]);
    end   
elseif k == 9 || k == 10 || k == 11 || k == 12
    e = errorbar(CONTINENT.samerica_bootmean_d18O{k-7}(:,1),CONTINENT.samerica_bootmean_d18O{1}(:,1),...
        CONTINENT.samerica_bootmean_d18O{1}(:,1)-CONTINENT.samerica_ci{1}(:,1),...
        CONTINENT.samerica_bootmean_d18O{1}(:,1)-CONTINENT.samerica_ci{1}(:,2),...
        CONTINENT.samerica_bootmean_d18O{k-7}(:,1)-CONTINENT.samerica_ci{k-7}(:,1),...
        CONTINENT.samerica_bootmean_d18O{k-7}(:,1)-CONTINENT.samerica_ci{k-7}(:,2),...
        'o','MarkerEdgeColor','k','MarkerFaceColor','k','Color',[169 169 169]./255);
    hold on
    plot(CONTINENT.samerica_linreg_d18O{k-7}(:,1),CONTINENT.samerica_linreg_d18O{k-7}(:,4),'Color',[112,160,205]./255,'LineWidth',2)
    hold on
    plot(CONTINENT.samerica_linreg_d18O{k-7}(:,1),CONTINENT.samerica_linreg_d18O{k-7}(:,2:3),'Color',[196,121,0]./255,'LineStyle','-')
    set(gca,'FontSize',12);
    ylabel('\delta^1^8O_{dweq} (‰)','Interpreter','tex','FontSize',11);
    str=strcat(['R²=',num2str(round(CONTINENT.samerica_R_P_d18O{k-7}(1),2)),...
        ', p=',num2str(round(CONTINENT.samerica_R_P_d18O{k-7}(2),1,'significant'))]); 
    if k == 9
        title('S. America','FontWeight','normal')
        xlabel(['\delta^1^8O_{iw} (‰)'],'Interpreter','tex','FontSize',11);
        xlim([-18 0]);
        set(gca,'YTickLabel',[],'YLabel',[]);
    elseif k == 10
        s = discretize(CONTINENT.samerica_elevation,edges);
        color_alt = colormap(pink);
        color_alt = color_alt(1:3:end,:); color_alt = color_alt(2:end-1,:);
        for i = 1:length(s)
            color_plot2(i,:) = color_alt(s(i),:);
        end
        scatter(CONTINENT.samerica_bootmean_d18O{k-7}(:,1),CONTINENT.samerica_bootmean_d18O{1}(:,1),...
            40,color_plot2,'filled','MarkerEdgeColor','k');
        xlabel(['Temperature (' char(176) 'C)'],'FontSize',11); title('');
        xlim([-5 30]); xticks([0:5:25])
        set(gca,'YTickLabel',[],'YLabel',[]);
    elseif k == 11
        scatter(CONTINENT.samerica_bootmean_d18O{k-7}(:,1),CONTINENT.samerica_bootmean_d18O{1}(:,1),...
            40,color_plot2,'filled','MarkerEdgeColor','k');
        xlabel('Precipitation (mm)','FontSize',11); title('');
        xlim([100 5500]); B = [1000,5000];
        set(gca,'XScale','log','XTick',B,'XTickLabel',B)
        set(gca,'YTickLabel',[],'YLabel',[]);
    else
        scatter(CONTINENT.samerica_bootmean_d18O{k-7}(:,1),CONTINENT.samerica_bootmean_d18O{1}(:,1),...
            40,color_plot2,'filled','MarkerEdgeColor','k');
        xlabel('Evaporation (mm)','FontSize',11); title('');
        xlim([100 2500]); B = [100,1000];
        set(gca,'XScale','log','XTick',B,'XTickLabel',B)        
        set(gca,'YTickLabel',[],'YLabel',[]);
    end 
elseif k == 13 || k == 14 || k == 15 || k == 16
    e = errorbar(CONTINENT.easia_bootmean_d18O{k-11}(:,1),CONTINENT.easia_bootmean_d18O{1}(:,1),...
        CONTINENT.easia_bootmean_d18O{1}(:,1)-CONTINENT.easia_ci{1}(:,1),...
        CONTINENT.easia_bootmean_d18O{1}(:,1)-CONTINENT.easia_ci{1}(:,2),...
        CONTINENT.easia_bootmean_d18O{k-11}(:,1)-CONTINENT.easia_ci{k-11}(:,1),...
        CONTINENT.easia_bootmean_d18O{k-11}(:,1)-CONTINENT.easia_ci{k-11}(:,2),...
        'o','MarkerEdgeColor','k','MarkerFaceColor','k','Color',[169 169 169]./255);
    hold on
    plot(CONTINENT.easia_linreg_d18O{k-11}(:,1),CONTINENT.easia_linreg_d18O{k-11}(:,4),'Color',[112,160,205]./255,'LineWidth',2)
    hold on
    plot(CONTINENT.easia_linreg_d18O{k-11}(:,1),CONTINENT.easia_linreg_d18O{k-11}(:,2:3),'Color',[196,121,0]./255,'LineStyle','-')
    set(gca,'FontSize',12);
    ylabel('\delta^1^8O_{dweq} (‰)','Interpreter','tex','FontSize',11);
    str=strcat(['R²=',num2str(round(CONTINENT.easia_R_P_d18O{k-11}(1),2)),...
        ', p=',num2str(round(CONTINENT.easia_R_P_d18O{k-11}(2),1,'significant'))]); 
    set(gca,'YAxisLocation','right');
    if k == 13
        title('E. Asia','FontWeight','normal')
        xlabel(['\delta^1^8O_{iw} (‰)'],'Interpreter','tex','FontSize',11);
        xlim([-18 0]);
    elseif k == 14
        s = discretize(CONTINENT.easia_elevation,edges);
        color_alt = colormap(pink);
        color_alt = color_alt(1:3:end,:); color_alt = color_alt(2:end-1,:);
        for i = 1:length(s)
            color_plot3(i,:) = color_alt(s(i),:);
        end
        scatter(CONTINENT.easia_bootmean_d18O{k-11}(:,1),CONTINENT.easia_bootmean_d18O{1}(:,1),...
            40,color_plot3,'filled','MarkerEdgeColor','k');
        xlabel(['Temperature (' char(176) 'C)'],'FontSize',11); title('');
        xlim([-5 30]); xticks([0:5:25])
    elseif k == 15
        scatter(CONTINENT.easia_bootmean_d18O{k-11}(:,1),CONTINENT.easia_bootmean_d18O{1}(:,1),...
            40,color_plot3,'filled','MarkerEdgeColor','k');
        xlabel('Precipitation (mm)','FontSize',11); title('');
        xlim([100 5500]); B = [1000,5000];
        set(gca,'XScale','log','XTick',B,'XTickLabel',B)
    else
        scatter(CONTINENT.easia_bootmean_d18O{k-11}(:,1),CONTINENT.easia_bootmean_d18O{1}(:,1),...
            40,color_plot3,'filled','MarkerEdgeColor','k');
        xlabel('Evaporation (mm)','FontSize',11); title('');
        xlim([100 2500]); B = [100,1000];
        set(gca,'XScale','log','XTick',B,'XTickLabel',B)        
    end 
end

ylim([-18 0]);
legend('off')
poshS = get(hS,'position'); 
annotation('textbox',poshS,'String',figure_number_d18O{k},'FitBoxToText','on','LineStyle','none','FontSize',12);
new_pos = poshS; new_pos(1,2)=new_pos(1,2)-0.12; new_pos(1,4)=new_pos(1,4)+0.021;
annotation('textbox',new_pos,'String',str,'FitBoxToText','on','LineStyle','none','FontSize',10.5);
grid on
end

clear B color_alt color_plot* e edges hS i k lgd m m_width n n_height new_pos poshS ...
    s str figure_number_d18O