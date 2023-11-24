%% Code pour reject les essais

% RÃ©digÃ© par CÃ©lia le 18/07/23, modifiÃ© le 19/07/2023
% Modifié par Dorian le 20/08/2023

% Nécessite les fonctions "dynamicAnnotationCallback" et "restoreAllCallback" pour les boutons de sélection du torque



%%

clear
close all

clc


dossier = uigetdir(matlabroot,'Choisir le dossier contenants les donnÃ©es enregistÃ©e suite au code 2');
dossier2 = uigetdir(matlabroot,'Choisir le dossier d"enregistrement');

addpath(genpath(dossier));

S={'S01','S02','S03','S04','S05','S06','S07','S08','S09','S10','S11','S12','S13','S14','S15','S16','S17','S18','S19','S20','S21','S22','S23','S24','S25','S26','S27','S28','S29','S30','S31'};
Position=70; % Définit le canal de position
Torque=69; % Définit le canal de torque
RMS_TB=72; % Définit le canal de rms du triceps
EMG_TB=65;
Moment = 69;


for s=1:1:length(S) % Boucle pour tous les sujets
    dossier_load=strcat(dossier,'\DATA_EPOCH_',S{s});
    fichier = strcat('DATA_EPOCH_',S{s});    % extrait le nom du fichier en chaine de caractères (nécessaire pour le rejet de l'EEG)
    disp(strcat('Ouverture du sujet_',S{s}))
    
    load(dossier_load)
    
    rate=DATA_EPOCH.srate; % Définit la fréquence d'échantillonage
    
    
    % Visualisation torque pour reject sur l'aniso manuel
    
    mode={'LEN','SHO','ISO'}; %%%%%%%%%%%%%%%%% Ajouter ISO
    
    for m=1:1:length(mode) % Pour LEN et SHO
        vitesse=fieldnames(DATA_EPOCH.(S{s}).(mode{m}));
        
        for v=1:1:length(vitesse) % Pour toutes les vitesses
            
            Vit=vitesse{v};
            repet=fieldnames(DATA_EPOCH.(S{s}).(mode{m}).(vitesse{v}));
                
                for r=1:1:length(repet) % Pour les trois sÃ©ries et l'antago
                    
                    %enlever outlier manuellement
                    
%                   Mouv={'M1','M2','M3','M4','M5','M6','M7','M8','M9','M10','M11','M12','M13','M14','M15','M16','M17','M17','M19','M20'};
                    
                    current_cells=fieldnames(DATA_EPOCH.(S{s}).(mode{m}).(vitesse{v}).(repet{r})); % Désigne les cellules d'interet dans la structure
                    Mouv = current_cells(startsWith(current_cells, 'M')); % Conserve celles commencant par 'M' (M1, M2,...)
                    
                    mouv=fieldnames(DATA_EPOCH.(S{s}).(mode{m}).(vitesse{v}).(repet{r}));
                    
                    R=repet{r};
                                        
                    if R(1)=='A' %pas de reject pour antago
                                       
                    else
                        
                        M=length(Mouv);
                        figure('units','normalized','outerposition',[0 0 1 1]) ; % nouvelle figure Ã  la taille de l'Ã©cran
                        hold on ;
                        global matr % Ajoute la variable matr en tant que variable globale, accessible depuis n'importe quel workspace ou fonction
                        matr = repmat(matlab.graphics.chart.primitive.Line, M, 1); % Initialisation de la variable matr contenant l'ensemble des plots (autant que de mouvements)
                        annotationButton = gobjects(M, 1); % Initialisation de la variable utilisée pour crééer les boutons de mise en surbrillance des courbes
                         
                        for p = 1:1:M
                            
                            matr1 = DATA_EPOCH.(S{s}).(mode{m}).(vitesse{v}).(repet{r}).(Mouv{p});
                            h = plot(matr1(Torque,:)); % trace l'angle du piÃ¨me mouvement
                            matr(p) = h;
                            c = get(h,'Color') ; % rÃ©cupÃ¨re la couleur de la courbe de l'angle du piÃ¨me mouvement (utilisée pour obtenir un bouton de le même couleur)
                            movementIndex = p;
                            annotationButton(p) = uicontrol('Style', 'pushbutton', ...
                                     'String', num2str(p), ...
                                     'Position', [p/M*1000, 10, 100, 40], ...
                                     'ForegroundColor', c, ...
                                     'HorizontalAlignment', 'center', ...
                                     'FontWeight', 'bold', ...
                                     'Callback', @(src, event) dynamicAnnotationCallback(src,event,Torque,movementIndex)); %crée un bouton par courbe, permettant de la mettre en surbrillance
                        end
                        
                        restoreButton = uicontrol('Style', 'pushbutton', ...
                          'String', 'Restore All', ...
                          'Position', [10, 60, 100, 40], ...
                          'Callback', @(src, event) restoreAllCallback(src, event)); % crée un bouton faisant réapparaitre toutes les courbes
                      
                        xlabel('Time') ;
                        ylabel('Torque (N.m)') ;
                        TITRE=strcat((mode{m}),'-',(vitesse{v}),'-',(repet{r}));
                        title(TITRE);
                        
                        %boite de dialogue
                        
                        prompt='Num essai outlier (sÃ©parÃ© par virgule, si pas outliers --> OK';
                        name='Data Entry Dialog';
                        position = [.8 0 .2 0.4];
                        
                        answer=mvdlg(prompt,name,position);
                        
                        % stocker answer
                        REJECT.(mode{m}).(vitesse{v}).(repet{r})=answer;
                        close;
                        
                                            
                        
                        clearvars -except EMG_TB Moment DATA_EPOCH S dossier dossier2 mode anwer s m v r vitesse repet REJECT Torque Position RMS_TB rate fichier
                    end
                end
          end
    end
    
    % Concaténer sous forme de matrice en 3D
    
    mode={'LEN','SHO','ISO'};
    
    for m=1:1:length(mode) % Pour LEN et SHO
        vitesse=fieldnames(DATA_EPOCH.(S{s}).(mode{m}));
        
        for v=1:1:length(vitesse) % Pour toutes les vitesses
            repet=fieldnames(DATA_EPOCH.(S{s}).(mode{m}).(vitesse{v}));
            
            for r=1:1:length(repet) % Pour les trois séries et l'antago
                mouv=fieldnames(DATA_EPOCH.(S{s}).(mode{m}).(vitesse{v}).(repet{r}));
                for M=1:1:length(mouv)
                    Let=mouv{M};
                    if Let(1:2)=='Pa'
                        P=fieldnames(DATA_EPOCH.(S{s}).(mode{m}).(vitesse{v}).(repet{r}).(mouv{M}));
                        x=0;
                        for p=1:1:length(P)
                            x=x+1;
                            TempRej.(S{s}).(mode{m}).(vitesse{v}).(repet{r}).Pass(:,:,x)=DATA_EPOCH.(S{s}).(mode{m}).(vitesse{v}).(repet{r}).(mouv{M}).(P{p});
                        end
                    elseif Let(1:2)=='re'
                    else
                        TempRej.(S{s}).(mode{m}).(vitesse{v}).(repet{r}).data(:,:,M)=DATA_EPOCH.(S{s}).(mode{m}).(vitesse{v}).(repet{r}).(mouv{M});
                    end
                end
            end
        end
    end
    
    
    % Reject les essais selecitonnÃ©s sur la base du torque
    
    mode={'LEN','SHO','ISO'};
    
    for m=1:1:length(mode) % Pour LEN et SHO
        vitesse=fieldnames(DATA_EPOCH.(S{s}).(mode{m}));
        
        for v=1:1:length(vitesse) % Pour toutes les vitesses
           
            Vit=vitesse{v};
            repet=fieldnames(DATA_EPOCH.(S{s}).(mode{m}).(vitesse{v}));
                
                for r=1:1:length(repet) % Pour les trois sÃ©ries et l'antago
                    REP=repet{r};
                    if REP(1)=='A'
                        Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).(repet{r}).data(:,:,:)=TempRej.(S{s}).(mode{m}).(vitesse{v}).(repet{r}).data(:,:,:);
                    else
                        D=REJECT.(mode{m}).(vitesse{v}).(repet{r});
                        Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).(repet{r}).data(:,:,:)=TempRej.(S{s}).(mode{m}).(vitesse{v}).(repet{r}).data(:,:,:);
                        if isfield(TempRej.(S{s}).(mode{m}).(vitesse{v}).(repet{r}),'Pass')
                            Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).(repet{r}).Pass(:,:,:)=TempRej.(S{s}).(mode{m}).(vitesse{v}).(repet{r}).Pass(:,:,:);
                        end
                        if isempty(D{:})
                        else
                            d=str2num(D{:});
                            for k=length(d):-1:1%prendre Ã  l'envers pour ne pas que lde second reject soit dÃ©calÃ© par rapport Ã  un Ã©ventuel premier
                                Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).(repet{r}).Reject(:,:,k)=Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).(repet{r}).data(:,:,d(k));
                                Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).(repet{r}).data(:,:,d(k))=[];
                                Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).(repet{r}).Reject_number=d;
                            end
                        end
                    end
                end
          end
    end
    
    

     
    Matr_Rej_1.(S{s}).ISO.MVC=TempRej.(S{s}).ISO.MVC; %Garder l'iso
    Matr_Rej_1.Label=DATA_EPOCH.Label; %Garder les label
    %--> repartir sur la nouvelle structure avec premiers reject : Matr_Rej_1
    
    clearvars -except Matr_Rej_1 Moment EMG_TB dossier dossier2 s S Torque Position RMS_TB rate fichier DATA_EPOCH
    
    
    
    
    % REJECT la RMS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
       %%%%%%%%%%%%%%%%%%%%%% ISO %%%%%%%%%%%%%%%%%%%%%%%%
      
    
     [RMS,TORQUE]=fenetreISO_RMS(Matr_Rej_1,s,S,rate,Moment); % Fix ou en fonction de la variabilitÃ© du torque
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ANISO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%
    
        % DÃ©terminaison de la fenetre de quantification de la cohÃ©rence 24Â° autour de l'angle mÃ©dian

    mode={'LEN','SHO'};
    
    for m=1:1:length(mode) % Pour LEN et SHO
        vitesse=fieldnames(Matr_Rej_1.(S{s}).(mode{m}));
        
        for v=1:1:length(vitesse) % Pour toutes les vitesses
            repet=fieldnames(Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}));
            
            for r=1:1:length(repet)
                REP=repet{r};
                Angle_int=nanmean(Matr_Rej_1.(S{s}).ISO.V000.R1.data(Position,:,1)); %Milieu de la plage angulaire
                MinP=min(Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).(REP).data(Position,:,1));
                MaxP=max(Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).(REP).data(Position,:,1));
                AmplAngle=MaxP-MinP;
                AmplAngleInt=(AmplAngle*24/120)/2;
                
