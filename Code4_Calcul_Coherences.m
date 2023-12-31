%% Code calcul Coherence
%rédigé par Célia le 10/09/23
% Quantification de la CMC et de l'IMC puis récupération dans une matrice
% individuelle puis dans une matrice avec tous les sujets

%%-----------------------------------------------------------------------------------------------

clear;
clc;
dossier1 = uigetdir(matlabroot,'Choisir le dossier contenant les datas');
dossier = uigetdir(matlabroot,'Choisir le dossier denregistrement');
F=dir(fullfile(dossier1,'DATA*.mat'));


for x=1:1:length(F) % Pour chaque sujet
    fichier =  F(x).name;
    load(fullfile(F(x).folder,fichier));
    [filepath,name,ext] = fileparts(fichier);
    cd(dossier)
    nom=fichier(19:21);
    mkdir(nom)
    srate = DATA_EPOCH_REJECT.srate;
    
    Coherence={'CMC','IMC'};
    
    for c=1:length(Coherence)
        
        if Coherence{c}=='CMC'
            
            cd(fullfile(dossier,nom))
            
            mkdir(Coherence{c})
            
            mode={'LEN','SHO','ISO'};
            
            for m=1:1:length(mode) % Pour chaque mode
                vitesse=fieldnames(DATA_EPOCH_REJECT.(nom).(mode{m}));
                
                cd(fullfile(dossier,nom,Coherence{c}))
                
                mkdir(mode{m})
                
                for v=1:1:length(vitesse) % Pour chaque vitesse
                    VIT=vitesse{v};
                    if VIT(1)=='M'
                    else
                        cd(fullfile(dossier,nom,Coherence{c},(mode{m})))
                        
                        mkdir(vitesse{v})
                        cd(fullfile(dossier,nom,Coherence{c},(mode{m}),(vitesse{v})))
                        
                        % Selectioner une fenetre de 10secondes peut importe la vitesse !
                        if VIT(3) == '6' || VIT(3) == '0'
                            debut=srate;
                        elseif VIT(3) == '9'
                            debut=srate*0.5;
                        elseif VIT(3) == '2'
                            debut=1;
                        end
                        
                        
                        if mode{m} == 'LEN' | mode{m} == 'SHO' 
                            MatricewithoutNaN=OutNaN(DATA_EPOCH_REJECT.(nom).(mode{m}).(vitesse{v}).data);
                        else
                            MatricewithoutNaN=(DATA_EPOCH_REJECT.(nom).(mode{m}).(vitesse{v}).data);                           
                        end
                        
                        % Pour chaque muscle
                        for j=65
                            EMG_TEMP = MatricewithoutNaN(j,:,:);
                            EMG=permute(EMG_TEMP,[3,2,1]);
                            
                            % Pour chaque electrode
                            for k=13
                                EEG_TEMP = MatricewithoutNaN(k,:,:);
                                EEG=permute(EEG_TEMP,[3,2,1]);
                                
                                % EEG_visualize;
                                                                
                                
                                % calcul cohérence
                                [t,S1,S2,freq,WPS_S1,WPS_S2,WCPS,WPD,SRoWCS,WMSC,WMSCwSWCPS] = TFCA_Calculate(EEG(:,debut:end),EMG(:,debut:end),srate,7,30,10,0);
                                
                                % figure
                                close(gcf)
                                TFCA_Display(t,S1,'EEG','volt',S2,'EMG','volt',freq,WPS_S1,WPS_S2,WCPS,SRoWCS,WMSC,[],[],0,[]) ;
                                
                                % zoomer axe
                                %%IdxFreq = find(freq < 40 & freq > 0);
                                % set(gca,'YLim',[IdxFreq(1) IdxFreq(end)]);
                                
                                %enregistrement
                                eeg.signal=EEG;
                                eeg.WPS=WPS_S1;
                                
                                emg.signal= EMG;
                                emg.WPS=WPS_S2;
                                
                                eegemg.WCPS=WCPS;
                                eegemg.WPD=WPD;
                                eegemg.SRoWCS= SRoWCS;
                                eegemg.WMSC=WMSC;
                                eegemg.WMSCwSWCPS = WMSCwSWCPS;
                                
                                srates=srate;
                                
                                %save
                                saveas(gcf,strcat(nom,'_CMC_',(mode{m}),'_',(vitesse{v}),'_muscle_',DATA_EPOCH_REJECT.Label{j},'_elect_',DATA_EPOCH_REJECT.Label{k},'.png'));
                                save(strcat(nom,'_CMC_',(mode{m}),'_',(vitesse{v}),'_muscle_',DATA_EPOCH_REJECT.Label{j},'_elect_',DATA_EPOCH_REJECT.Label{k},'.mat'),'eeg','emg','eegemg','srates','freq');
                            
