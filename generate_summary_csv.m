
function generate_summary_csv(average_output_folder, output_csv_path)
    event_labels = {'W', 'N2', 'N3', 'REM'};
    num_channels = 143;
    
    % Initialisation des données pour le CSV
    summary_data = cell(num_channels, 9); % 143 lignes et 9 colonnes (1 pour les noms des canaux et 8 pour les données)
    for i = 1:num_channels
        summary_data{i, 1} = sprintf('Channel_%d', i); % Nom des canaux
    end
    
    % Parcourt des étiquettes d'événements pour remplir les données
    for label_idx = 1:length(event_labels)
        label = event_labels{label_idx};
        significatif_file_path = fullfile(average_output_folder, sprintf('significatif_%s.mat', label));
        
        if exist(significatif_file_path, 'file')
            significatif_data = load(significatif_file_path);
            significatif_binaire = significatif_data.significatif;
            
            for channel_idx = 1:num_channels
                significant_points = find(significatif_binaire(channel_idx, :));
                num_significant_points = length(significant_points);
                
                % Stocker le nombre de points significatifs
                summary_data{channel_idx, 2 * label_idx} = num_significant_points;
                
                % Stocker les timings des points significatifs
                summary_data{channel_idx, 2 * label_idx + 1} = sprintf('%.3f ', significant_points / 1024 - 0.5); % Convertir les indices en temps
            end
        else
            warning('Le fichier %s est introuvable', significatif_file_path);
        end
    end
    
    % Convertir les données en tableau et les sauvegarder en CSV
    summary_table = cell2table(summary_data, 'VariableNames', {'Channel', 'W_count', 'W_timings', 'N2_count', 'N2_timings', 'N3_count', 'N3_timings', 'REM_count', 'REM_timings'});
    
    % Créer le dossier de sortie si nécessaire
    output_folder = fileparts(output_csv_path);
    if ~exist(output_folder, 'dir')
        mkdir(output_folder);
    end
    
    % Sauvegarder le tableau en CSV
    writetable(summary_table, output_csv_path);
end