%                 % trouver la localisation du milieu de la plage
%                 tmp = abs(Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).R1.data(6,:,1)-Angle_int);
%                 [idx idx] = min(tmp); %index of closest value
%                 closest = Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).R1.data(6,idx,1); %closest value
%                 
                % trouver la localisation du bas de la plage
                tmp = abs(Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).(REP).data(Position,:,1)-(Angle_int-AmplAngleInt));
                [idx1 idx1] = min(tmp); %index of closest value
                closest1 = Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).(REP).data(Position,idx1,1); %closest value
                
                % trouver la localisation du haut de la plage
                tmp = abs(Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).(REP).data(Position,:,1)-(Angle_int+AmplAngleInt));
                [idx2 idx2] = min(tmp); %index of closest value
                closest2 = Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).(REP).data(Position,idx2,1);
                
                if mode{m}=='SHO'
                    i=idx1;
                    idx1=idx2;
                    idx2=i;
                end
%                 plot(Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).R1.data(6,:,1))
%                 hold on
%                 scatter(idx1,closest1)
%                 scatter(idx2,closest2)
                
                DS=Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).(REP).data(EMG_TB,:,:); %%%%%%%%%%%%%%%%%%%%%%%%%%%% voir avec PM !!!!!!!!!!!!!
                rms(1,1,:) = sqrt(trapz([1:length(DS(1,idx1:idx2,:))]./rate,(DS(1,idx1:idx2,:)).^2)/(length(DS(1,idx1:idx2,:)).*(1/rate))) ;
                
                torque(1,1,:)=mean(Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).(REP).data(Moment,idx1:idx2,:));
                
                RMS.(S{s}).(mode{m}).(vitesse{v}).(REP).RMS(1,:,1)=rms(1,1,:);
                TORQUE.(S{s}).(mode{m}).(vitesse{v}).(REP).torque(1,:,1)=torque(1,1,:);

                clearvars -except Moment EMG_TB RMS TORQUE Matr_Rej_1 dossier dossier2 s S r v m vitesse mode REP repet Torque Position RMS_TB rate fichier DATA_EPOCH
            end
        end
    end
    


    
    % Comparaison des RMS bruts entre les conditions pour un mÃªme individu
    % D'abord regarder outlier automatique : sur les 30 essais d'une condition
    % --> trÃ©s peu de reject ! regarder pour concerver aussi restrictif
    % --> ca me va !
    
    mode={'LEN','SHO','ISO'};
    
    for m=1:1:length(mode)
        vitesse=fieldnames(Matr_Rej_1.(S{s}).(mode{m}));
        
        for v=1:1:length(vitesse) % Pour toutes les vitesses
            VIT=vitesse{v};
            if VIT(1)=='M'
                REP='R1';
                DefOut(1,:)=RMS.(S{s}).(mode{m}).(vitesse{v}).(REP).RMS;
            else
                repet=fieldnames(Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}));
                z=1;
                
                for r=1:1:length(repet)
                    REP=repet{r};
                    if REP(1)=='A'
                    else
                        DefOut(1,z:length(RMS.(S{s}).(mode{m}).(vitesse{v}).(REP).RMS)+z-1)=   RMS.(S{s}).(mode{m}).(vitesse{v}).(REP).RMS;
                        z=z+length(RMS.(S{s}).(mode{m}).(vitesse{v}).(REP).RMS);
                    end
                end
            end
            
            TF = isoutlier(DefOut,'mean'); %median  car trop peu de valeurs
            Outliers=find(TF==1);
            
            OUT_RMS_SousCond.(S{s}).(mode{m}).(vitesse{v})=Outliers;
            clear DefOut Outliers TF
        end
    end
    
    % RÃ©organisation de la matrice
    
    mode={'LEN','SHO','ISO'};
    
    for m=1:1:length(mode)
        vitesse=fieldnames(Matr_Rej_1.(S{s}).(mode{m}));
        
        for v=1:1:length(vitesse) % Pour toutes les vitesses
            VIT=vitesse{v};
            repet=fieldnames(Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}));

            if VIT(1)=='M'% Ne pas concaténer la MVC
            else
                z=1;
                y=1;
                j=1;
                n=1;
                c=0;
                for r=1:1:length(repet)
                    REP=repet{r};
                    if REP(1)=='R'
                        MATR(:,:,z:size((Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).(REP).data),3)+z-1)=   Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).(REP).data;
                        z=z+size((Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).(REP).data),3);
                        if isfield(Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).(REP),'Pass')
                            MATRPass(:,:,y:size((Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).(REP).Pass),3)+y-1)=   Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).(REP).Pass;
                            y=y+size((Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).(REP).Pass),3);
                        end
                        if isfield((Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).(REP)),'Reject')
                            MATRrej(:,:,j:size((Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).(REP).Reject),3)+j-1)=   Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).(REP).Reject;
                            I= size(Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).(REP).data,3)+length(Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).(REP).Reject_number);
                            i= Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).(REP).Reject_number+c;
                            c=c+I;
                            MATRrej_OUT_Torque(1,n:n+length(Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).(REP).Reject_number)-1)= i;
                            j=j+size((Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).(REP).Reject),3);
                            n=n+length(Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).(REP).Reject_number);
                        end
                    end
                end
                Matr_Rej_1_B.(S{s}).(mode{m}).(vitesse{v}).data=MATR;
                
                if sum(mode{m}=='SHO')==3 || sum(mode{m}=='LEN')==3
                    Matr_Rej_1_B.(S{s}).(mode{m}).(vitesse{v}).Pass=MATRPass;
                end
                
                if exist('MATRrej','var')
                    Matr_Rej_1_B.(S{s}).(mode{m}).(vitesse{v}).Reject_T=MATRrej;
                    Matr_Rej_1_B.(S{s}).(mode{m}).(vitesse{v}).Reject_T_number=MATRrej_OUT_Torque;
                end
               
                clear MATR MATRPass MATRrej MATRrej_OUT_Torque
            end
        end
    end
    
    %Antago
    mode={'LEN','SHO','ISO'};
    
    for m=1:1:length(mode)
        vitesse=fieldnames(Matr_Rej_1.(S{s}).(mode{m}));
        
        for v=1:1:length(vitesse) % Pour toutes les vitesses
            repet=fieldnames(Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}));
            VIT=vitesse{v};
            
            for r=1:1:length(repet)
                REP=repet{r};
                if REP(1)=='A'
                    Matr_Rej_1_B.(S{s}).(mode{m}).(vitesse{v}).A=Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).A.data;
                end
            end
        end
    end
    
    
    %%%%%%%%% Reject sur la base de la RMS
    
    Matr_Rej_2 = Matr_Rej_1_B;
    Matr_Rej_2.(S{s}).ISO.MVC=Matr_Rej_1.(S{s}).ISO.MVC; % Conserver les trois rÃ©pÃ©titions sÃ©parÃ©ments !
    
    mode={'LEN','SHO','ISO'};
    
    for m=1:1:length(mode)
        vitesse=fieldnames(Matr_Rej_1_B.(S{s}).(mode{m}));
        
        for v=1:1:length(vitesse) % Pour toutes les vitesses
            VIT=vitesse{v};
            
            if isempty(OUT_RMS_SousCond.(S{s}).(mode{m}).(vitesse{v}))
            else
                for u=length(OUT_RMS_SousCond.(S{s}).(mode{m}).(vitesse{v})):-1:1
                    OUT=OUT_RMS_SousCond.(S{s}).(mode{m}).(vitesse{v});
                    O=(OUT(u));
                    Matr_Rej_2.(S{s}).(mode{m}).(vitesse{v}).Reject_R(:,:,u)=Matr_Rej_2.(S{s}).(mode{m}).(vitesse{v}).data(:,:,u);
                    Matr_Rej_2.(S{s}).(mode{m}).(vitesse{v}).Reject_R_number=OUT;
                    Matr_Rej_2.(S{s}).(mode{m}).(vitesse{v}).data(:,:,u)=[];
                end
            end
        end
    end
    
        