clearvars EEG EEG_TEMP EMG EMG_TEMP MatricewithoutNaN

                            end
                        end
                    end
                end
            end
            
        elseif Coherence{c}=='IMC'
            
            cd(fullfile(dossier,nom))
            
            mkdir(Coherence{c})
            
            mode={'LEN','SHO','ISO'};
            
            for m=1:1:length(mode) % Pour chaque mode
                vitesse=fieldnames(DATA_EPOCH_REJECT.(nom).(mode{m}));
                
                cd(fullfile(dossier,nom,Coherence{c}))
                
                mkdir(mode{m})
                
                for v=1:1:length(vitesse) % Pour chaque vitesse
                    VIT=vitesse{v};
                    if VIT(1)=='M'
                    else
                        cd(fullfile(dossier,nom,Coherence{c},(mode{m})))
                        
                        mkdir(vitesse{v})
                        cd(fullfile(dossier,nom,Coherence{c},(mode{m}),(vitesse{v})))
                        
                        % Selectioner une fenetre de 10secondes peut importe la vitesse !
                        if VIT(3) == '6' || VIT(3) == '0'
                            debut=srate;
                        elseif VIT(3) == '9'
                            debut=srate*0.5;
                        elseif VIT(3) == '2'
                            debut=1;
                        end
                        
                        
                        if mode{m} == 'LEN' | mode{m} == 'SHO'
                            MatricewithoutNaN=OutNaN(DATA_EPOCH_REJECT.(nom).(mode{m}).(vitesse{v}).data);
                        else
                            MatricewithoutNaN=(DATA_EPOCH_REJECT.(nom).(mode{m}).(vitesse{v}).data);
                        end
                        
                        % Pour chaque muscle
                        for j=65:66
                            EMG_TEMP = MatricewithoutNaN(j,:,:);
                            EMG=permute(EMG_TEMP,[3,2,1]);
                            
                            % Pour chaque second muscle
                            for k=66:67
                                EEG_TEMP = MatricewithoutNaN(k,:,:);
                                EEG=permute(EEG_TEMP,[3,2,1]);
                                
                                
                                % centrer le signal pour respecter les hypothèses de zeromean pour l'ensemble des étapes de calcul
                                %%%%%%%%%%%%%%%%%% ???????????????????? --> joseph
                                
                                if k==j
                                else
                                    % calcul cohérence
                                    [t,S1,S2,freq,WPS_S1,WPS_S2,WCPS,WPD,SRoWCS,WMSC,WMSCwSWCPS] = TFCA_Calculate(EEG(:,debut:end),EMG(:,debut:end),srate,7,30,10,0);
                                    
                                    % figure
                                    close(gcf)
                                    TFCA_Display(t,S1,'EEG','volt',S2,'EMG','volt',freq,WPS_S1,WPS_S2,WCPS,SRoWCS,WMSC,[],[],0,[]) ;
                                    
                                    % zoomer axe
                                    %%IdxFreq = find(freq < 40 & freq > 0);
                                    % set(gca,'YLim',[IdxFreq(1) IdxFreq(end)]);
                                    
                                    %enregistrement
                                    eeg.signal=EEG;
                                    eeg.WPS=WPS_S1;
                                    
                                    emg.signal= EMG;
                                    emg.WPS=WPS_S2;
                                    
                                    eegemg.WCPS=WCPS;
                                    eegemg.WPD=WPD;
                                    eegemg.SRoWCS= SRoWCS;
                                    eegemg.WMSC=WMSC;
                                    eegemg.WMSCwSWCPS = WMSCwSWCPS;
                                    
                                    srates=srate;
                                    
                                    %save
                                    saveas(gcf,strcat(nom,'_',(mode{m}),'_',(vitesse{v}),'_muscle_',DATA_EPOCH_REJECT.Label{j},'_muscle_',DATA_EPOCH_REJECT.Label{k},'.png'));
                                    save(strcat(nom,'_',(mode{m}),'_',(vitesse{v}),'_muscle_',DATA_EPOCH_REJECT.Label{j},'_muscle_',DATA_EPOCH_REJECT.Label{k},'.mat'),'eeg','emg','eegemg','srates','freq');
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

