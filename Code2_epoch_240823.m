%% Code 2 : Epochage

% Célia 12/07/2023 - 13/07/2023
% Modifi� par Dorian le 20/08/2023

%%
clear
close all
clc


dossier = uigetdir(matlabroot,'Choisir le dossier contenants les données enregistée suite au code 1');
dossier2 = uigetdir(matlabroot,'Choisir le dossier d"enregistrement');

addpath(genpath(dossier));

S={'S01','S02','S03','S04','S05','S06','S07','S08','S09','S10','S11','S12','S13','S14','S15','S16','S17','S18','S19','S20','S21','S22','S23','S24','S25','S26','S27','S28','S29','S30','S31'};


for s=1:1:length(S) % Boucle pour tous les sujets
dossier_load=fullfile(dossier, [S{s}, '_PREPROCESSED.mat']);

disp(strcat('Ouverture du sujet_',S{s}))

load(dossier_load)

NUM=fieldnames(DATA);
num = NUM{1};
rate=DATA.(num).ISO.V000.R1.srate; % D�finit la fr�quence d'�chantillonage


%% ISO 
% Puisque les durées de contractions sont variables, nous sommes partie sur
% une base de 4secondes de contractions

% Isométique : Découpage 4 secondes avant le début de la contraction + temps de contraction supposée + 3
% secondes de repos (avec parfois la contraction qui dure plus de 4 secondes

%Isométrique antagoniste : Découpage 2 secondes avant le début de la
%contraction + temps de contraction supposée + 2 secondes de repos (avec
%parfois la contraction qui dure plus de 4 secondes

repet=fieldnames(DATA.(num).ISO.V000); % récupérer toutes les répétitions de la structure en ISO

for i=1:length(repet)
    data=double(DATA.(num).ISO.V000.(repet{i}).data); % Convertit les donn�es au format double par souci de compatibilit�
    num_serie=char(repet(i));
    % fonction qui détecte les points de début de contraction sur la base du torque
    [start_contraction,OUT]=find_start_ISO(data,num_serie);
    
    % Durée de l'épochage variable entre la condition classique et antagoniste
    if repet{i}=='A'
        debut(:,1)=start_contraction(:,1)-1*rate;
        fin(:,1)=start_contraction(:,1)+5*rate-1;
    else
        debut(:,1)=start_contraction(:,1)-4*rate;
        fin(:,1)=start_contraction(:,1)+7*rate-1;
        
    end
    
    % Découpage
    O=str2num(OUT{1,1}); % Pour reject les contractions faussement détectées
     
    a=0;
    for n=1:1:length(debut)
        if ismember(n,O)
        elseif fin(n)>length(data)% Si le biopac à était coupé trop tot ou que la contraction à était faite en trop
        elseif debut(n)<1
        else
        a=a+1; % Permet d'enregistrer les contractions d'interets indépendant de son numéro d'origine (en retirant les essais ratés)
        nom=strcat('M',num2str(a));
        mouv.(nom)=data(:,debut(n):fin(n));
        end
    end
  
    
    %Stockage
    DATA_EPOCH.(num).ISO.V000.(repet{i})=mouv;
    DATA_EPOCH.(num).ISO.V000.(repet{i}).reject=O;

    
    clearvars -except DATA_EPOCH data i rate repet num NUM DATA dossier2 dossier S s
    
end

%% MVC

% 2 secondes avant le debut de la contraction + temps de contraction supposée + 2 secondes de repos

repet=fieldnames(DATA.(num).ISO.MVC);

for i=1:length(repet)
     data=double(DATA.(num).ISO.MVC.(repet{i}).data); % Convertit les donn�es au format double par souci de compatibilit�
     num_serie=char(repet(i));
     
     % Fonction qui détermine le début de contraction sur la base du torque
     [start_contraction,OUT]=find_start_ISO(data,num_serie);

     debut(:,1)=start_contraction(:,1)-2*rate;
     fin(:,1)=start_contraction(:,1)+6*rate-1;
     
     % Découpage
     
     O=str2num(OUT{1,1});
     
     a=0;
     for n=1:1:length(debut)
         if ismember(n,O)
         elseif fin(n)>length(data)% Si le biopac à était coupé trop tot ou que la contraction à était faite en trop
         elseif debut(n)<1
         else
             a=a+1;
             nom=strcat('M',num2str(a));
             mouv.(nom)=data(:,debut(n):fin(n));
         end
     end
        
     
     % Stockage
     DATA_EPOCH.(num).ISO.MVC.(repet{i})=mouv;
     DATA_EPOCH.(num).ISO.MVC.(repet{i}).reject=O;

     
     clearvars -except DATA_EPOCH data i repet rate num NUM DATA dossier2 dossier S s
end

%% ANISO

% 5 secondes avant la pré-activation théorique (modification aprés visualisation) + 2 secondes de préactivation + contraction + 2 secondes de repos 

Angle_int=nanmean(DATA.(num).ISO.V000.R1.data(70,:)); %Milieu de la plage angulaire




mode={'LEN','SHO'};


for m=1:1:length(mode) % Pour LEN et SHO
    vitesse=fieldnames(DATA.(num).(mode{m}));
    
    for v=1:1:length(vitesse) % Pour toutes les vitesses
        repet=fieldnames(DATA.(num).(mode{m}).(vitesse{v}));
        
        for r=1:1:length(repet) % Pour les trois séries et l'antago
        data =double(DATA.(num).(mode{m}).(vitesse{v}).(repet{r}).data); % Convertit les donn�es au format double par souci de compatibilit�
        [point,PASS,OUT]=middle_contraction(data,rate,(mode{m}),70,Angle_int,(vitesse{v}),(repet{r})); 
  
        P=str2num(PASS);
        O=str2num(OUT);

        
        %Durée de mouvement variable en fonction de la vitesse
        if vitesse{v}=='V060'
            DureeMouv=2*rate;
        else if vitesse{v}=='V090'
                DureeMouv=1.5*rate;
            else if vitesse{v}=='V120'
                    DureeMouv=1*rate;
                end
            end
        end
      
      if repet{r}=='A'
        Debut=point-(DureeMouv/2)-3*rate;
        Fin=point+(DureeMouv/2)+2*rate-1;
      else
        Debut=point-(DureeMouv/2)-7*rate;
        Fin=point+(DureeMouv/2)+2*rate-1;        
      end
        
        
        
        DebutP=point-(DureeMouv/2)-2*rate; % Pour le passif --> il n'y a pas de pré-activation et le mouvements apparait parfois trés tot --> découpage 2 secondes avant le début du mouvement
        
  % Découpage de l'aniso (contractions+passif+antago)
     
  a=0;
  b=0;
       for n=1:1:length(Debut)
           if ismember(n,P)% Gestion du passif
               if DebutP(n)<1
               else
               a=a+1;
                SSTR=strcat('R',num2str(a));
                passif.(SSTR) = data(:,DebutP(n):Fin(n)); % Epochage du passif
               end
           elseif ismember(n,O) % Rejet des series OUT selectionnées
           elseif Fin(n)>length(data)% Si le biopac à était coupé trop tot ou que la contraction à était faite en trop
           elseif Debut(n)<1 % Si début trop tot, ne rien faire
           else
               b=b+1; % Epochage des l'aniso
       nom=strcat('M',num2str(b));
       mouv.(nom)=data(:,Debut(n):Fin(n));
           end
       end
       
 
     %Stockage
     DATA_EPOCH.(num).(mode{m}).(vitesse{v}).(repet{r})=mouv;
     
     if exist('passif','var')
     DATA_EPOCH.(num).(mode{m}).(vitesse{v}).(repet{r}).Pass=passif;
     end
     
     DATA_EPOCH.(num).(mode{m}).(vitesse{v}).(repet{r}).reject=O;


     clearvars -except DATA_EPOCH data i repet num NUM DATA v m r mode Angle_int dossier S s vitesse repet rate dossier2

        end
    end
end
    %% Enregistrement

    Label={'Fp1';'AF7';'AF3';'F1';'F3';'F5';'F7';'FT7';'FC5';'FC3';'FC1';'C1';'C3';'C5';'T7';'TP7';'CP5';'CP3';'CP1';'P1';'P3';'P5';'P7';'P9';'PO7';'PO3';'O1';'Iz';'Oz';'POz';'Pz';'CPz';'Fpz';'Fp2';'AF8';'AF4';'AFz';'Fz';'F2';'F4';'F6';'F8';'FT8';'FC6';'FC4';'FC2';'FCz';'Cz';'C2';'C4';'C6';'T8';'TP8';'CP6';'CP4';'CP2';'P2';'P4';'P6';'P8';'P10';'PO8';'PO4';'O2';'TB';'BB';'BR';'BA';'Moment';'Position';'Synchronisation';'EMG RMS TB'};


DATA_EPOCH.Label=Label; % conserve les labels
DATA_EPOCH.srate=rate; % conserve la fr�quence d'�chantillonage
DATA_EPOCH.chanlocs=DATA.(num).(mode{m}).(vitesse{v}).(repet{r}).chanlocs; % conserve les chanlocs


disp(strcat('Enregistrement du sujet_',num))
save(fullfile(dossier2,strcat('DATA_EPOCH_',num,'.mat')),'DATA_EPOCH','-v7.3');
clear DATA_EPOCH
end

% %% Visualisation à titre informatif
% 
% % ANISO --> les essais ou les sujets pré-activent trop tot seront à reject dans une
% % étape de vérification pour la détermination de la baseline de l'EEG mais pas pour l'ensemble du traitement des donénes !!!
% 
% mode={'LEN','SHO'};
% a=0
% 
% for m=1:1:length(mode)
%     vitesse=fieldnames(DATA_EPOCH.(num).(mode{m}));
%     
%     for v=1:1:length(vitesse)
%         repet=fieldnames(DATA_EPOCH.(num).(mode{m}).(vitesse{v}));
%          a=a+1
%         for r=1:1:length(repet)
%             REPET=(repet{r});
%            
%             if REPET(1)=='P'
%             elseif REPET(1)=='A'
%             else
%                 mouv=fieldnames(DATA_EPOCH.(num).(mode{m}).(vitesse{v}).(repet{r}));
%                 subplot(2,3,a)
%                 yyaxis left
%                 for M=1:1:length(mouv)
%                    
%                     D=(DATA_EPOCH.(num).(mode{m}).(vitesse{v}).(repet{r}).(mouv{M}));
% 
%                     plot(D(6,:),'-')
%                    
% 
%                     hold on
%                     clear D
%                 end
%                   yyaxis right
% 
%                   for M=1:1:length(mouv)
%                    
%                     D=(DATA_EPOCH.(num).(mode{m}).(vitesse{v}).(repet{r}).(mouv{M}));
%                     
%                      plot(D(7,:),'-')
% 
%                     hold on
%                     clear D
%                   end
%                 
%             end
%         end
%     end
% 
% end
% 
% 
% 
% %PASSIF
% 
% mode={'LEN','SHO'};
% a=0
% 
% for m=1:1:length(mode)
%     vitesse=fieldnames(DATA_EPOCH.(num).(mode{m}));
%     
%     for v=1:1:length(vitesse)
%         repet=fieldnames(DATA_EPOCH.(num).(mode{m}).(vitesse{v}));
%          a=a+1
%         for r=1:1:length(repet)
%             REPET=(repet{r});
%            
%             if REPET(1)=='P'
%             
%                
%                 subplot(2,3,a)
%                 yyaxis left
%                               
%                 D=(DATA_EPOCH.(num).(mode{m}).(vitesse{v}).(repet{r}));
% 
%                     plot(D(6,:),'-')
%                    
% 
%                     hold on
%                     clear D
%                 
%                   yyaxis right
% 
%                    
%                     D=(DATA_EPOCH.(num).(mode{m}).(vitesse{v}).(repet{r}));
%                     
%                      plot(D(7,:),'-')
% 
%                     hold on
%                     clear D
%             else
%                   end
%                 
%             end
%         end
%    
% end
% 
% 
% 
% 
% 
% 
% 
