%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Routine 1 : pr√©traitement 
% Code √† faire tourner sur les sujets de notre choix contenant chacun un
% dossier acq avec l'ensemble des donn√©es BIOPAC brutes en .acq et un
% dossier un dossier bdf avec l'ensemble des donn√©es BIOSEMI brutes en .bdf 
% 
% N√©cessite : 
% EEGLAB v2023.0 avec les plugins "Biosig" v3.8.1, "ICLabel" v1.4, 
% "clean_rawdata" v2.8 and "zapline-plus" v1.2.1
% Autres fonctions : load_acq, butter_filtfilt
%
% R√©alisation de la structure du code : C√©lia le 12/07/2023 - 13/07/2023
% Actualisation pr√©-traitement EEG et EMG : Joseph le 20/07/2023
% ModifiÈ le 20/08/2023 par Dorian 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialization

clear
% close all
clc
% addpath(genpath('D:\Recherche\eVAICI'));

dirpath = uigetdir('','Select folder with all subject data') ;
list_sub = dir([dirpath '\S*']) ;
fileSel = listdlg('PromptString','Please select subject:','ListString',{list_sub.name},'ListSize',[200 200], 'Name', 'Subject selection');
dirpathsave = uigetdir('','Select folder to save preprocessed data EEG');

rateEMG = 1000;
EEG_sel_fields = {'nbchan' 'trials' 'pnts' 'srate' 'xmin' 'xmax' 'times' 'data' 'icachansind' 'chanlocs' 'chaninfo' 'ref' 'event' 'etc'};

% ICLabel threshold for Brain, Muscle, Eye, Heart, Line Noise, Channel Noise, Other
IC_threshold = [NaN NaN;0.9 1;0.9 1;NaN NaN;NaN NaN;NaN NaN;NaN NaN];

