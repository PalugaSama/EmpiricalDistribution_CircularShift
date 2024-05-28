
% Visualisation resultats suite a analyse Empirical Distribution Circular Shift
% permet de plot le signal moyen d'une electrode dans un etat avec des
% point rouges pour indique la significative. 

function plot_1E1S(channel, folder_name)
    % Vérifier si l'input du channel est valide
    if channel < 1 || channel > 143
        error('Le numéro du channel doit être entre 1 et 143.');
    end

    % Chemins vers les fichiers
    base_folder = '/home/localadmin/Documents/AnalyseHEP/EmpiricalDistribution/CircularShift/Results/Result_CircularShift/Average_file';
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

    % Créer une figure pour visualiser les résultats pour le channel spécifié
    figure;
    hold on;

    % Tracer le signal moyen
    plot(time, average_signal, 'b'); % Couleur bleue pour le signal moyen

    % Ajouter les points rouges pour les endroits significatifs
    plot(time(significant_points == 1), average_signal(significant_points == 1), 'r.', 'MarkerSize', 10); % Points rouges pour les signaux significatifs

    % Ajouter une ligne verticale pointillée rouge au temps 0
    xline(0, 'r--', 'LineWidth', 2);

    % Ajouter les étiquettes et le titre
    xlabel('Temps (s)');
    ylabel('Amplitude');
    title(sprintf('Signal moyen pour le channel %d autour du battement cardiaque (%s)', channel, folder_name));

    hold off;
end
