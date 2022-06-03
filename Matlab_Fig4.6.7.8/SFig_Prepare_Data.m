%-------------------------------------------------------------------------
% *Read in and prepare data for supplement figures 8 and 9* 
% 
%% Index region (Europe, N./C. America, S. America and E. Asia)

% Create index
SISAL1kentity_matrix = [table2array(SISAL1kentity(:,1)),table2array(SISAL1kentity(:,2)),...
    table2array(SISAL1kentity(:,3)),table2array(SISAL1kentity(:,4)),table2array(SISAL1kentity(:,5))];
% East Asia
easia_idx = SISAL1kentity_matrix(:,3) <= 39 & SISAL1kentity_matrix(:,3) >=15 &...
    SISAL1kentity_matrix(:,4) <= 125 & SISAL1kentity_matrix(:,4) >= 100;
% Europe (36.7 to 75'N, -30 to 30'E)
europe_idx = SISAL1kentity_matrix(:,3) <= 75 & SISAL1kentity_matrix(:,3) >=36.7 &...
    SISAL1kentity_matrix(:,4) <= 30 & SISAL1kentity_matrix(:,4) >= -30;
% N./C. America
ncamerica_idx = SISAL1kentity_matrix(:,3) <= 60 & SISAL1kentity_matrix(:,3) >=8.1 &...
    SISAL1kentity_matrix(:,4) <= -50 & SISAL1kentity_matrix(:,4) >= -150;
% S. America
samerica_idx = SISAL1kentity_matrix(:,3) <= 8 & SISAL1kentity_matrix(:,3) >=-60 &...
    SISAL1kentity_matrix(:,4) <= -30 & SISAL1kentity_matrix(:,4) >= -150;

% Prepare cells for sorting and plotting
% Cells: {1} Tropics_mean, {2} Subtropics_mean, {3} Extratropics_mean
% Variables in each cell: {1} speleothem_d18O, {2} speleothem_d13C, {3}
% speleothem_d18O_dweq, {4} sim_d18O_mean, {5} sim_temp_mean,
% {6} sim_prec_mean, {7} sim_evap_mean

CONTINENTAL = {}; % Cell structure

CONTINENT.europe_d18O = SISALv2.d18O(europe_idx,2); CONTINENT.europe_d13C = SISALv2.d13C_dweq(europe_idx,1);
CONTINENT.europe_mean = cell(5,1);
CONTINENT.europe_mean{1} = nanmean([SISALv2.HadCM3(europe_idx,1),SISALv2.ECHAM5(europe_idx,1),...
    SISALv2.isoGSM(europe_idx,1),SISALv2.CESM(europe_idx,1),SISALv2.GISS(europe_idx,1)],2);
CONTINENT.europe_mean{2} = nanmean([SISALv2.HadCM3(europe_idx,5),SISALv2.ECHAM5(europe_idx,5),...
    SISALv2.isoGSM(europe_idx,5),SISALv2.CESM(europe_idx,5),SISALv2.GISS(europe_idx,5)],2);
for i = 3:5
        if i == 3
            n = 2;
            CONTINENT.europe_mean{i} = nanmean([SISALv2.HadCM3(europe_idx,n),SISALv2.ECHAM5(europe_idx,n),...
                SISALv2.isoGSM(europe_idx,n),SISALv2.CESM(europe_idx,n),SISALv2.GISS(europe_idx,n)],2);
        elseif i == 4
            n = 3;
            CONTINENT.europe_mean{i} = nanmean([SISALv2.HadCM3(europe_idx,n),SISALv2.ECHAM5(europe_idx,n),...
                SISALv2.isoGSM(europe_idx,n),SISALv2.CESM(europe_idx,n),SISALv2.GISS(europe_idx,n)],2);
        else
            n = 6;
            CONTINENT.europe_mean{i} = nanmean([SISALv2.HadCM3(europe_idx,n),SISALv2.ECHAM5(europe_idx,n),...
                SISALv2.isoGSM(europe_idx,n),SISALv2.CESM(europe_idx,n),SISALv2.GISS(europe_idx,n)],2);
        end
