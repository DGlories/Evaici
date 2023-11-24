function result = insertcols(Matrice, MatriceNAN, position)
    % Vérifier si la position d'insertion est valide
    if position < 1 || position > (size(Matrice, 2) + 1)
        error('Position d''insertion invalide.');
    end
    
    % Séparer la matrice en deux parties
    leftPart = Matrice(:, 1:position-1);
    rightPart = Matrice(:, position:end);
    
    % Insérer les colonnes à la position spécifiée
    result = [leftPart, MatriceNAN, rightPart];
end