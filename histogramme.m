
function histogramme(average_output_folder, output_hist_path)
    event_labels = {'W', 'N2', 'N3', 'REM'};
    num_channels = 143;
    significant_counts = zeros(num_channels, 4); % 4 colonnes pour W, N2, N3, REM
    
    % Parcourt des étiquettes d'événements pour remplir les données
    for label_idx = 1:length(event_labels)
        label = event_labels{label_idx};
        significatif_file_path = fullfile(average_output_folder, sprintf('significatif_%s.mat', label));
        
        if exist(significatif_file_path, 'file')
            significatif_data = load(significatif_file_path);
            significatif_binaire = significatif_data.significatif;
            
            for channel_idx = 1:num_channels
                significant_counts(channel_idx, label_idx) = sum(significatif_binaire(channel_idx, :));
            end
        else
            warning('Le fichier %s est introuvable', significatif_file_path);
        end
    end
    
    % Plot des histogrammes
    figure;
    bar(significant_counts, 'stacked');
    colormap([0.2, 0.2, 1; 0, 1, 0; 1, 1, 0; 1, 0, 0]); % Couleurs pour W, N2, N3, REM
    legend(event_labels, 'Location', 'BestOutside');
    xlabel('Electrode');
    ylabel('Nombre de points significatifs');
    title('Histogramme des électrodes significatives par stade de sommeil');

    % Créer le dossier de sortie si nécessaire
    output_folder = fileparts(output_hist_path);
    if ~exist(output_folder, 'dir')
        mkdir(output_folder);
    end

    % Sauvegarder l'histogramme
    saveas(gcf, output_hist_path);
end

