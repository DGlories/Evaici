%% Code d'extraction des données et de visualisation globales
% Rédigé par Célia le 23/08/23
%%

clear
close all

clc


dossier = uigetdir(matlabroot,'Choisir le dossier contenants les donnée epochée et rejectées');

addpath(genpath(dossier));

S={'S01','S02','S03','S04','S05','S06','S07','S08','S09','S10','S11','S12','S13','S14','S15','S16','S17','S18','S19','S20','S21','S22','S23','S24','S25','S26','S27','S28','S29','S30','S31'};

for s=1:1:length(S) % Boucle pour tous les sujets
    
    dossier_load=strcat(dossier,'\DATA_EPOCH_REJECT_',S{s});
    dossier_load_2=strcat(dossier,'\RMS_',S{s});
    dossier_load_3=strcat(dossier,'\TORQUE_',S{s});
    
    
    disp(strcat('Ouverture du sujet_',S{s}))
    
    load(dossier_load)
    load(dossier_load_2)
    load(dossier_load_3)
    
    %DATA_EPOCH_REJECT=Matr_Rej_2;
    
    
    mode={'LEN','SHO','ISO'};
    
    for m=1:1:length(mode)
        vitesse=fieldnames(DATA_EPOCH_REJECT.(S{s}).(mode{m}));
        
        for v=1:1:length(vitesse) % Pour toutes les vitesses
            Vit=vitesse{v};
            if Vit(1)=='M';
                
            else
                
                moy=mean(DATA_EPOCH_REJECT.(S{s}).(mode{m}).(vitesse{v}).data,3);
                TOR.(S{s}).(mode{m}).(vitesse{v}).data(1,:)=moy(69,:);
                EMG.(S{s}).(mode{m}).(vitesse{v}).data(1,:)=moy(72,:);
                
                clear moy
            end
            Repet=fieldnames(RMS.(S{s}).(mode{m}).(vitesse{v}));
            
            
            for r=1:1:length(Repet)
                R=Repet(r);
                Re=R{1,1};
                
                if Vit(1)=='M'
                   % I=max(RMS.(S{s}).(mode{m}).(vitesse{v}).(Repet{r}).RMS)
                   % Id=find(I==RMS.(S{s}).(mode{m}).(vitesse{v}).(Repet{r}).RMS)
                    
                    Matr_RMS.(S{s}).(mode{m}).(vitesse{v}).(Repet{r}).data=mean(RMS.(S{s}).(mode{m}).(vitesse{v}).(Repet{r}).RMS);
                    Matr_TOR.(S{s}).(mode{m}).(vitesse{v}).(Repet{r}).data=mean(TORQUE.(S{s}).(mode{m}).(vitesse{v}).(Repet{r}).torque);
                    
                    TOR.(S{s}).(mode{m}).(vitesse{v}).(Repet{r}).data(1,:)=mean(DATA_EPOCH_REJECT.(S{s}).(mode{m}).(vitesse{v}).(Repet{r}).data(69,:,:),3);
                    EMG.(S{s}).(mode{m}).(vitesse{v}).(Repet{r}).data(1,:)=mean(DATA_EPOCH_REJECT.(S{s}).(mode{m}).(vitesse{v}).(Repet{r}).data(72,:,:),3);
                    
                else
                    if Re(1)=='A'
                    else
                        vecteurs_RMS{1,r}=RMS.(S{s}).(mode{m}).(vitesse{v}).(Repet{r}).RMS;
                        if m==3;
                            vecteurs_TOR{1,r}=TORQUE.(S{s}).(mode{m}).(vitesse{v}).(Repet{r}).TORQUE;
                        else
                            vecteurs_TOR{1,r}=TORQUE.(S{s}).(mode{m}).(vitesse{v}).(Repet{r}).torque;
                        end
                    
                    
                    
                    resultat_RMS = [];
                    resultat_TOR = [];
                    
                    for i = 1:length(vecteurs_RMS)
                        vecteur_actuel_RMS = vecteurs_RMS{i};
                        resultat_RMS = [resultat_RMS, vecteur_actuel_RMS];
                        
                        vecteur_actuel_TOR = vecteurs_TOR{i};
                        resultat_TOR = [resultat_TOR, vecteur_actuel_TOR];
                    end
                    
                    clear vecteurs_TOR vecteurs_RMS
                    
                    Matr_RMS.(S{s}).(mode{m}).(vitesse{v}).data=mean(resultat_RMS);
                    Matr_TOR.(S{s}).(mode{m}).(vitesse{v}).data=mean(resultat_TOR);
                    
                end
                end
            end
            clearvars -except torque Matr_TOR Matr_RMS TOR EMG s S mode dossier dossier2 m DATA_EPOCH_REJECT RMS TORQUE r vitesse
            
        end
        
    end
    
