function F = dir_with_filter(dossierParent, lettreRecherchee)
    % Utilisez la fonction dir pour obtenir la liste des fichiers et dossiers
    contenuDossier = dir(dossierParent);
    
    % Filtrer les dossiers qui contiennent la lettre recherchée dans leur nom
    dossiersFiltres = contenuDossier([contenuDossier.isdir]);
    F = dossiersFiltres(contains({dossiersFiltres.name}, lettreRecherchee));
end