end

CONTINENT.ncamerica_d18O = SISALv2.d18O(ncamerica_idx,2); CONTINENT.ncamerica_d13C = SISALv2.d13C_dweq(ncamerica_idx,1);
CONTINENT.ncamerica_mean = cell(5,1);
CONTINENT.ncamerica_mean{1} = nanmean([SISALv2.HadCM3(ncamerica_idx,1),SISALv2.ECHAM5(ncamerica_idx,1),...
    SISALv2.isoGSM(ncamerica_idx,1),SISALv2.CESM(ncamerica_idx,1),SISALv2.GISS(ncamerica_idx,1)],2);
CONTINENT.ncamerica_mean{2} = nanmean([SISALv2.HadCM3(ncamerica_idx,5),SISALv2.ECHAM5(ncamerica_idx,5),...
    SISALv2.isoGSM(ncamerica_idx,5),SISALv2.CESM(ncamerica_idx,5),SISALv2.GISS(ncamerica_idx,5)],2);
for i = 3:5
        if i == 3
            n = 2;
            CONTINENT.ncamerica_mean{i} = nanmean([SISALv2.HadCM3(ncamerica_idx,n),SISALv2.ECHAM5(ncamerica_idx,n),...
                SISALv2.isoGSM(ncamerica_idx,n),SISALv2.CESM(ncamerica_idx,n),SISALv2.GISS(ncamerica_idx,n)],2);
        elseif i == 4
            n = 3;
            CONTINENT.ncamerica_mean{i} = nanmean([SISALv2.HadCM3(ncamerica_idx,n),SISALv2.ECHAM5(ncamerica_idx,n),...
                SISALv2.isoGSM(ncamerica_idx,n),SISALv2.CESM(ncamerica_idx,n),SISALv2.GISS(ncamerica_idx,n)],2);
        else
            n = 6;
            CONTINENT.ncamerica_mean{i} = nanmean([SISALv2.HadCM3(ncamerica_idx,n),SISALv2.ECHAM5(ncamerica_idx,n),...
                SISALv2.isoGSM(ncamerica_idx,n),SISALv2.CESM(ncamerica_idx,n),SISALv2.GISS(ncamerica_idx,n)],2);
        end
end

CONTINENT.samerica_d18O = SISALv2.d18O(samerica_idx,2); CONTINENT.samerica_d13C = SISALv2.d13C_dweq(samerica_idx,1);
CONTINENT.samerica_mean = cell(5,1);
CONTINENT.samerica_mean{1} = nanmean([SISALv2.HadCM3(samerica_idx,1),SISALv2.ECHAM5(samerica_idx,1),...
    SISALv2.isoGSM(samerica_idx,1),SISALv2.CESM(samerica_idx,1),SISALv2.GISS(samerica_idx,1)],2);
CONTINENT.samerica_mean{2} = nanmean([SISALv2.HadCM3(samerica_idx,5),SISALv2.ECHAM5(samerica_idx,5),...
    SISALv2.isoGSM(samerica_idx,5),SISALv2.CESM(samerica_idx,5),SISALv2.GISS(samerica_idx,5)],2);
for i = 3:5
        if i == 3
            n = 2;
            CONTINENT.samerica_mean{i} = nanmean([SISALv2.HadCM3(samerica_idx,n),SISALv2.ECHAM5(samerica_idx,n),...
                SISALv2.isoGSM(samerica_idx,n),SISALv2.CESM(samerica_idx,n),SISALv2.GISS(samerica_idx,n)],2);
        elseif i == 4
            n = 3;
            CONTINENT.samerica_mean{i} = nanmean([SISALv2.HadCM3(samerica_idx,n),SISALv2.ECHAM5(samerica_idx,n),...
                SISALv2.isoGSM(samerica_idx,n),SISALv2.CESM(samerica_idx,n),SISALv2.GISS(samerica_idx,n)],2);
        else
            n = 6;
            CONTINENT.samerica_mean{i} = nanmean([SISALv2.HadCM3(samerica_idx,n),SISALv2.ECHAM5(samerica_idx,n),...
                SISALv2.isoGSM(samerica_idx,n),SISALv2.CESM(samerica_idx,n),SISALv2.GISS(samerica_idx,n)],2);
        end