%     % REJECT l'EEG %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Matr_Rej_3 = Matr_Rej_2;
%     
%     Screen = get(0,'ScreenSize'); % faire correspondre la taille de la fenêtre à l'écran
%     eeglab nogui % ouverture de la fonction eeglab
%     clear rej
%     
%         
%     mode={'LEN','SHO','ISO'};
%     
%     for m=1:1:length(mode) % Pour tous les modes
%         vitesse=fieldnames(Matr_Rej_3.(S{s}).(mode{m}));
%         
%         for v=1:1:length(vitesse) % Pour toutes les vitesses
%             repet=fieldnames(Matr_Rej_3.(S{s}).(mode{m}).(vitesse{v}));
%             VIT=vitesse{v};
%             
%             if VIT(1)=='M'% Ne pas traiter l'EEG des MVCs
%             else
%             
%             DATA_EEG_selected=Matr_Rej_3.(S{s}).(mode{m}).(vitesse{v}).data(1:64,:,:); % sélectionner uniquement les canaux eeg
%             c=1; % Création d'une variable qui ne sera incrémentée que si l'essai est rejeté
%                 
%                     % Plot all the epochs and Review
%                     for n = size(DATA_EEG_selected,3):-1:1;
%                         Epoch = DATA_EEG_selected(:,:,n);
%                         Chanlocs=DATA_EPOCH.chanlocs(1:64); % Récuperer Chanlocs
%                         % La fenêtre affiche les 64 canaux EEG
%                         % Attention contre-intuitif :
%                         % Cliquer sur le bouton "Reject" si l'essai est à conserver
%                         % Sinon, sélectionner au préalable en clic and drag une fenetre (peu importe sa taille), puis cliquer sur le bouton "Reject"
%                         
%                         eegplot(Epoch,'srate',rate,'title',fichier,'command','global rej,rej=TMPREJ','eloc_file', Chanlocs,'winlength',size(Epoch,2)/rate,'position',Screen);
%                         waitfor(gcf);
%                         TMrej = eegplot2event(TMPREJ); % Crée un event si l'essai est rejeté
% 
%                         if ~isempty(TMrej) % Si un event est crée
%                             Matr_Rej_3.(S{s}).(mode{m}).(vitesse{v}).Reject_E(:,:,c)=Matr_Rej_3.(S{s}).(mode{m}).(vitesse{v}).data(:,:,n); % Création de la sous-structure contenant les essais rejetés sur la base de l'examen visuel de l'EEG
%                             Matr_Rej_3.(S{s}).(mode{m}).(vitesse{v}).data(:,:,n)=[]; % Suppression de ces essais dans la sous-structure contenant les données.
%                             c=c+1;
%                         end
%                         
%                         clear rej TMrej 
%                         
%                     end
%                
%             end
%         end
%     end
%     
%     
%     
%     
%     
%     
%     

    %%% Soustraction de la baseline du torque %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

