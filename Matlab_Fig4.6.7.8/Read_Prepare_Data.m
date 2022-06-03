%%-------------------------------------------------------------------------
% *Read in and prepare data* 
% 
% Manuscript: cp-2021-152
% Author: Josefine Axelsson (josefine.axelsson@natgeo.su.se)
% Date: 2022-05-23
% Version: MATLAB R2021a
%--------------------------------------------------------------------------

%% Read in data
% Models
opts = detectImportOptions('Data/SISAL1k_ds_CESM.csv');
opts.VariableTypes = {'double','double','double','char','double','double','double','double','double','double','double','double','double'};
SISAL1kdsCESM = readtable('Data/SISAL1k_ds_CESM.csv',opts);
SISAL1kdsECHAM5 = readtable('Data/SISAL1k_ds_ECHAM5.csv',opts);
SISAL1kdsGISS = readtable('Data/SISAL1k_ds_GISS.csv',opts);
SISAL1kdsHadCM3 = readtable('Data/SISAL1k_ds_HadCM3.csv',opts);
SISAL1kdsisoGSM = readtable('Data/SISAL1k_ds_isoGSM.csv',opts);
% Entity info
opts = detectImportOptions('Data/SISAL1k_entity_info.csv');
SISAL1kentityinfo = readtable('Data/SISAL1k_entity_info.csv',opts);

clear opts

%% Prepare matrices

% Extracting variables from table, including: d18O_dweq, temperature, 
% precipitation, simulated d18O, simulated d18O (weighed with p-e), 
% evaporation
CESM = table2array(SISAL1kdsCESM(:,[7 9 10 11 12 13]));
ECHAM5 = table2array(SISAL1kdsECHAM5(:,[7 9 10 11 12 13]));
GISS = table2array(SISAL1kdsGISS(:,[7 9 10 11 12 13])); GISS(679:926,:) = nan;
HadCM3 = table2array(SISAL1kdsHadCM3(:,[7 9 10 11 12 13]));
isoGSM = table2array(SISAL1kdsisoGSM(:,[7 9 10 11 12 13]));

% Extracting variables from table, including: site_id, entity_id,  
% year BP, speleothem d18O, speleothem d13C
SISAL = [table2array(SISAL1kdsCESM(:,[1 2 3 5 6]))];

% Entity means of all variables
SISALv2 = {}; % Cell structure
SISALv2.recordsData = [SISAL];
[a,~,c] = unique(SISALv2.recordsData(:,2));

% Basing entity mean from SISAL data
SISALv2.d18O = [a, accumarray(c,SISALv2.recordsData(:,4),[],@nanmean)];
SISALv2.d13C = [a, accumarray(c,SISALv2.recordsData(:,5),[],@nanmean)];
d13C_dweq = [table2array(SISAL1kdsCESM(:,8))];

% Entity mean (model variables)
for i = 1:size(CESM,2)
    out = [a, accumarray(c,CESM(:,i),[],@nanmean)];
    SISALv2.CESM(:,i) = out(:,2);
end
for i = 1:size(ECHAM5,2)
    out = [a, accumarray(c,ECHAM5(:,i),[],@nanmean)];
    SISALv2.ECHAM5(:,i) = out(:,2);
end
for i = 1:size(GISS,2)
    out = [a, accumarray(c,GISS(:,i),[],@nanmean)];
    SISALv2.GISS(:,i) = out(:,2);
end
for i = 1:size(HadCM3,2)
    out = [a, accumarray(c,HadCM3(:,i),[],@nanmean)];
    SISALv2.HadCM3(:,i) = out(:,2);
end
for i = 1:size(isoGSM,2)
    out = [a, accumarray(c,isoGSM(:,i),[],@nanmean)];
    SISALv2.isoGSM(:,i) = out(:,2);
end
for i = 1:size(d13C_dweq,2)
    out = [a, accumarray(c,d13C_dweq(:,i),[],@nanmean)];
    SISALv2.d13C_dweq(:,i) = out(:,2);