end

CONTINENT.easia_d18O = SISALv2.d18O(easia_idx,2); CONTINENT.easia_d13C = SISALv2.d13C_dweq(easia_idx,1);
CONTINENT.easia_mean = cell(5,1);
CONTINENT.easia_mean{1} = nanmean([SISALv2.HadCM3(easia_idx,1),SISALv2.ECHAM5(easia_idx,1),...
    SISALv2.isoGSM(easia_idx,1),SISALv2.CESM(easia_idx,1),SISALv2.GISS(easia_idx,1)],2);
CONTINENT.easia_mean{2} = nanmean([SISALv2.HadCM3(easia_idx,5),SISALv2.ECHAM5(easia_idx,5),...
    SISALv2.isoGSM(easia_idx,5),SISALv2.CESM(easia_idx,5),SISALv2.GISS(easia_idx,5)],2);
for i = 3:5
        if i == 3
            n = 2;
            CONTINENT.easia_mean{i} = nanmean([SISALv2.HadCM3(easia_idx,n),SISALv2.ECHAM5(easia_idx,n),...
                SISALv2.isoGSM(easia_idx,n),SISALv2.CESM(easia_idx,n),SISALv2.GISS(easia_idx,n)],2);
        elseif i == 4
            n = 3;
            CONTINENT.easia_mean{i} = nanmean([SISALv2.HadCM3(easia_idx,n),SISALv2.ECHAM5(easia_idx,n),...
                SISALv2.isoGSM(easia_idx,n),SISALv2.CESM(easia_idx,n),SISALv2.GISS(easia_idx,n)],2);
        else
            n = 6;
            CONTINENT.easia_mean{i} = nanmean([SISALv2.HadCM3(easia_idx,n),SISALv2.ECHAM5(easia_idx,n),...
                SISALv2.isoGSM(easia_idx,n),SISALv2.CESM(easia_idx,n),SISALv2.GISS(easia_idx,n)],2);
        end
end

% Elevation
CONTINENT.europe_elevation = SISALv2.altitude(europe_idx);
CONTINENT.easia_elevation = SISALv2.altitude(easia_idx);
CONTINENT.ncamerica_elevation = SISALv2.altitude(ncamerica_idx);
CONTINENT.samerica_elevation = SISALv2.altitude(samerica_idx);

clear i n 


%% Cells with continetal data based on indices

% Europe
CONTINENT.europe = cell(5,1);
CONTINENT.europe{1} = [SISALv2.HadCM3(europe_idx,1),SISALv2.ECHAM5(europe_idx,1),...
    SISALv2.isoGSM(europe_idx,1),SISALv2.CESM(europe_idx,1),SISALv2.GISS(europe_idx,1)];
CONTINENT.europe{2} = [SISALv2.HadCM3(europe_idx,5),SISALv2.ECHAM5(europe_idx,5),...
    SISALv2.isoGSM(europe_idx,5),SISALv2.CESM(europe_idx,5),SISALv2.GISS(europe_idx,5)];