baseline_window = [1, 1*rate+1]; % Période de temps avant le début de l'essai pour calculer la baseline (en secondes)

    for m = 1:length(mode)
        vitesse = fieldnames(DATA_EPOCH.(S{s}).(mode{m}));

        for v = 1:length(vitesse)
            VIT=vitesse{v};
            
            switch mode{m}
                    
                case 'ISO'
                    
                    if VIT(1)=='M' %pour les MVC
                       repet = fieldnames(DATA_EPOCH.(S{s}).(mode{m}).(vitesse{v}));
                       
                        for r=1:1:length(repet)
                            
                            for n = 1:1:size(Matr_Rej_3.(S{s}).(mode{m}).(vitesse{v}).(repet{r}).data,3)
                            torque_baseline = mean(Matr_Rej_3.(S{s}).(mode{m}).(vitesse{v}).(repet{r}).data(Torque, baseline_window(1): baseline_window(2), n), 2); % récupère le torque moyen sur la première seconde de la contraction
                            Matr_Rej_3.(S{s}).(mode{m}).(vitesse{v}).(repet{r}).data(Torque,:,n) = Matr_Rej_3.(S{s}).(mode{m}).(vitesse{v}).(repet{r}).data(Torque,:,n)-torque_baseline; % soustrait cette valeur au signal du torque dans son ensemble
                            end
                            
                        end    
                        
                    else
                        
                        for n = 1:1:size(Matr_Rej_3.(S{s}).(mode{m}).(vitesse{v}).data,3)
                        torque_baseline = mean(Matr_Rej_3.(S{s}).(mode{m}).(vitesse{v}).data(Torque, baseline_window(1): baseline_window(2), n), 2); % récupère le torque moyen sur la première seconde de la contraction
                        Matr_Rej_3.(S{s}).(mode{m}).(vitesse{v}).data(Torque,:,n) = Matr_Rej_3.(S{s}).(mode{m}).(vitesse{v}).data(Torque,:,n)-torque_baseline;% soustrait cette valeur au signal du torque dans son ensemble
                        end
                        
                    end

                otherwise
                 
                for n = 1:1:size(Matr_Rej_3.(S{s}).(mode{m}).(vitesse{v}).data,3)    
                torque_baseline1 = mean(Matr_Rej_3.(S{s}).(mode{m}).(vitesse{v}).Pass(Torque, :,:), 3); % récupère le torque moyen dans les conditions passives moyennées
                longueur_rajout=length(Matr_Rej_3.(S{s}).(mode{m}).(vitesse{v}).data(Torque,:,n))-length(Matr_Rej_3.(S{s}).(mode{m}).(vitesse{v}).Pass(Torque, :,:)); % prépare le vecteur nécessaire à la complétion de la baseline finale (trop courte sinon)
                rajout(1,1:longueur_rajout)=mean(torque_baseline1(1,1:rate+1),2); % crée le vecteur basé sur la valeur moyenne de la première seconde de la condition passive
                torque_baseline=horzcat(rajout, torque_baseline1); % crée la matrice contenant le torque en condittion passive correspondant à la vitesse et au mode
                Matr_Rej_3.(S{s}).(mode{m}).(vitesse{v}).data(Torque,:,n) = Matr_Rej_3.(S{s}).(mode{m}).(vitesse{v}).data(Torque,:,n)-torque_baseline; % soustrait cette valeur au signal du torque dans son ensemble
                end
                
            end
        end
    end

    
        
    

        




    Matr_Rej_3.Label=DATA_EPOCH.Label;
    Matr_Rej_3.chanlocs=DATA_EPOCH.chanlocs;
    Matr_Rej_3.srate=DATA_EPOCH.srate;
    
    DATA_EPOCH_REJECT=Matr_Rej_3;
    save(fullfile(dossier2,strcat('DATA_EPOCH_REJECT_',S{s},'.mat')),'DATA_EPOCH_REJECT','-v7.3');

    save(fullfile(dossier2,strcat('RMS_',S{s},'.mat')),'RMS','-v7.3');
    save(fullfile(dossier2,strcat('TORQUE_',S{s},'.mat')),'TORQUE','-v7.3');

    
    clearvars -except dossier Moment dossier2 s S Torque Position rate RMS_TB EMG_TB
    
end


