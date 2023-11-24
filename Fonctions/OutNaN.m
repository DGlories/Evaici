function MatricewithoutNaN=OutNaN(matrice)

% Obtenez les dimensions de la matrice
[rows, cols, depth] = size(matrice);

colonne_incluse = true(1, cols);


[rows, cols, depth] = size(matrice);

% Parcourez les colonnes pour détecter les NaN
for col = 1:cols
    % Utilisez isnan pour vérifier si la colonne contient des NaN
    if any(isnan(matrice(:, col)))
        % Si des NaN sont détectés, marquez cette colonne comme à exclure
        colonne_incluse(col) = false;
    end
end

% Sélectionnez les colonnes à conserver
MatricewithoutNaN = matrice(:, colonne_incluse, :);

% Affichez les dimensions de la nouvelle matrice
[rows_sans_nan, cols_sans_nan, depth_sans_nan] = size(MatricewithoutNaN);
end