end

% Sort rows based on entity ID
SISAL1kentity = sortrows(SISAL1kentityinfo,2);

% Remove variables and tables not longer needed
clear SISAL1kdsCESM SISAL1kdsECHAM5 SISAL1kdsGISS SISAL1kdsHadCM3 SISAL1kdsisoGSM
clear a b c i out opts CESM ECHAM5 HadCM3 isoGSM GISS SISAL d13C_dweq

%% Create indices

SISAL1kentity_matrix = SISAL1kentity{:,1:5};

% Tropics (-23.44 to 23.44'N)
tropics_idx = SISAL1kentity_matrix(:,3) <= 23.44 & SISAL1kentity_matrix(:,3) >=-23.44;

% Subtropics (-35 to -23.44'N, 23.44 to 35'N)
subtropics_idx1 = SISAL1kentity_matrix(:,3) >= 23.44 & SISAL1kentity_matrix(:,3) <= 35;
subtropics_idx2 = SISAL1kentity_matrix(:,3) <= -23.44 & SISAL1kentity_matrix(:,3) >= -35;
subtropics_idx = logical(subtropics_idx1 + subtropics_idx2);
clear subtropics_idx1 subtropics_idx2

% Extratropics (>= 35'N, <= -35'N
extratropics_idx1 = SISAL1kentity_matrix(:,3) >= 35; 
extratropics_idx2 = SISAL1kentity_matrix(:,3) <= -35;
extratropics_idx = logical(extratropics_idx1 + extratropics_idx2);
clear extratropics_idx1 extratropics_idx2

%% Cells with regional data based on indices

REGION = {}; % Cell structure

% Temperature=2, Precipitation=5, Evaporation=10, dweq=1, modelISOT=6, wp=7, wif=8

% Cells: {1} Tropics_calc, {2} Subtropics_calc, {3} Extratropics_calc
% Variables in each cell: {1} speleothem_d18O_dweq, {2} sim_d18O (wp/wif),
% {3} sim_temp_mean, {4} sim_prec_mean, {5} sim_evap_mean

% Tropics
REGION.tropics = cell(5,1);
REGION.tropics{1} = [SISALv2.HadCM3(tropics_idx,1),SISALv2.ECHAM5(tropics_idx,1),...
    SISALv2.isoGSM(tropics_idx,1),SISALv2.CESM(tropics_idx,1),SISALv2.GISS(tropics_idx,1)];
REGION.tropics{2} = [SISALv2.HadCM3(tropics_idx,5),SISALv2.ECHAM5(tropics_idx,5),...
    SISALv2.isoGSM(tropics_idx,5),SISALv2.CESM(tropics_idx,5),SISALv2.GISS(tropics_idx,5)];
for i = 3:5
        if i == 3
            n = 2;
            REGION.tropics{i} = [SISALv2.HadCM3(tropics_idx,n),SISALv2.ECHAM5(tropics_idx,n),...
                SISALv2.isoGSM(tropics_idx,n),SISALv2.CESM(tropics_idx,n),SISALv2.GISS(tropics_idx,n)];
        elseif i == 4
            n = 3;
            REGION.tropics{i} = [SISALv2.HadCM3(tropics_idx,n),SISALv2.ECHAM5(tropics_idx,n),...
                SISALv2.isoGSM(tropics_idx,n),SISALv2.CESM(tropics_idx,n),SISALv2.GISS(tropics_idx,n)];
        else
            n = 6;
            REGION.tropics{i} = [SISALv2.HadCM3(tropics_idx,n),SISALv2.ECHAM5(tropics_idx,n),...
                SISALv2.isoGSM(tropics_idx,n)];
        end
end

% Subtropics
REGION.subtropics = cell(5,1);
REGION.subtropics{1} = [SISALv2.HadCM3(subtropics_idx,1),SISALv2.ECHAM5(subtropics_idx,1),...
    SISALv2.isoGSM(subtropics_idx,1),SISALv2.CESM(subtropics_idx,1),SISALv2.GISS(subtropics_idx,1)];
REGION.subtropics{2} = [SISALv2.HadCM3(subtropics_idx,5),SISALv2.ECHAM5(subtropics_idx,5),...
    SISALv2.isoGSM(subtropics_idx,5),SISALv2.CESM(subtropics_idx,5),SISALv2.GISS(subtropics_idx,5)];
for i = 3:5
        if i == 3
            n = 2;
            REGION.subtropics{i} = [SISALv2.HadCM3(subtropics_idx,n),SISALv2.ECHAM5(subtropics_idx,n),...
                SISALv2.isoGSM(subtropics_idx,n),SISALv2.CESM(subtropics_idx,n),SISALv2.GISS(subtropics_idx,n)];
        elseif i == 4
            n = 3;
            REGION.subtropics{i} = [SISALv2.HadCM3(subtropics_idx,n),SISALv2.ECHAM5(subtropics_idx,n),...
                SISALv2.isoGSM(subtropics_idx,n),SISALv2.CESM(subtropics_idx,n),SISALv2.GISS(subtropics_idx,n)];
        else
            n = 6;
            REGION.subtropics{i} = [SISALv2.HadCM3(subtropics_idx,n),SISALv2.ECHAM5(subtropics_idx,n),...
                SISALv2.isoGSM(subtropics_idx,n)];
        end
end

% Extratropics
REGION.extratropics = cell(5,1);
REGION.extratropics{1} = [SISALv2.HadCM3(extratropics_idx,1),SISALv2.ECHAM5(extratropics_idx,1),...
    SISALv2.isoGSM(extratropics_idx,1),SISALv2.CESM(extratropics_idx,1),SISALv2.GISS(extratropics_idx,1)];
REGION.extratropics{2} = [SISALv2.HadCM3(extratropics_idx,5),SISALv2.ECHAM5(extratropics_idx,5),...
    SISALv2.isoGSM(extratropics_idx,5),SISALv2.CESM(extratropics_idx,5),SISALv2.GISS(extratropics_idx,5)];
for i = 3:5
        if i == 3
            n = 2;
            REGION.extratropics{i} = [SISALv2.HadCM3(extratropics_idx,n),SISALv2.ECHAM5(extratropics_idx,n),...
                SISALv2.isoGSM(extratropics_idx,n),SISALv2.CESM(extratropics_idx,n),SISALv2.GISS(extratropics_idx,n)];
        elseif i == 4
            n = 3;
            REGION.extratropics{i} = [SISALv2.HadCM3(extratropics_idx,n),SISALv2.ECHAM5(extratropics_idx,n),...
                SISALv2.isoGSM(extratropics_idx,n),SISALv2.CESM(extratropics_idx,n),SISALv2.GISS(extratropics_idx,n)];
        else
            n = 6;
            REGION.extratropics{i} = [SISALv2.HadCM3(extratropics_idx,n),SISALv2.ECHAM5(extratropics_idx,n),...
                SISALv2.isoGSM(extratropics_idx,n)];
        end
end
clear i n
%% Cells with regional means
% Cells: {1} Tropics_mean, {2} Subtropics_mean, {3} Extratropics_mean
% Variables in each cell: {1} speleothem_d18O, {2} speleothem_d13C, {3}
% speleothem_d18O_dweq, {4} sim_d18O_mean, {5} sim_temp_mean,
% {6} sim_prec_mean, {7} sim_evap_mean

% Tropics
REGION.tropics_d18O = SISALv2.d18O(tropics_idx,2); REGION.tropics_d13C = SISALv2.d13C(tropics_idx,2);
REGION.tropics_d13C_dweq = SISALv2.d13C_dweq(tropics_idx,1);

REGION.tropics_mean = cell(5,1);
REGION.tropics_mean{1} = nanmean([SISALv2.HadCM3(tropics_idx,1),SISALv2.ECHAM5(tropics_idx,1),...
    SISALv2.isoGSM(tropics_idx,1),SISALv2.CESM(tropics_idx,1),SISALv2.GISS(tropics_idx,1)],2); % d18O_dweq
REGION.tropics_mean{2} = nanmean([SISALv2.HadCM3(tropics_idx,5),SISALv2.ECHAM5(tropics_idx,5),...
    SISALv2.isoGSM(tropics_idx,5),SISALv2.CESM(tropics_idx,5),SISALv2.GISS(tropics_idx,5)],2); % d18O_if
for i = 3:5
        if i == 3
            n = 2; % Temperature
            REGION.tropics_mean{i} = nanmean([SISALv2.HadCM3(tropics_idx,n),SISALv2.ECHAM5(tropics_idx,n),...
                SISALv2.isoGSM(tropics_idx,n),SISALv2.CESM(tropics_idx,n),SISALv2.GISS(tropics_idx,n)],2);
        elseif i == 4
            n = 3; % Precipitation
            REGION.tropics_mean{i} = nanmean([SISALv2.HadCM3(tropics_idx,n),SISALv2.ECHAM5(tropics_idx,n),...
                SISALv2.isoGSM(tropics_idx,n),SISALv2.CESM(tropics_idx,n),SISALv2.GISS(tropics_idx,n)],2);
        else
            n = 6; % Evaporation
            REGION.tropics_mean{i} = nanmean([SISALv2.HadCM3(tropics_idx,n),SISALv2.ECHAM5(tropics_idx,n),...
                SISALv2.isoGSM(tropics_idx,n),SISALv2.CESM(tropics_idx,n),SISALv2.GISS(tropics_idx,n)],2);
        end
end

% Subtropics
REGION.subtropics_d18O = SISALv2.d18O(subtropics_idx,2); REGION.subtropics_d13C = SISALv2.d13C(subtropics_idx,2);
REGION.subtropics_d13C_dweq = SISALv2.d13C_dweq(subtropics_idx,1);

REGION.subtropics_mean = cell(5,1);
REGION.subtropics_mean{1} = nanmean([SISALv2.HadCM3(subtropics_idx,1),SISALv2.ECHAM5(subtropics_idx,1),...
    SISALv2.isoGSM(subtropics_idx,1),SISALv2.CESM(subtropics_idx,1),SISALv2.GISS(subtropics_idx,1)],2);
REGION.subtropics_mean{2} = nanmean([SISALv2.HadCM3(subtropics_idx,5),SISALv2.ECHAM5(subtropics_idx,5),...
    SISALv2.isoGSM(subtropics_idx,5),SISALv2.CESM(subtropics_idx,5),SISALv2.GISS(subtropics_idx,5)],2);
for i = 3:5
        if i == 3
            n = 2;
            REGION.subtropics_mean{i} = nanmean([SISALv2.HadCM3(subtropics_idx,n),SISALv2.ECHAM5(subtropics_idx,n),...
                SISALv2.isoGSM(subtropics_idx,n),SISALv2.CESM(subtropics_idx,n),SISALv2.GISS(subtropics_idx,n)],2);
        elseif i == 4
            n = 3;
            REGION.subtropics_mean{i} = nanmean([SISALv2.HadCM3(subtropics_idx,n),SISALv2.ECHAM5(subtropics_idx,n),...
                SISALv2.isoGSM(subtropics_idx,n),SISALv2.CESM(subtropics_idx,n),SISALv2.GISS(subtropics_idx,n)],2);
        else
            n = 6;
            REGION.subtropics_mean{i} = nanmean([SISALv2.HadCM3(subtropics_idx,n),SISALv2.ECHAM5(subtropics_idx,n),...
                SISALv2.isoGSM(subtropics_idx,n),SISALv2.CESM(subtropics_idx,n),SISALv2.GISS(subtropics_idx,n)],2);
        end
end

% Extratropics
REGION.extratropics_d18O = SISALv2.d18O(extratropics_idx,2); REGION.extratropics_d13C = SISALv2.d13C(extratropics_idx,2);
REGION.extratropics_d13C_dweq = SISALv2.d13C_dweq(extratropics_idx,1);

REGION.extratropics_mean = cell(5,1);
REGION.extratropics_mean{1} = nanmean([SISALv2.HadCM3(extratropics_idx,1),SISALv2.ECHAM5(extratropics_idx,1),...
    SISALv2.isoGSM(extratropics_idx,1),SISALv2.CESM(extratropics_idx,1),SISALv2.GISS(extratropics_idx,1)],2);
REGION.extratropics_mean{2} = nanmean([SISALv2.HadCM3(extratropics_idx,5),SISALv2.ECHAM5(extratropics_idx,5),...
    SISALv2.isoGSM(extratropics_idx,5),SISALv2.CESM(extratropics_idx,5),SISALv2.GISS(extratropics_idx,5)],2);
for i = 3:5
        if i == 3
            n = 2;
            REGION.extratropics_mean{i} = nanmean([SISALv2.HadCM3(extratropics_idx,n),SISALv2.ECHAM5(extratropics_idx,n),...
                SISALv2.isoGSM(extratropics_idx,n),SISALv2.CESM(extratropics_idx,n),SISALv2.GISS(extratropics_idx,n)],2);
        elseif i == 4
            n = 3;
            REGION.extratropics_mean{i} = nanmean([SISALv2.HadCM3(extratropics_idx,n),SISALv2.ECHAM5(extratropics_idx,n),...
                SISALv2.isoGSM(extratropics_idx,n),SISALv2.CESM(extratropics_idx,n),SISALv2.GISS(extratropics_idx,n)],2);
        else
            n = 6;
            REGION.extratropics_mean{i} = nanmean([SISALv2.HadCM3(extratropics_idx,n),SISALv2.ECHAM5(extratropics_idx,n),...
                SISALv2.isoGSM(extratropics_idx,n),SISALv2.CESM(extratropics_idx,n),SISALv2.GISS(extratropics_idx,n)],2);
        end
end
clear i n

SISALv2.altitude = table2array(SISAL1kentity(:,5));
SISALv2.latitude = table2array(SISAL1kentity(:,3));

% Elevation
REGION.tropics_elevation = SISALv2.altitude(tropics_idx);
REGION.subtropics_elevation = SISALv2.altitude(subtropics_idx);
REGION.extratropics_elevation = SISALv2.altitude(extratropics_idx);

%% Caluculate bootstrap CI of mean in all regions (RANGES in modelled meteorological variables)

tropics = {}; %cell structure
tropics.ci = cell(5,1);
tropics.bootstrap = cell(5,1);
[tropics.ci, tropics.bootstrap] = sisal1k_boot(REGION.tropics,2000);

subtropics = {}; %cell structure
subtropics.ci = cell(5,1);
subtropics.bootstrap = cell(5,1);
[subtropics.ci, subtropics.bootstrap] = sisal1k_boot(REGION.subtropics,2000);

extratropics = {}; %cell structure
extratropics.ci = cell(5,1);
extratropics.bootstrap = cell(5,1);
[extratropics.ci, extratropics.bootstrap] = sisal1k_boot(REGION.extratropics,2000);

%% Linear regression and R² & P-value

% linear regression on 2000 samples of mean
% _linreg cells are following correlations: 
% {1} speleothem_d18O_dweq, {2} sim_d18O (wp/wif),
% {3} sim_temp_mean, {4} sim_prec_mean, {5} sim_evap_mean
% against either speleothem_d18O, speleothem_d13C or speleothem d18O_dweq
% (notes as variable names: "region".linreg_"speleothem-variable")

tropics.linreg_d13C = cell(5,1);
tropics.bootmean_d13C = cell(5,1);
tropics.R_P_d13C = cell(5,1);
tropics.d13C_stats = cell(5,1);
[tropics.d13C_stats, tropics.bootmean_d13C, tropics.linreg_d13C, tropics.R_P_d13C]...
    = sisal1k_linreg_d13C(tropics.bootstrap,REGION.tropics_d13C_dweq,2000);

tropics.linreg_d18O = cell(5,1);
tropics.bootmean_d18O = cell(5,1);
tropics.R_P_d18O = cell(5,1);
tropics.d18O_stats = cell(5,1);
[tropics.d18O_stats, tropics.bootmean_d18O, tropics.linreg_d18O, tropics.R_P_d18O]...
    = sisal1k_linreg_d18O(tropics.bootstrap,2000);

subtropics.linreg_d13C = cell(5,1);
subtropics.bootmean_d13C = cell(5,1);
subtropics.R_P_d13C = cell(5,1);
subtropics.d13C_stats = cell(5,1);
[subtropics.d13C_stats, subtropics.bootmean_d13C, subtropics.linreg_d13C, subtropics.R_P_d13C]...
    = sisal1k_linreg_d13C(subtropics.bootstrap,REGION.subtropics_d13C_dweq,2000);

subtropics.linreg_d18O_dweq = cell(5,1);
subtropics.bootmean_d18O_dweq = cell(5,1);
subtropics.R_P_d18O = cell(5,1);
subtropics.d18O_stats = cell(5,1);
[subtropics.d18O_stats, subtropics.bootmean_d18O, subtropics.linreg_d18O, subtropics.R_P_d18O]...
    = sisal1k_linreg_d18O(subtropics.bootstrap,2000);

extratropics.linreg_d13C = cell(5,1);
extratropics.bootmean_d13C = cell(5,1);
extratropics.R_P_d13C = cell(5,1);
extratropics.d13C_stats = cell(5,1);
[extratropics.d13C_stats, extratropics.bootmean_d13C, extratropics.linreg_d13C, extratropics.R_P_d13C]...
    = sisal1k_linreg_d13C(extratropics.bootstrap,REGION.extratropics_d13C_dweq,2000);

extratropics.linreg_d18O_dweq = cell(5,1);
extratropics.bootmean_d18O_dweq = cell(5,1);
extratropics.R_P_d18O = cell(5,1);
extratropics.d18O_stats = cell(5,1);
[extratropics.d18O_stats, extratropics.bootmean_d18O, extratropics.linreg_d18O, extratropics.R_P_d18O]...
    = sisal1k_linreg_d18O(extratropics.bootstrap,2000);

%% Global analyses

GLOBAL = {}; % Cell structure

GLOBAL.d13C_dweq = SISALv2.d13C_dweq;

GLOBAL.mean = cell(5,1);
GLOBAL.mean{1} = nanmean([SISALv2.HadCM3(:,1),SISALv2.ECHAM5(:,1),...
    SISALv2.isoGSM(:,1),SISALv2.CESM(:,1),SISALv2.GISS(:,1)],2);
GLOBAL.mean{2} = nanmean([SISALv2.HadCM3(:,5),SISALv2.ECHAM5(:,5),...
    SISALv2.isoGSM(:,5),SISALv2.CESM(:,5),SISALv2.GISS(:,5)],2);
for i = 3:5
        if i == 3
            n = 2;
            GLOBAL.mean{i} = nanmean([SISALv2.HadCM3(:,n),SISALv2.ECHAM5(:,n),...
                SISALv2.isoGSM(:,n),SISALv2.CESM(:,n),SISALv2.GISS(:,n)],2);
        elseif i == 4
            n = 3;
            GLOBAL.mean{i} = nanmean([SISALv2.HadCM3(:,n),SISALv2.ECHAM5(:,n),...
                SISALv2.isoGSM(:,n),SISALv2.CESM(:,n),SISALv2.GISS(:,n)],2);
        else
            n = 6;
            GLOBAL.mean{i} = nanmean([SISALv2.HadCM3(:,n),SISALv2.ECHAM5(:,n),...
                SISALv2.isoGSM(:,n),SISALv2.CESM(:,n),SISALv2.GISS(:,n)],2);
        end
end

% Caluculate bootstrap CI of mean (RANGES in modelled meteorological variables)

% Temperature=2, Precipitation=5, Evaporation=10, dweq=1, modelISOT=6, wp=7, wif=8

% Cells: {1} global_calc, {2} Subglobal_calc, {3} Extraglobal_calc
% Variables in each cell: {1} speleothem_d18O_dweq, {2} sim_d18O (wp/wif),
% {3} sim_temp_mean, {4} sim_prec_mean, {5} sim_evap_mean

% global
GLOBAL.calc = cell(5,1);
GLOBAL.calc{1} = [SISALv2.HadCM3(:,1),SISALv2.ECHAM5(:,1),...
    SISALv2.isoGSM(:,1),SISALv2.CESM(:,1),SISALv2.GISS(:,1)];
GLOBAL.calc{2} = [SISALv2.HadCM3(:,5),SISALv2.ECHAM5(:,5),...
    SISALv2.isoGSM(:,5),SISALv2.CESM(:,5),SISALv2.GISS(:,5)];
for i = 3:5
        if i == 3
            n = 2;
            GLOBAL.calc{i} = [SISALv2.HadCM3(:,n),SISALv2.ECHAM5(:,n),...
                SISALv2.isoGSM(:,n),SISALv2.CESM(:,n),SISALv2.GISS(:,n)];
        elseif i == 4
            n = 3;
            GLOBAL.calc{i} = [SISALv2.HadCM3(:,n),SISALv2.ECHAM5(:,n),...
                SISALv2.isoGSM(:,n),SISALv2.CESM(:,n),SISALv2.GISS(:,n)];
        else
            n = 6;
            GLOBAL.calc{i} = [SISALv2.HadCM3(:,n),SISALv2.ECHAM5(:,n),...
                SISALv2.isoGSM(:,n)];
        end
end

% Confidence intervals
GLOBAL.ci = cell(5,1);
GLOBAL.bootstrap = cell(5,1);
[GLOBAL.ci, GLOBAL.bootstrap] = sisal1k_boot(GLOBAL.calc,2000);

% Linear regression and R² & P-value

% linear regression on 2000 samples of mean
% _linreg cells are following correlations: 
% {1} speleothem_d18O_dweq, {2} sim_d18O (wp/wif),
% {3} sim_temp_mean, {4} sim_prec_mean, {5} sim_evap_mean
% against either speleothem_d18O, speleothem_d13C or speleothem d18O_dweq
% (notes as variable names: "region"_linreg_"speleothem-variable")

% d13C
GLOBAL.linreg_d13C = cell(5,1);
GLOBAL.bootmean_d13C = cell(5,1);
GLOBAL.R_P_d13C = cell(5,1);
GLOBAL.d13C_stats = cell(5,1);
[GLOBAL.d13C_stats, GLOBAL.bootmean_d13C, GLOBAL.linreg_d13C, GLOBAL.R_P_d13C]...
    = sisal1k_linreg_d13C(GLOBAL.bootstrap,GLOBAL.d13C_dweq,2000);

% d18O
GLOBAL.linreg_d18O = cell(5,1);
GLOBAL.bootmean_d18O = cell(5,1);
GLOBAL.R_P_d18O = cell(5,1);
GLOBAL.d18O_stats = cell(5,1);
[GLOBAL.d18O_stats, GLOBAL.bootmean_d18O, GLOBAL.linreg_d18O, GLOBAL.R_P_d18O]...
    = sisal1k_linreg_d18O(GLOBAL.bootstrap,2000);

