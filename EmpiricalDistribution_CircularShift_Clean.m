
%% Empirical Distribution V1 - Circular Shift (sur chaque (i, j) de l'average_file) 

% - Data downsample to 128hz
% - Bipolar montage
% - Noisy electrode remove
% 
% - Trial Extraction with Epoching_Events.m depuis DATA_Clean 
%   pour obtenir dossier W, N2, N3, REM. 

%% ANALYSE DES DOSSIER : 

% Genere pour chaque trial 1000 versions randomisees de ce trial (avec un circular shift sur chaque channel). 
% Ensuite on calcule l'average_file des 1000 randomisations pour chaque
% trial. On obtient ainsi 1000 moyenne pour chaque dossier W, N2, N3, REM et on compare (i, j) de chaque dossier 
% a la distribution de ce point au sein des 1000 moyenne. Si <2.5
% pourcentile ou >97.5 pourcentile, alors significatif. 

%% NEED : 
% 
% - CircularShift/Data/W, N2, N3, REM avec les trials extraits via
%   Epoching_Events. 
% - CircularShift/Data/Average_file vide pour accueillir les résultats
%   d'analyse. 

%% Computation : Entre 6 et 12 heures. 

% ------------------------------------------------------------------------
%% -------------------- Analyse -----------------------------

folders = {'W', 'N2', 'N3', 'REM'};
base_folder = '/home/localadmin/Documents/AnalyseHEP/EmpiricalDistribution/CircularShift/Data';
output_folder = fullfile(base_folder, 'Average_file');

%% Boucler sur chaque dossier et appeler la fonction analyze_folder
for i = 1:length(folders)
    Analyse_CircularShift(folders{i}, base_folder, output_folder);
end

fprintf('Analyse Circular Shift terminée')

% -- COPIER COLLER RESULTATS ANALYSE DANS Data/Result/Result_CircularShift/

% ------------------------------------------------------------------------
%% -------------------- Visualiser Résultats -----------------------------

% 1-2 Ventral Diencephalon (hypothalamus?)
% 3-4 Amygdala
% 6-7-8-9 Insular cortex   
% 15-16-17 Hippocampus    --> N2 activation ?? 


%% Visualisation pour 1 electrode a travers 1 etats
folders = {'W', 'N2', 'N3', 'REM'};
base_folder = '/home/localadmin/Documents/AnalyseHEP/EmpiricalDistribution/CircularShift/Results/Result_CircularShift';
output_folder = fullfile(base_folder, 'Average_file');

for i = 1:length(folders)
    plot_E_1S(folders{i}, output_folder);
end



%% Visualisation pour 1 electrode a travers tous les etats

plot_1E_4S(35)



%% Visualisation pour toutes les electrodes a travers 1 etats

plot_1E1S(1, 'N3');



%% Fichier CSV

average_output_folder = '/home/localadmin/Documents/AnalyseHEP/EmpiricalDistribution/CircularShift//Results/Result_CircularShift/Average_file';
output_csv_path = '/home/localadmin/Documents/AnalyseHEP/EmpiricalDistribution/CircularShift/Results/Summary.csv';
generate_summary_csv(average_output_folder, output_csv_path);
fprintf('Fichier CSV crée avec succès')



%% Histogramme

average_output_folder = '/home/localadmin/Documents/AnalyseHEP/EmpiricalDistribution/CircularShift//Results/Result_CircularShift/Average_file';
output_hist_path = '/home/localadmin/Documents/AnalyseHEP/EmpiricalDistribution/CircularShift/Results/Histogramme.jpeg';
histogramme(average_output_folder, output_hist_path);





%% Baseline Correction 
% Exemple d'appel de la fonction
base_folder = '/home/localadmin/Documents/AnalyseHEP/EmpiricalDistribution/Data/';
Baseline_Correction(base_folder);