for i = 3:5
        if i == 3
            n = 2;
            CONTINENT.europe{i} = [SISALv2.HadCM3(europe_idx,n),SISALv2.ECHAM5(europe_idx,n),...
                SISALv2.isoGSM(europe_idx,n),SISALv2.CESM(europe_idx,n),SISALv2.GISS(europe_idx,n)];
        elseif i == 4
            n = 3;
            CONTINENT.europe{i} = [SISALv2.HadCM3(europe_idx,n),SISALv2.ECHAM5(europe_idx,n),...
                SISALv2.isoGSM(europe_idx,n),SISALv2.CESM(europe_idx,n),SISALv2.GISS(europe_idx,n)];
        else
            n = 6;
            CONTINENT.europe{i} = [SISALv2.HadCM3(europe_idx,n),SISALv2.ECHAM5(europe_idx,n),...
                SISALv2.isoGSM(europe_idx,n)];
        end
end

% East Asia
CONTINENT.easia = cell(5,1);
CONTINENT.easia{1} = [SISALv2.HadCM3(easia_idx,1),SISALv2.ECHAM5(easia_idx,1),...
    SISALv2.isoGSM(easia_idx,1),SISALv2.CESM(easia_idx,1),SISALv2.GISS(easia_idx,1)];
CONTINENT.easia{2} = [SISALv2.HadCM3(easia_idx,5),SISALv2.ECHAM5(easia_idx,5),...
    SISALv2.isoGSM(easia_idx,5),SISALv2.CESM(easia_idx,5),SISALv2.GISS(easia_idx,5)];
for i = 3:5
        if i == 3
            n = 2;
            CONTINENT.easia{i} = [SISALv2.HadCM3(easia_idx,n),SISALv2.ECHAM5(easia_idx,n),...
                SISALv2.isoGSM(easia_idx,n),SISALv2.CESM(easia_idx,n),SISALv2.GISS(easia_idx,n)];
        elseif i == 4
            n = 3;
            CONTINENT.easia{i} = [SISALv2.HadCM3(easia_idx,n),SISALv2.ECHAM5(easia_idx,n),...
                SISALv2.isoGSM(easia_idx,n),SISALv2.CESM(easia_idx,n),SISALv2.GISS(easia_idx,n)];
        else
            n = 6;
            CONTINENT.easia{i} = [SISALv2.HadCM3(easia_idx,n),SISALv2.ECHAM5(easia_idx,n),...
                SISALv2.isoGSM(easia_idx,n)];
        end
end

% North and Central America
CONTINENT.ncamerica = cell(5,1);
CONTINENT.ncamerica{1} = [SISALv2.HadCM3(ncamerica_idx,1),SISALv2.ECHAM5(ncamerica_idx,1),...
    SISALv2.isoGSM(ncamerica_idx,1),SISALv2.CESM(ncamerica_idx,1),SISALv2.GISS(ncamerica_idx,1)];
CONTINENT.ncamerica{2} = [SISALv2.HadCM3(ncamerica_idx,5),SISALv2.ECHAM5(ncamerica_idx,5),...
    SISALv2.isoGSM(ncamerica_idx,5),SISALv2.CESM(ncamerica_idx,5),SISALv2.GISS(ncamerica_idx,5)];
for i = 3:5
        if i == 3
            n = 2;
            CONTINENT.ncamerica{i} = [SISALv2.HadCM3(ncamerica_idx,n),SISALv2.ECHAM5(ncamerica_idx,n),...
                SISALv2.isoGSM(ncamerica_idx,n),SISALv2.CESM(ncamerica_idx,n),SISALv2.GISS(ncamerica_idx,n)];
        elseif i == 4
            n = 3;
            CONTINENT.ncamerica{i} = [SISALv2.HadCM3(ncamerica_idx,n),SISALv2.ECHAM5(ncamerica_idx,n),...
                SISALv2.isoGSM(ncamerica_idx,n),SISALv2.CESM(ncamerica_idx,n),SISALv2.GISS(ncamerica_idx,n)];
        else
            n = 6;
            CONTINENT.ncamerica{i} = [SISALv2.HadCM3(ncamerica_idx,n),SISALv2.ECHAM5(ncamerica_idx,n),...
                SISALv2.isoGSM(ncamerica_idx,n)];
        end
end

