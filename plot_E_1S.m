
% Permet de plot les resultats de l'analyse Empirical Distribution -
% CircularShift en visualisant les activations significatives de toutes 
% les electrodes  a travers un etat. 

function plot_E_1S(folder_name, output_folder)
    % Charger le fichier average_<folder_name>.mat
    average_file_path = fullfile(output_folder, sprintf('average_%s.mat', folder_name));
    average_data = load(average_file_path);

    % Charger les résultats de significativité
    significatif_file_path = fullfile(output_folder, sprintf('significatif_%s.mat', folder_name));
    significatif_data = load(significatif_file_path);

    % Extraire les données de temps et le signal moyen
    time = average_data.average_struct.time;
    average_trial = average_data.average_struct.trial;
    significatif = significatif_data.significatif;

    % Créer une figure pour visualiser les électrodes significatives
    figure;
    hold on;

    % Visualiser le signal moyen pour chaque électrode
    for channel_idx = 1:143
        plot(time, average_trial(channel_idx, :), 'Color', [0.8, 0.8, 0.8]); % Couleur grise pour les signaux non significatifs
    end

    % Ajouter les lignes verticales pour les électrodes significatives
    for channel_idx = 1:143
        significant_times = time(significatif(channel_idx, :) == 1);
        significant_values = average_trial(channel_idx, significatif(channel_idx, :) == 1);
        plot(significant_times, significant_values, 'r.', 'MarkerSize', 10); % Points rouges pour les signaux significatifs
    end

    % Ajouter une ligne verticale rouge au temps 0
    xline(0, 'r', 'LineWidth', 2);

    % Ajouter les étiquettes et le titre
    xlabel('Temps (s)');
    ylabel('Amplitude');
    title(sprintf('Electrodes significatives autour du battement cardiaque pour le dossier %s', folder_name));

    hold off;
end


