function listeFichiersFiltres = filtrerFichiersParChaines(dossier, chaines)
    % Utilisez la fonction dir pour obtenir la liste des fichiers
    listeFichiers = dir(dossier);

    % Initialisez une cellule vide pour stocker les noms des fichiers filtrés
    fichiersFiltres = cell(0);

    % Parcourez la liste des fichiers
    for i = 1:length(listeFichiers)
        % Excluez les dossiers de la liste (nous ne voulons que les fichiers)
        if ~listeFichiers(i).isdir
            % Obtenez le nom du fichier
            nomFichier = listeFichiers(i).name;

            % Initialisez une variable pour vérifier si toutes les chaînes sont présentes
            toutesChainesPresentes = true;

            % Parcourez la liste des chaînes
            for j = 1:length(chaines)
                % Vérifiez si la chaîne j n'est pas présente dans le nom du fichier
                if ~contains(nomFichier, chaines{j})
                    toutesChainesPresentes = false;
                    break; % Sortez de la boucle dès qu'une chaîne n'est pas présente
                end
            end

            % Si toutes les chaînes sont présentes, ajoutez le nom du fichier à la liste
            if toutesChainesPresentes
                fichiersFiltres{end+1} = nomFichier;
            end
        end
    end

    % Convertissez la cellule en un tableau de caractères
    listeFichiersFiltres = char(fichiersFiltres);
end