% South America
CONTINENT.samerica = cell(5,1);
CONTINENT.samerica{1} = [SISALv2.HadCM3(samerica_idx,1),SISALv2.ECHAM5(samerica_idx,1),...
    SISALv2.isoGSM(samerica_idx,1),SISALv2.CESM(samerica_idx,1),SISALv2.GISS(samerica_idx,1)];
CONTINENT.samerica{2} = [SISALv2.HadCM3(samerica_idx,5),SISALv2.ECHAM5(samerica_idx,5),...
    SISALv2.isoGSM(samerica_idx,5),SISALv2.CESM(samerica_idx,5),SISALv2.GISS(samerica_idx,5)];
for i = 3:5
        if i == 3
            n = 2;
            CONTINENT.samerica{i} = [SISALv2.HadCM3(samerica_idx,n),SISALv2.ECHAM5(samerica_idx,n),...
                SISALv2.isoGSM(samerica_idx,n),SISALv2.CESM(samerica_idx,n),SISALv2.GISS(samerica_idx,n)];
        elseif i == 4
            n = 3;
            CONTINENT.samerica{i} = [SISALv2.HadCM3(samerica_idx,n),SISALv2.ECHAM5(samerica_idx,n),...
                SISALv2.isoGSM(samerica_idx,n),SISALv2.CESM(samerica_idx,n),SISALv2.GISS(samerica_idx,n)];
        else
            n = 6;
            CONTINENT.samerica{i} = [SISALv2.HadCM3(samerica_idx,n),SISALv2.ECHAM5(samerica_idx,n),...
                SISALv2.isoGSM(samerica_idx,n)];
        end
end

clear i n 
%% Caluculate bootstrap CI of mean for all continents (RANGES in modelled meteorological variables)

CONTINENT.europe_ci = cell(5,1);
CONTINENT.europe_bootstrap = cell(5,1);
[CONTINENT.europe_ci, CONTINENT.europe_bootstrap] = sisal1k_boot(CONTINENT.europe,2000);

CONTINENT.easia_ci = cell(5,1);
CONTINENT.easia_bootstrap = cell(5,1);
[CONTINENT.easia_ci, CONTINENT.easia_bootstrap] = sisal1k_boot(CONTINENT.easia,2000);

CONTINENT.ncamerica_ci = cell(5,1);
CONTINENT.ncamerica_bootstrap = cell(5,1);
[CONTINENT.ncamerica_ci, CONTINENT.ncamerica_bootstrap] = sisal1k_boot(CONTINENT.ncamerica,2000);

CONTINENT.samerica_ci = cell(5,1);
CONTINENT.samerica_bootstrap = cell(5,1);
[CONTINENT.samerica_ci, CONTINENT.samerica_bootstrap] = sisal1k_boot(CONTINENT.samerica,2000);

%% Linear regression and R² & P-value

% linear regression on 2000 samples of mean
% _linreg cells are following correlations: 
% {1} speleothem_d18O_dweq, {2} sim_d18O (wp/wif),
% {3} sim_temp_mean, {4} sim_prec_mean, {5} sim_evap_mean
% against either speleothem_d18O, speleothem_d13C or speleothem d18O_dweq
% (notes as variable names: "region".linreg_"speleothem-variable")

CONTINENT.europe_linreg_d13C = cell(5,1);
CONTINENT.europe_bootmean_d13C = cell(5,1);
CONTINENT.europe_R_P_d13C = cell(5,1);
CONTINENT.europe_d13C_stats = cell(5,1);
[CONTINENT.europe_d13C_stats, CONTINENT.europe_bootmean_d13C, CONTINENT.europe_linreg_d13C,...
    CONTINENT.europe_R_P_d13C] = sisal1k_linreg_d13C(CONTINENT.europe_bootstrap,CONTINENT.europe_d13C,2000);

