function restoreAllCallback(src, event)

global matr

    for p = 1:numel(matr)
        matr(p).Color(4) = 1; % Restaurer l'opacité maximale pour toutes les courbes
    end
    
end