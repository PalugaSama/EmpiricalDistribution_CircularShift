
% Cette fonction permet de plot les le tracé moyen d'une electrode donnée a
% travers les 4 etats de conscience W, N2, N3, REM. Des point rouges
% montrent des donnees significatives suite a l'analyse circular shift. 

function plot_1E_4S(channel)
    % Vérifier si l'input du channel est valide
    if channel < 1 || channel > 143
        error('Le numéro du channel doit être entre 1 et 143.');
    end

    % Les différents dossiers correspondant aux stades de sommeil
    sleep_stages = {'W', 'N2', 'N3', 'REM'};
    colors = {'b', 'g', 'm', 'c'}; % Couleurs pour chaque stade
    base_folder = '/home/localadmin/Documents/AnalyseHEP/EmpiricalDistribution/CircularShift/Data/Average_file';

    % Créer une figure pour visualiser les résultats pour le channel spécifié
    figure;
    hold on;

    % Initialiser les handles pour la légende
    legend_handles = [];
    legend_labels = {};

    % Parcourir chaque stade de sommeil
    for idx = 1:length(sleep_stages)
        folder_name = sleep_stages{idx};
        color = colors{idx};

        % Chemins vers les fichiers
        average_file_path = fullfile(base_folder, sprintf('average_%s.mat', folder_name));
        significatif_file_path = fullfile(base_folder, sprintf('significatif_%s.mat', folder_name));

        % Charger les données moyennes
        average_data = load(average_file_path);
        average_trial = average_data.average_struct.trial;
        time = average_data.average_struct.time;

        % Charger les données de significativité
        significatif_data = load(significatif_file_path);
        significatif = significatif_data.significatif;

        % Extraire les données pour le channel spécifié
        average_signal = average_trial(channel, :);
        significant_points = significatif(channel, :);

        % Tracer le signal moyen
        h_avg = plot(time, average_signal, color); % Utiliser la couleur spécifique pour chaque stade
        legend_handles = [legend_handles, h_avg]; %#ok<AGROW>
        legend_labels = [legend_labels, folder_name]; %#ok<AGROW>

        % Ajouter les points rouges pour les endroits significatifs
        h_sig = plot(time(significant_points == 1), average_signal(significant_points == 1), 'r.', 'MarkerSize', 10); % Points rouges pour les signaux significatifs
        if idx == 1
            legend_handles = [legend_handles, h_sig]; %#ok<AGROW>
            legend_labels = [legend_labels, 'Significatif']; %#ok<AGROW>
        end
    end

    % Ajouter une ligne verticale pointillée rouge au temps 0
    h_rpeak = xline(0, 'r--', 'LineWidth', 2);
    legend_handles = [legend_handles, h_rpeak]; 
    legend_labels = [legend_labels, 'Rpeak'];

    % Ajouter les étiquettes et le titre
    xlabel('Temps (s)');
    ylabel('Amplitude');
    title(sprintf('Signal moyen pour le channel %d à travers les stades de sommeil', channel));

    % Ajouter une légende pour distinguer les stades de sommeil et les points significatifs
    legend(legend_handles, legend_labels, 'Location', 'best');

    hold off;
end
