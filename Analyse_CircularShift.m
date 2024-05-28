
function Analyse_CircularShift(folder_name, base_folder, output_folder)
    % Chemin vers le dossier
    folder = fullfile(base_folder, folder_name);
    
    % Liste des fichiers .mat dans le dossier
    files = dir(fullfile(folder, '*.mat'));
    
    % Initialisation de la somme des signaux et du nombre de fichiers
    sum_data = zeros(143, 116);
    num_files = numel(files);
    
    % Parcourir chaque fichier pour additionner les signaux
    for i = 1:num_files
        file_path = fullfile(folder, files(i).name);
        data = load(file_path);
        
        % Vérifier l'existence des champs nécessaires
        if isfield(data, 'ft_data') && isfield(data.ft_data, 'trial') && isfield(data.ft_data, 'time')
            % Additionner les signaux des trials
            sum_data = sum_data + data.ft_data.trial;
        else
            warning('Les champs nécessaires sont absents dans le fichier : %s', files(i).name);
        end
    end
    
    % Calculer la moyenne des signaux
    average_data = sum_data / num_files;
    
    % Créer la structure de données pour le fichier average_<folder_name>.mat
    average_struct = struct();
    average_struct.trial = average_data;
    average_struct.time = data.ft_data.time;
    
    % Sauvegarder le fichier average_<folder_name>.mat
    save(fullfile(output_folder, sprintf('average_%s.mat', folder_name)), 'average_struct');
    
    %% Génération des versions randomisées
    % Dossier de sortie pour les fichiers randomisés
    randomized_output_folder = fullfile(output_folder, sprintf('Average_file_%s', folder_name));
    if ~exist(randomized_output_folder, 'dir')
        mkdir(randomized_output_folder);
    end
    
    % Générer et analyser les permutations
    for k = 1:1000
        % Initialiser la somme pour la permutation k
        sum_random = zeros(143, 116);
        
        for i = 1:num_files
            file_path = fullfile(folder, files(i).name);
            data = load(file_path);
            
            if isfield(data, 'ft_data') && isfield(data.ft_data, 'trial') && isfield(data.ft_data, 'time')
                % Appliquer un décalage circulaire aléatoire à chaque canal et chaque essai
                shuffled_trial = zeros(size(data.ft_data.trial));
                for channel_idx = 1:size(data.ft_data.trial, 1) % Pour chaque canal
                    shuffled_trial(channel_idx, :) = circshift(data.ft_data.trial(channel_idx, :), randi([-76, 76]));
                end
                
                % Additionner les signaux décalés
                sum_random = sum_random + shuffled_trial;
            else
                warning('Les champs nécessaires sont absents dans le fichier : %s', files(i).name);
            end
        end
        
        % Calculer la moyenne des signaux pour la permutation k
        average_random = sum_random / num_files;
        
        % Créer la structure de données pour le fichier average_random_k.mat
        random_data = struct();
        random_data.trial = average_random;
        random_data.time = data.ft_data.time;
        
        % Sauvegarder le fichier average_random_k.mat
        save(fullfile(randomized_output_folder, sprintf('average_random_%d.mat', k)), 'random_data');
    end
    
    %% Calcul des seuils et identification des électrodes significatives
    % Initialiser les matrices pour les seuils
    significatif_2_5 = zeros(143, 116);
    significatif_97_5 = zeros(143, 116);
    
    % Charger les fichiers randomisés et calculer les percentiles
    random_files = dir(fullfile(randomized_output_folder, 'average_random_*.mat'));
    num_random_files = numel(random_files);
    
    % Créer une matrice pour stocker les valeurs randomisées
    random_trials = zeros(143, 116, num_random_files);
    
    for k = 1:num_random_files
        random_file_path = fullfile(randomized_output_folder, random_files(k).name);
        random_data = load(random_file_path);
        
        % Stocker les valeurs randomisées
        random_trials(:, :, k) = random_data.random_data.trial;
    end
    
    % Calculer les percentiles 2.5 et 97.5
    for channel_idx = 1:143
        for time_idx = 1:116
            significatif_2_5(channel_idx, time_idx) = prctile(random_trials(channel_idx, time_idx, :), 2.5);
            significatif_97_5(channel_idx, time_idx) = prctile(random_trials(channel_idx, time_idx, :), 97.5);
        end
    end
    
    % Comparer average_<folder_name> aux seuils et identifier les électrodes significatives
    significatif = zeros(143, 116);
    for channel_idx = 1:143
        for time_idx = 1:116
            if average_struct.trial(channel_idx, time_idx) < significatif_2_5(channel_idx, time_idx) || ...
               average_struct.trial(channel_idx, time_idx) > significatif_97_5(channel_idx, time_idx)
                significatif(channel_idx, time_idx) = 1;
            end
        end
    end
    
    % Sauvegarder les résultats de significativité
    save(fullfile(output_folder, sprintf('significatif_%s.mat', folder_name)), 'significatif', 'significatif_2_5', 'significatif_97_5');
end
