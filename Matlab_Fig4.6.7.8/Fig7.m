% ------------------------------------------
% cp-2021-152: Figure 7
% ------------------------------------------
%% d18O scatterplot regional (plotted with MATLAB version R2018b)

figure_number_d18O = {'a)','d)','g)','j)','b)','e)','h)','k)','c)','f)','i)','l)'};

figure(3);
clf reset;

m_width = 0.27;
m = [0.075,0.075,0.075,0.075,0.365,0.365,0.365,0.365,0.655,0.655,0.655,0.655,...
    0.075,0.365,0.655];
n_height = 0.165;
n = [0.795,0.57,0.345,0.12,0.795,0.57,0.345,0.12,0.795,0.57,0.345,0.12,0.02,...
    0.02,0.12,0,02];
edges = 0:200:4000;

set(gcf,'Position',[2000 1000 1000 1000])

for k = 1:12
hS = subplot('Position',[m(k) n(k) m_width n_height]);

if k == 1 || k == 2 || k == 3 || k == 4

    e = errorbar(tropics.bootmean_d18O{k+1}(:,1),tropics.bootmean_d18O{1}(:,1),...
        tropics.bootmean_d18O{1}(:,1)-tropics.ci{1}(:,1),...
        tropics.bootmean_d18O{1}(:,1)-tropics.ci{1}(:,2),...
        tropics.bootmean_d18O{k+1}(:,1)-tropics.ci{k+1}(:,1),...
        tropics.bootmean_d18O{k+1}(:,1)-tropics.ci{k+1}(:,2),...
        'o','MarkerEdgeColor','k','MarkerFaceColor','k','Color',[169 169 169]./255);
    hold on
    plot(tropics.linreg_d18O{k+1}(:,1),tropics.linreg_d18O{k+1}(:,4),'Color',[112,160,205]./255,'LineWidth',2)
    hold on
    plot(tropics.linreg_d18O{k+1}(:,1),tropics.linreg_d18O{k+1}(:,2:3),'Color',[196,121,0]./255,'LineStyle','-')

    set(gca,'FontSize',12);
    ylabel('\delta^1^8O_{dweq} (‰)','Interpreter','tex','FontSize',11);
    str=strcat(['R²=',num2str(round(tropics.R_P_d18O{k+1}(1),2)),...
        ', p=',num2str(round(tropics.R_P_d18O{k+1}(2),1,'significant'))]);
    if k == 1
        title('Tropics','FontWeight','normal')
        xlabel(['\delta^1^8O_{iw} (‰)'],'Interpreter','tex','FontSize',11); 
        xlim([-18 0]);
        poshS = get(hS,'position'); 
    elseif k == 2
        s = discretize(REGION.tropics_elevation,edges);
        color_alt = colormap(pink);
        color_alt = color_alt(1:3:end,:); color_alt = color_alt(2:end-1,:);
        for i = 1:length(s)
            color_plot(i,:) = color_alt(s(i),:);
        end
        scatter(tropics.bootmean_d18O{k+1}(:,1),tropics.bootmean_d18O{1}(:,1),...
            40,color_plot,'filled','MarkerEdgeColor','k');
        xlabel(['Temperature (' char(176) 'C)'],'FontSize',11); title('');
        xlim([-5 30]); xticks([0:5:25])
        poshS = get(hS,'position'); 
    elseif k == 3
        scatter(tropics.bootmean_d18O{k+1}(:,1),tropics.bootmean_d18O{1}(:,1),...
            40,color_plot,'filled','MarkerEdgeColor','k');
        xlabel('Precipitation (mm)','FontSize',11); title('');
        xlim([10 5500]); B = [100,1000,5000];
        set(gca,'XScale','log','XTick',B,'XTickLabel',B)
    else
        scatter(tropics.bootmean_d18O{k+1}(:,1),tropics.bootmean_d18O{1}(:,1),...
            40,color_plot,'filled','MarkerEdgeColor','k');
        xlabel('Evaporation (mm)','FontSize',11); title('');
        xlim([10 2500]); B = [100,1000];
        set(gca,'XScale','log','XTick',B,'XTickLabel',B)        
    end   