%% Quantification cohérence

clear;
dossier1 = uigetdir(matlabroot,'Choisir le dossier contenant les datas de cohérences');
dossier = uigetdir(matlabroot,'Choisir le dossier denregistrement');
%F=ListFSubDir(dossier1,'mat');
f_bnds= [13; 31];% [31;45];%[8;13]%[13; 31]; %[8;13] %%[13; 31]%[8;13]%[31;45];
compt1=0;
Coherence={'IMC','CMC'};
Mode = {'LEN','SHO','ISO'};
Muscle = {'TB','BB','BR'};
Label_EEG={'Fp1';'AF7';'AF3';'F1';'F3';'F5';'F7';'FT7';'FC5';'FC3';'FC1';'C1';'C3';'C5';'T7';'TP7';'CP5';'CP3';'CP1';'P1';'P3';'P5';'P7';'P9';'PO7';'PO3';'O1';'Iz';'Oz';'POz';'Pz';'CPz';'Fpz';'Fp2';'AF8';'AF4';'AFz';'Fz';'F2';'F4';'F6';'F8';'FT8';'FC6';'FC4';'FC2';'FCz';'Cz';'C2';'C4';'C6';'T8';'TP8';'CP6';'CP4';'CP2';'P2';'P4';'P6';'P8';'P10';'PO8';'PO4';'O2'};

F = dir_with_filter(dossier1, 'S');

