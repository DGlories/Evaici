% EssaisViewer.m

function EssaisViewer(app, EEG)
    % Votre code pour créer la table et afficher les données
    app.UITable = uitable(app.UIFigure);
    app.UITable.Position = [10, 10, 400, 300];
    app.UITable.Data = EEG(:, 1:10); % Montrez seulement les 10 premières colonnes pour l'exemple
    app.UITable.ColumnName = cellstr(num2str((1:10)')); % Noms de colonnes
end