elseif k == 5 || k == 6 || k == 7 || k == 8
    e = errorbar(subtropics.bootmean_d18O{k-3}(:,1),subtropics.bootmean_d18O{1}(:,1),...
        subtropics.bootmean_d18O{1}(:,1)-subtropics.ci{1}(:,1),...
        subtropics.bootmean_d18O{1}(:,1)-subtropics.ci{1}(:,2),...
        subtropics.bootmean_d18O{k-3}(:,1)-subtropics.ci{k-3}(:,1),...
        subtropics.bootmean_d18O{k-3}(:,1)-subtropics.ci{k-3}(:,2),...
        'o','MarkerEdgeColor','k','MarkerFaceColor','k','Color',[169 169 169]./255);
    hold on
    plot(subtropics.linreg_d18O{k-3}(:,1),subtropics.linreg_d18O{k-3}(:,4),'Color',[112,160,205]./255,'LineWidth',2)
    hold on
    plot(subtropics.linreg_d18O{k-3}(:,1),subtropics.linreg_d18O{k-3}(:,2:3),'Color',[196,121,0]./255,'LineStyle','-')    
    set(gca,'FontSize',12);
    str=strcat(['R²=',num2str(round(subtropics.R_P_d18O{k-3}(1),2)),...
        ', p=',num2str(round(subtropics.R_P_d18O{k-3}(2),1,'significant'))]);
    if k == 5
        title('Subtropics','FontWeight','normal')
        xlabel(['\delta^1^8O_{iw} (‰)'],'Interpreter','tex','FontSize',11); 
        xlim([-18 0]);
        set(gca,'YTickLabel',[],'YLabel',[]);
    elseif k == 6
        s = discretize(REGION.subtropics_elevation,edges);
        color_alt = colormap(pink);
        color_alt = color_alt(1:3:end,:); color_alt = color_alt(2:end-1,:);
        for i = 1:length(s)
            color_plot1(i,:) = color_alt(s(i),:);
        end
        scatter(subtropics.bootmean_d18O{k-3}(:,1),subtropics.bootmean_d18O{1}(:,1),...
            40,color_plot1,'filled','MarkerEdgeColor','k');        
        xlabel(['Temperature (' char(176) 'C)'],'FontSize',11); title('');
        xlim([-5 30]); xticks([0:5:25])
        set(gca,'YTickLabel',[],'YLabel',[]);
    elseif k == 7
        scatter(subtropics.bootmean_d18O{k-3}(:,1),subtropics.bootmean_d18O{1}(:,1),...
            40,color_plot1,'filled','MarkerEdgeColor','k');        
        xlabel('Precipitation (mm)','FontSize',11); title('');
        xlim([10 5500]); B = [100,1000,5000];
        set(gca,'XScale','log','XTick',B,'XTickLabel',B)
        set(gca,'YTickLabel',[],'YLabel',[]);
    else
        scatter(subtropics.bootmean_d18O{k-3}(:,1),subtropics.bootmean_d18O{1}(:,1),...
            40,color_plot1,'filled','MarkerEdgeColor','k');        
        xlabel('Evaporation (mm)','FontSize',11); title('');
        xlim([10 2500]); B = [100,1000];
        set(gca,'XScale','log','XTick',B,'XTickLabel',B)
        set(gca,'YTickLabel',[],'YLabel',[]);
    end   
elseif k == 9 || k == 10 || k == 11 || k == 12
    e = errorbar(extratropics.bootmean_d18O{k-7}(:,1),extratropics.bootmean_d18O{1}(:,1),...
        extratropics.bootmean_d18O{1}(:,1)-extratropics.ci{1}(:,1),...
        extratropics.bootmean_d18O{1}(:,1)-extratropics.ci{1}(:,2),...
        extratropics.bootmean_d18O{k-7}(:,1)-extratropics.ci{k-7}(:,1),...
        extratropics.bootmean_d18O{k-7}(:,1)-extratropics.ci{k-7}(:,2),...
        'o','MarkerEdgeColor','k','MarkerFaceColor','k','Color',[169 169 169]./255);
    hold on
    plot(extratropics.linreg_d18O{k-7}(:,1),extratropics.linreg_d18O{k-7}(:,4),'Color',[112,160,205]./255,'LineWidth',2)
    hold on
    plot(extratropics.linreg_d18O{k-7}(:,1),extratropics.linreg_d18O{k-7}(:,2:3),'Color',[196,121,0]./255,'LineStyle','-')    
    set(gca,'FontSize',12);
    ylabel('\delta^1^8O_{dweq} (‰)','Interpreter','tex','FontSize',11);
    set(gca,'YAxisLocation','right');
    str=strcat(['R²=',num2str(round(extratropics.R_P_d18O{k-7}(1),2)),...
        ', p=',num2str(round(extratropics.R_P_d18O{k-7}(2),1,'significant'))]);
    if k == 9
        title('Extratropics','FontWeight','normal')
        xlabel(['\delta^1^8O_{iw} (‰)'],'Interpreter','tex','FontSize',11); 
        xlim([-18 0]);
    elseif k == 10
        s = discretize(REGION.extratropics_elevation,edges);
        color_alt = colormap(pink);
        color_alt = color_alt(1:3:end,:); color_alt = color_alt(2:end-1,:);
        for i = 1:length(s)
            color_plot2(i,:) = color_alt(s(i),:);
        end
        scatter(extratropics.bootmean_d18O{k-7}(:,1),extratropics.bootmean_d18O{1}(:,1),...
            40,color_plot2,'filled','MarkerEdgeColor','k');  
        xlabel(['Temperature (' char(176) 'C)'],'FontSize',11); title('');
        xlim([-5 30]); xticks([0:5:25])
    elseif k == 11
        scatter(extratropics.bootmean_d18O{k-7}(:,1),extratropics.bootmean_d18O{1}(:,1),...
            40,color_plot2,'filled','MarkerEdgeColor','k');  
        xlabel('Precipitation (mm)','FontSize',11); title('');
        xlim([10 5500]); B = [100,1000,5000];
        set(gca,'XScale','log','XTick',B,'XTickLabel',B)
    else
        scatter(extratropics.bootmean_d18O{k-7}(:,1),extratropics.bootmean_d18O{1}(:,1),...
            40,color_plot2,'filled','MarkerEdgeColor','k');  
        xlabel('Evaporation (mm)','FontSize',11); title('');
        xlim([10 2500]); B = [100,1000];
        set(gca,'XScale','log','XTick',B,'XTickLabel',B)        
    end 
end

ylim([-18 0]);
legend('off')
poshS = get(hS,'position'); 
annotation('textbox',poshS,'String',figure_number_d18O{k},'FitBoxToText','on','LineStyle','none','FontSize',12);
new_pos = poshS; new_pos(1,2)=new_pos(1,2)-0.12; new_pos(1,4)=new_pos(1,4)-0.02;
annotation('textbox',new_pos,'String',str,'FitBoxToText','on','LineStyle','none','FontSize',10.5);
grid on
end

clear B color_alt color_plot color_plot1 color_plot2 e edges figure_number_d18O ...
    hS i k m m_width n n_height new_pos poshS s str