for f=1:1:length(F) % pour chaque sujet
    
    for c=1:1:length(Coherence)
        a=0;
        for m=1:1:length(Mode)
            if Mode{m}=='ISO'
                Vit={'V000'};
            else
                Vit={'V060','V090','V120'};
            end
            for v=1:1:length(Vit)
                if Vit{v}=='V060'
                    %60 :
                    Line1=8-0.2-1; % milieu de la contraction - 200ms - 1sec qui à était découpé pour le calcul de la cohérence
                    Line2=8+0.2-1;
                    
                elseif Vit{v}=='V090'
                    %90 :
                    Line1=7.75-0.15 -0.5;
                    Line2=7.75+0.15-0.5;
                    
                elseif Vit{v}=='V120'
                    
                    %120 :
                    Line1=7.5-0.1;
                    Line2=7.5+0.1;
                    
                elseif Vit{v}=='V000'
                    
                    %ISO :
                    Line1=6.75-0.15-1;
                    Line2=6.75+0.15-1;
                end
                
                woi_bnds = [Line1;Line2];
                
                Chemin=strcat(F(f).folder,'\',F(f).name,'\',Coherence{c},'\',Mode{m},'\',Vit{v});
                disp(Chemin(end-15:end))
                
                if Coherence{c}=='IMC'
                    
                    
                    chaines={'TB','BB','mat'};
                    A=filtrerFichiersParChaine(Chemin,chaines);
                    load(strcat(Chemin,'\',A));
                    
                    
                    
                    [N,SURFACE,MEANincl0,MEANexcl0,VOLUME] = TFCA_Quantify(srates,freq,eegemg.SRoWCS,eegemg.WMSC,woi_bnds,f_bnds) ;
                    a=a+1;
                    Matrice_IMC(1,a)=MEANincl0;
                    
                    chaines={'TB','BR','mat'};
                    A=filtrerFichiersParChaine(Chemin,chaines);
                    load(strcat(Chemin,'\',A));
                    
                    
                    [N,SURFACE,MEANincl0,MEANexcl0,VOLUME] = TFCA_Quantify(srates,freq,eegemg.SRoWCS,eegemg.WMSC,woi_bnds,f_bnds) ;
                    Matrice_IMC(2,a)=MEANincl0;
                    
                    
                    chaines={'BR','BB','mat'};
                    A=filtrerFichiersParChaine(Chemin,chaines);
                    load(strcat(Chemin,'\',A));
                    
                    [N,SURFACE,MEANincl0,MEANexcl0,VOLUME] = TFCA_Quantify(srates,freq,eegemg.SRoWCS,eegemg.WMSC,woi_bnds,f_bnds) ;
                    Matrice_IMC(3,a)=MEANincl0;
                    
                elseif Coherence{c}=='CMC'
                    a=a+1;
                    for ms=1:1:length(Muscle)
                        for e=1:1:length(Label_EEG)
                            
                            chaines={(Muscle{ms}),strcat('_',(Label_EEG{e}),'.'),'mat'};
                            A=filtrerFichiersParChaine(Chemin,chaines);
                            load(strcat(Chemin,'\',A));
                            
                            [N,SURFACE,MEANincl0,MEANexcl0,VOLUME] = TFCA_Quantify(srates,freq,eegemg.SRoWCS,eegemg.WMSC,woi_bnds,f_bnds) ;
                            
                            Matrice_CMC(e,1)=MEANincl0;
                            
                        end
                        CMC.(F(f).name).(Muscle{ms}).data(:,a)=Matrice_CMC;
                        CMC.label.Y=Label_EEG;
                        CMC.label.X={'LEN060','LEN090','LEN120','SHO060','SHO090','SHO120','ISO'};

                    end
                end
            end
        end
    end
    IMC.(F(f).name).data=Matrice_IMC;
    IMC.label.Y = {'TB_BB','TB_BR','BB_BR'};
    IMC.label.X={'LEN060','LEN090','LEN120','SHO060','SHO090','SHO120','ISO'};
end

save(fullfile(dossier,strcat('CMC.mat')),'CMC','-v7.3');
save(fullfile(dossier,strcat('IMC.mat')),'IMC','-v7.3');

%% Récupération des données 

clear 

load('C:\Users\celia.delcamp\Downloads\IMC.mat')
load('C:\Users\celia.delcamp\Downloads\CMC.mat')
idx_cluster=[9:14,17:19];

S=fieldnames(IMC)
Sub = S(cellfun(@(nom) ~isempty(strfind(nom, 'S')), S));

for s=1:1:length(Sub)
    %IMC
    IMC_Quant.TB_BB(s,:)=IMC.(Sub{s}).data(1,:)
    IMC_Quant.TB_BR(s,:)=IMC.(Sub{s}).data(2,:)
    IMC_Quant.BB_BR(s,:)=IMC.(Sub{s}).data(3,:)
    IMC_Quant.Label ={'LEN060','LEN090','LEN120','SHO060','SHO090','SHO120','ISO'};

    %CMC TB
    a=0;
    for i=1:1:length(idx_cluster)
    a=a+1;
    A(a,:)=CMC.(Sub{s}).TB.data(i,:);
    end
    CMC_cluster=mean(A);
    CMC_Quant.TB(s,:)=CMC_cluster;
    
     %CMC BB
    a=0;
    for i=1:1:length(idx_cluster)
    a=a+1;
    A(a,:)=CMC.(Sub{s}).BB.data(i,:);
    end
    CMC_cluster=mean(A);
    CMC_Quant.BB(s,:)=CMC_cluster;
    
     %CMC BR
    a=0;
    for i=1:1:length(idx_cluster)
    a=a+1;
    A(a,:)=CMC.(Sub{s}).BR.data(i,:);
    end
    CMC_cluster=mean(A);
    CMC_Quant.BR(s,:)=CMC_cluster;
    CMC_Quant.Label ={'LEN060','LEN090','LEN120','SHO060','SHO090','SHO120','ISO'};

end


save(fullfile(dossier,strcat('CMC.mat')),'CMC_Quant','-v7.3');
save(fullfile(dossier,strcat('IMC.mat')),'IMC_Quant','-v7.3');