end

clearvars -except Matr_RMS Matr_TOR TOR EMG

Subjects =fieldnames(EMG);
for s=1:1:length(Subjects)
    mode={'LEN','SHO','ISO'};
a=0
      for m=1:1:length(mode)
        vitesse=fieldnames(Matr_RMS.(Subjects{s}).(mode{m}));
        
        for v=1:1:length(vitesse) % Pour toutes les vitesses
    Vit=vitesse{v};
      
        if Vit(1)=='M';
        a=a+1
        Val_RMS(s,a)= Matr_RMS.(Subjects{s}).(mode{m}).(vitesse{v}).R1.data;
        Val_TOR(s,a)= Matr_TOR.(Subjects{s}).(mode{m}).(vitesse{v}).R1.data;
        
        else
        a=a+1
        Val_RMS(s,a)= Matr_RMS.(Subjects{s}).(mode{m}).(vitesse{v}).data;
        Val_TOR(s,a)= Matr_TOR.(Subjects{s}).(mode{m}).(vitesse{v}).data;
        
        Vect_RMS{s,a,:}= EMG.(Subjects{s}).(mode{m}).(vitesse{v}).data;
        Vect_TOR{s,a,:}= TOR.(Subjects{s}).(mode{m}).(vitesse{v}).data;
% LEN 60 - LEN 90 - LEN 120 - CON 60 - CON 90 - CON 120 - ISO - MVC 
        end
        end
      end
end

Subjects =fieldnames(EMG);

for s=1:1:length(Subjects)
Repet=fieldnames(Matr_RMS.(Subjects{s}).ISO.MVC)
    
for r=1:1:length(Repet)
    Re=(Repet{r});
    if Re(2)=='1'
    Fatigue.RMS(s,1)=Matr_RMS.(Subjects{s}).ISO.MVC.(Repet{r}).data;
    Fatigue.TOR(s,1)=Matr_TOR.(Subjects{s}).ISO.MVC.(Repet{r}).data;
    elseif Re(2)=='2'
    Fatigue.RMS(s,2)=Matr_RMS.(Subjects{s}).ISO.MVC.(Repet{r}).data;
    Fatigue.TOR(s,2)=Matr_TOR.(Subjects{s}).ISO.MVC.(Repet{r}).data;
    elseif Re(2)=='3'
    Fatigue.RMS(s,3)=Matr_RMS.(Subjects{s}).ISO.MVC.(Repet{r}).data;
    Fatigue.TOR(s,3)=Matr_TOR.(Subjects{s}).ISO.MVC.(Repet{r}).data;
    end
    
end
end


dossier2 = uigetdir(matlabroot,'Choisir le dossier d"enregistrement');

  save(fullfile(dossier2,'Fatigue_MVC.mat'),'Fatigue','-v7.3');
  save(fullfile(dossier2,'Vect_RMS.mat'),'Vect_RMS','-v7.3');
  save(fullfile(dossier2,'Vect_TORQUE.mat'),'Vect_TOR','-v7.3');
  save(fullfile(dossier2,'Val_RMS.mat'),'Val_RMS','-v7.3');
  save(fullfile(dossier2,'Val_TOR.mat'),'Val_TOR','-v7.3');