CONTINENT.europe_linreg_d18O = cell(5,1);
CONTINENT.europe_bootmean_d18O = cell(5,1);
CONTINENT.europe_R_P_d18O = cell(5,1);
CONTINENT.europe_d18O_stats = cell(5,1);
[CONTINENT.europe_d18O_stats, CONTINENT.europe_bootmean_d18O, CONTINENT.europe_linreg_d18O,...
    CONTINENT.europe_R_P_d18O] = sisal1k_linreg_d18O(CONTINENT.europe_bootstrap,2000);

CONTINENT.easia_linreg_d13C = cell(5,1);
CONTINENT.easia_bootmean_d13C = cell(5,1);
CONTINENT.easia_R_P_d13C = cell(5,1);
CONTINENT.easia_d13C_stats = cell(5,1);
[CONTINENT.easia_d13C_stats, CONTINENT.easia_bootmean_d13C, CONTINENT.easia_linreg_d13C,...
    CONTINENT.easia_R_P_d13C] = sisal1k_linreg_d13C(CONTINENT.easia_bootstrap,CONTINENT.easia_d13C,2000);

CONTINENT.easia_linreg_d18O = cell(5,1);
CONTINENT.easia_bootmean_d18O = cell(5,1);
CONTINENT.easia_R_P_d18O = cell(5,1);
CONTINENT.easia_d18O_stats = cell(5,1);
[CONTINENT.easia_d18O_stats, CONTINENT.easia_bootmean_d18O, CONTINENT.easia_linreg_d18O,...
    CONTINENT.easia_R_P_d18O] = sisal1k_linreg_d18O(CONTINENT.easia_bootstrap,2000);

CONTINENT.ncamerica_linreg_d13C = cell(5,1);
CONTINENT.ncamerica_bootmean_d13C = cell(5,1);
CONTINENT.ncamerica_R_P_d13C = cell(5,1);
CONTINENT.ncamerica_d13C_stats = cell(5,1);
[CONTINENT.ncamerica_d13C_stats, CONTINENT.ncamerica_bootmean_d13C, CONTINENT.ncamerica_linreg_d13C,...
    CONTINENT.ncamerica_R_P_d13C] = sisal1k_linreg_d13C(CONTINENT.ncamerica_bootstrap,CONTINENT.ncamerica_d13C,2000);

CONTINENT.ncamerica_linreg_d18O = cell(5,1);
CONTINENT.ncamerica_bootmean_d18O = cell(5,1);
CONTINENT.ncamerica_R_P_d18O = cell(5,1);
CONTINENT.ncamerica_d18O_stats = cell(5,1);
[CONTINENT.ncamerica_d18O_stats, CONTINENT.ncamerica_bootmean_d18O, CONTINENT.ncamerica_linreg_d18O,...
    CONTINENT.ncamerica_R_P_d18O] = sisal1k_linreg_d18O(CONTINENT.ncamerica_bootstrap,2000);

CONTINENT.samerica_linreg_d13C = cell(5,1);
CONTINENT.samerica_bootmean_d13C = cell(5,1);
CONTINENT.samerica_R_P_d13C = cell(5,1);
CONTINENT.samerica_d13C_stats = cell(5,1);
[CONTINENT.samerica_d13C_stats, CONTINENT.samerica_bootmean_d13C, CONTINENT.samerica_linreg_d13C,...
    CONTINENT.samerica_R_P_d13C] = sisal1k_linreg_d13C(CONTINENT.samerica_bootstrap,CONTINENT.samerica_d13C,2000);

CONTINENT.samerica_linreg_d18O = cell(5,1);
CONTINENT.samerica_bootmean_d18O = cell(5,1);
CONTINENT.samerica_R_P_d18O = cell(5,1);
CONTINENT.samerica_d18O_stats = cell(5,1);
[CONTINENT.samerica_d18O_stats, CONTINENT.samerica_bootmean_d18O, CONTINENT.samerica_linreg_d18O,...
    CONTINENT.samerica_R_P_d18O] = sisal1k_linreg_d18O(CONTINENT.samerica_bootstrap,2000);