%% Subject loop
for s = 1 : numel(fileSel)
    fprintf('-----------------------------< PREPROCESSING OF SUBJECT %s >-----------------------------\n',...
        list_sub(fileSel(s)).name(2:end));
    
    F_EMG = dir([dirpath '\' list_sub(fileSel(s)).name '\acq\*.acq']);
    F_EEG = dir([dirpath '\' list_sub(fileSel(s)).name '\bdf\*.bdf']);
    
    if fileSel ~= 13 % Traitement normal
        if numel(F_EMG) ~= numel(F_EEG) 
            error('--> Please check the number of EMG and/or EEG files')
        else
            disp('Condition satisfied! Both F_EMG and F_EEG have 31 elements.')
        end
    else % Pour le cas du sujet 13 o˘ l'un des fichers est enregistrÈ en .mat, nÈcessitÈ d'un traitement spÈcifique
        disp('Sujet 13 est exclu de la vÈrification du nb de fichiers EEG/EMG.')
        % Construire le chemin complet du fichier .mat
        info_fichier_mat = dir(fullfile(dirpath, list_sub(fileSel(s)).name,'EMG','ISO', 'S13_ISO_MVC_1.mat'));
        % Ajoutez ces informations ‡ la structure F_EMG
        F_EMG(end+1) = info_fichier_mat;
              
    end
    
    for file = 1 : numel(F_EMG)
        
        filename =  F_EMG(file).name;
        num = filename(1:3);
        cond = filename (5:7);
        vit = filename(9:11);
        repet = filename(13);
        
        disp(['%%%%%%%%%%%%%% - CONDITION => ' cond ' // SPEED => ' vit ' // REPETITION => ' repet ' - %%%%%%%%%%%%%%' ])

        %% Load and synchronize EMG and EEG data
       
        
        if strcmp(num, 'S13') && strcmp(cond, 'ISO') && strcmp(vit, 'MVC') && strcmp(repet, '1') % Pour le cas du sujet 13 o˘ l'un des fichers est enregistrÈ en .mat, nÈcessitÈ d'un traitement spÈcifique
            load(fullfile(F_EMG(file).folder,filename));
            acq.data = data;
            clear data
            
            canaux_biopac={'TB';'BB';'BR';'BA';'Moment';'Position';'Synchro';'EMG RMS TB'};
                for channel = 1:1:size(canaux_biopac)
                    acq.hdr.per_chan_data(channel).comment_text=canaux_biopac(channel,:);
                end
            
        else
            acq = load_acq(fullfile(F_EMG(file).folder,filename));
        end
        
        if exist('data','var') % sujet 13 MVC o√π le fichier a √©t√© enregistr√© en .mat directement %% A COMMENTER
            acq.data = data;
            clear data
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %torque conversion in N.m with the BIODEX scale factor %        
        
        acq.data(:,5)=acq.data(:,5)*145-1.8; 
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        BIOPAC = eeg_emptyset;
        BIOPAC.data = acq.data';
        BIOPAC.srate = rateEMG;
        BIOPAC = eeg_checkset(BIOPAC);
        BIOPAC = pop_resample(BIOPAC, 256);
        
        EEG = pop_biosig([F_EEG(file).folder '\' num '_' cond '_' vit '_' repet '.bdf']);
        EEG = pop_resample(EEG, 256); % resampling  between 250 Hz and 500 Hz is recommended to use Zapline-plus
        
        % Chercher le chemin complet du fichier standard_1005.elc
        standard_1005_path = which('standard_1005.elc');
        if isempty(standard_1005_path)
            error('Le fichier standard_1005.elc n''a pas ÈtÈ trouvÈ. Assurez-vous qu''il est dans le chemin de recherche de MATLAB ou spÈcifiez le chemin complet dans la fonction pop_chanedit.');
        end
        % Charger le fichier standard_1005.elc
        EEG = pop_chanedit(EEG, 'lookup', standard_1005_path);

%       EEG = pop_chanedit(EEG, 'lookup','C:\toolbox\eeglab2023.0\plugins\dipfit5.2\standard_BEM\elec\standard_1005.elc');
%         EEG = pop_chanedit(EEG, 'lookup','D:\toolbox\eeglab2023.0\plugins\dipfit\standard_BEM\elec\standard_1005.elc');
         
        EEG = pop_select(EEG,'point',[round(EEG.event(2).latency) - EEG.srate min([EEG.pnts BIOPAC.pnts+round(EEG.event(2).latency)])]);
        EEG.data(size(EEG.data,1)+1 : size(EEG.data,1)+size(BIOPAC.data,1),:) = BIOPAC.data(:,1:EEG.pnts);
        EEG.nbchan = size(EEG.data,1);
        
        for c = 1 : size(BIOPAC.data,1)
            EEG.chanlocs(64+c).labels = acq.hdr.per_chan_data(c).comment_text;
        end
        EEG = eeg_checkset(EEG);

        %% Preprocess EMG and EEG data
        EEG.data = double(EEG.data);
        EEG.data(1:64,:) = butter_filtfilt(EEG.data(1:64,:),EEG.srate,2,1,'high');
        
        EEG.data(65:68,:) = butter_filtfilt(EEG.data(65:68,:),EEG.srate,2,[3 100],'bandpass');
        
        % Calcul de la moyenne du signal
        mean_value(1,:) = mean(EEG.data(65,:)); % TB
        mean_value(2,:) = mean(EEG.data(66,:)); % BB
        mean_value(3,:) = mean(EEG.data(67,:)); % BR
        mean_value(4,:) = mean(EEG.data(68,:)); % BA
        
        % Centrage du signal ‡ zÈro en soustrayant la moyenne
        EEG.data(65,:) = EEG.data(65,:) - mean_value(1,:);
        EEG.data(66,:) = EEG.data(66,:) - mean_value(2,:);
        EEG.data(67,:) = EEG.data(67,:) - mean_value(3,:);
        EEG.data(68,:) = EEG.data(68,:) - mean_value(4,:);
        
        EEG.data(69:70,:) = butter_filtfilt(EEG.data(69:70,:),EEG.srate,2,6,'low');
        
                
        [EEG.data(1:68,:), EEG.etc.zapline.config, EEG.etc.zapline.results, ~] = clean_data_with_zapline_plus(EEG.data(1:68,:),...
            EEG.srate,'noisefreqs',[50 100],'minfreq',48,'maxfreq',102, 'plotResults',0); % remove line noise

        EEG_remove = pop_select(EEG, 'rmchannel', 65:72);
        EEG_remove = pop_clean_rawdata(EEG_remove, 'FlatlineCriterion',5,'ChannelCriterion',0.8,'LineNoiseCriterion',4,'Highpass','off',...
            'BurstCriterion','off','WindowCriterion','off','BurstRejection','off','Distance','Euclidian');
        
        % Run ICA, label and reject components with ICLabel
        EEG_remove = pop_runica(EEG_remove, 'icatype', 'runica', 'extended',1,'interrupt','on');
        EEG_remove = pop_iclabel(EEG_remove, 'default');

        EEG_remove = pop_icflag(EEG_remove, IC_threshold);
        EEG_clean = pop_subcomp(EEG_remove, [],0);
        EEG_clean.etc.ic_classification.ICLabel = EEG_remove.etc.ic_classification.ICLabel;
        EEG_clean.etc.ic_classification.ICLabel.ic_removed = EEG_clean.etc.ic_classification.ICLabel.classifications  >= IC_threshold(:,1)';
        EEG_clean.etc.ic_classification.ICLabel.ic_removed_nb = sum(EEG_clean.etc.ic_classification.ICLabel.ic_removed);
        
        % Interpolate bad channels
        EEG_clean = eeg_interp (EEG_clean, EEG.chanlocs(1:64), 'spherical');
        
        % Average re-referencing
        EEG_clean = pop_reref(EEG_clean, []);         
        
        % Add preprocess BIOPAC data 
        EEG_clean.data(65:72,:) = EEG.data(65:72,:);
        EEG_clean.chanlocs(65:72) = EEG.chanlocs(65:72);
        EEG_clean.nbchan = size(EEG.data,1);
        
        if ~isfield(EEG_clean.etc,'clean_channel_mask')
            EEG_clean.etc.clean_channel_mask = true(64,1);
        end
        EEG_clean.etc.channel_removed = {EEG_clean.chanlocs(~EEG_clean.etc.clean_channel_mask).labels};
        EEG_clean = eeg_checkset(EEG_clean);
     
        %% Creat the final structure
        EEG_all_fields = fieldnames(EEG_clean);
        final_struct = rmfield(EEG_clean,EEG_all_fields(~ismember(EEG_all_fields,EEG_sel_fields)));
        
        if repet == 'A'
            DATA.(num).(cond).(strcat('V',vit)).(repet) = final_struct;
        elseif vit == 'MVC' %#ok<*BDSCA>
            DATA.(num).(cond).(vit).(strcat('R',repet)) = final_struct;
        else
            DATA.(num).(cond).(strcat('V',vit)).(strcat('R',repet)) = final_struct;
        end
        
        clearvars -except dirpath dirpathsave list_sub fileSel rateEMG EEG_sel_fields IC_threshold s F_* num file DATA
    end
    
    % Save preprocessed data
    save(fullfile(dirpathsave,strcat(num, '_PREPROCESSED.mat')),'DATA','-v7.3');
    
    clear DATA F_* num
end

%%