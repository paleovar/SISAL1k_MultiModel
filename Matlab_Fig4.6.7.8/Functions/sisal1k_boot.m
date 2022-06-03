function [ci,bootstrap] = sisal1k_boot(data,nb)

for i = 1:length(data)
    for j = 1:length(data{i})
        data1 = data{i}(j,:);
        %nobs = numel(data);
        [CI,bootstat] = bootci(nb,{@nanmean,data1},'Alpha',0.1);
        ci{i}(j,1) = CI(1);
        ci{i}(j,2) = CI(2);
        bootstrap{i}(:,j) = bootstat(:);
    end
end
clear bootstat CI data n i j