function [stats, bootmean, linreg, R_P] = sisal1k_linreg_d13C(data_boot,data,n)

mdl = cell(n,1);
for i = 1:length(data_boot)
    for j = 1:n
        mdl{j} = fitlm(data_boot{i}(j,:),data,'linear');
        Rsquared(:,j) = mdl{j}.Rsquared.Ordinary; 
        Pval(:,j) = table2array(mdl{j}.Coefficients(2,4));
        [Ypred(:,j),YCI(:,:,j)] = predict(mdl{j},data_boot{i}(j,:)','alpha',0.1);   % Fitted Regression Line & Confidence Intervals
        CI = nanmean(YCI,3); Pred = nanmean(Ypred,2); Data = nanmean(data_boot{i}',2);
        sr = [Data,CI,Pred]; sr1 = sortrows(sr,1);
        bootmean{i} = Data;
        linreg{i} = sr1;
        R_P{i} = [nanmean(Rsquared),nanmean(Pval)];
        b(:,j) = mdl{j}.Coefficients.Estimate; ci = coefCI(mdl{j},0.1); ci_interp(:,j) = ci(1,:);
        ci_slope(:,j) = ci(2,:);
        p = 90; 
        CIFcn = @(Rquared,p)prctile(Rsquared,abs([0,100]-(100-p)/2));
        CIFcn2 = @(Pval,p)prctile(Pval,abs([0,100]-(100-p)/2));
        stats{i} = array2table([nanmean(Pval),CIFcn2(Pval,p),nanmean(Rsquared),...
            CIFcn(Rsquared,p),nanmean(b(2,:)),nanmean(ci_slope(1,:)),nanmean(ci_slope(2,:)),...
            nanmean(b(1,:)),nanmean(ci_interp(1,:)),nanmean(ci_interp(2,:))]);
        stats{i}.Properties.VariableNames = {'P','P_ci1','P_ci2','Rsquared','R_ci1',...
            'R_ci2','slope','slope_ci1','slope_ci2','intercept','intercept_ci1','intercept_ci2'};
     end
end
clear mdl Ypred YCI CI Pred Data sr sr1 Rsquared Pval b ci p CIFcn CIFcn2 i j ci_interp ...
    ci_slope 