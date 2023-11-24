function [start_contraction,OUT]=find_start_ISO(data,num_serie)

%-------------------------------------------------------------------------------------------------------------
%Code rédigé par Dorian et Célia
% Modifié par Célia le 13/07/2023 ( 17/07/2023
% Modifié par Dorian le 20/08/2023

% keyboard
%--------------------------------------------------------------------------------------------------------------

%%%% selection manuelle du seuil des contractions volontaires  pour séléction automatique %%%

torque=data(69,:);
h=figure('name','ISO');
plot(torque) ;
title(sprintf(strcat(num_serie,'\n Selectionner un Y en dessous du bruit et au dessus des pics ')))
ylabel('Moment de force')
[x,y] = ginput(1) ;
close(h)

if num_serie == 'A'
    delta=abs(max(torque)/50);
else
    delta=abs(min(torque)/50) ;
end



point_iso= find(torque-y>0 & torque-y<delta);  % Trouve les points où le torque correspond au seuil


[val,idx]=min(abs(torque-y));


for w=[1:1:length(point_iso)-1];
    S=w+1;
    Temporaire(1,w)=point_iso(1,w)-point_iso(1,S);
end

if isempty(w)
else
Out= find(Temporaire>=-2);

point_iso(:,Out)=[];               % Exclu les points trop proches

point_iso(:,2:2:end) = [] ;        % Exclu les points sur la phase de relachement
end



%%%%%%%%%    Visualisation des points sélectionnés    %%%%%%%%%


Y(1:length(point_iso))=y;

plot(torque);
movegui('south')

hold on
scatter(point_iso,Y);
for h=1:1:length(point_iso)
        text(point_iso(h),max(torque),num2str(h),'FontSize',14,'color','r')
end


texte = strcat("n=",string(length(point_iso)));


dlgTitle    = texte;
dlgQuestion = 'Que souhaitez vous faire ?';
CHOICE = questdlg(dlgQuestion,dlgTitle,'Valider la selection','Reesayer','Passer au mode manuel','Valider la selection');

if CHOICE(1:3)=='Ree'
    while CHOICE(1:3)=='Ree'
        
        
        clear point_iso Y Out Temporaire val idx delta
        close gcf
        
        
        %%%% selection manuelle du seuil des contractions volontaires  pour séléction automatique %%%
        
        h=figure('name','ISO');
        plot(torque) ;
        title(sprintf(strcat(num_serie,'\n Selectionner un Y en dessous du bruit et au dessus des pics ')))
        ylabel('Moment de force')
        [x,y] = ginput(1) ;
        close(h)
        
        if num_serie == 'A'
            delta=abs(max(torque)/100);
        else
            delta=abs(min(torque)/100) ;
        end
        
        point_iso= find(torque-y>0 & torque-y<delta);  % Trouve les points où le torque correspond au seuil
        
        
        [val,idx]=min(abs(torque-y));
        
        
        for w=[1:1:length(point_iso)-1];
            S=w+1;
            Temporaire(1,w)=point_iso(1,w)-point_iso(1,S);
        end
        
        Out= find(Temporaire>=-2);
        point_iso(:,Out)=[];               % Exclu les points trop proches
        
        point_iso(:,2:2:end) = [] ;        % Exclu les points sur la phase de relachement
        
        
        
        %%%%%%%%%    Visualisation des points sélectionnés    %%%%%%%%%
        
        
        Y(1:length(point_iso))=y;
        
        plot(torque);
        hold on
        scatter(point_iso,Y);
        movegui('south')

        for h=1:1:length(point_iso)
            I=num2str(h);
            text(point_iso(h),max(torque),I,'FontSize',14,'color','r')
        end

        texte = strcat("n=",string(length(point_iso)));
        
        
        dlgTitle    = texte;
        dlgQuestion = 'Que souhaitez vous faire ?';
        CHOICE = questdlg(dlgQuestion,dlgTitle,'Valider la selection','Reesayer','Passer au mode manuel','Valider la selection');
    end
    if CHOICE(1:3)=='Pas'
        
         OUT={'0'};
        choice='Non';
        while choice=='Non'
            close gcf
            h=figure('name',num_serie);
            plot(torque) ;
            title('Cliquez manuellement sur le début de chaque contraction puis cliquez sur entré')
            ylabel('Moment de force')

            %set(gcf,'Position',[100 300 600 600]);
            [start_contraction,Y2] = ginput ;
            hold on
            
            for e=1:1:length(start_contraction)
                x = [start_contraction(e) start_contraction(e)];
                y = [min(torque)-0.05 max(torque)+0.05];
                line(x,y);
            end
            movegui('south')

            
            texte = strcat("n=",string(length(start_contraction)));
            dlgTitle    = texte;
            dlgQuestion = 'Etes-vous satisfait de la selection ?';
            choice = questdlg(dlgQuestion,dlgTitle,'Oui','Non', 'Oui');
            close gcf
            
        end
        
        prompt = {'Essais à reject (séparer les chiffres par une virgule):'};
        dims = [1 100];
        definput = {'0'};
        dlgtitle = 'Verif';
        OUT = inputdlg(prompt,dlgtitle,dims,definput);
        
    end
    
    
elseif CHOICE(1:3)=='Pas'
    OUT= {'0'};
    choice='Non';
    while choice=='Non'
        close gcf
        h=figure('name',num_serie);
        plot(torque) ;
        title('Cliquez manuellement sur le début de chaque contraction puis cliquez sur entré')
        ylabel('Moment de force')

        %set(gcf,'Position',[100 300 600 600]);
        [start_contraction,Y2] = ginput ;
        hold on
        movegui('south')

        for e=1:1:length(start_contraction)
            x = [start_contraction(e) start_contraction(e)];
            y = [min(torque)-0.05 max(torque)+0.05];
            line(x,y);
        end
        
        texte = strcat("n=",string(length(start_contraction)));
        dlgTitle    = texte;
        dlgQuestion = 'Etes-vous satisfait de la selection ?';
        choice = questdlg(dlgQuestion,dlgTitle,'Oui','Non', 'Oui');
        close gcf
        
    end
    
end

C=sum(CHOICE(1:3)=='Val');



if C==3
    
    
    %%%%%%%%%    Visualisation du debut de chaque contraction    %%%%%%%%%
    
    for num_point=[1:1:length(point_iso)]
        
        n=0;
        difference = data(5,point_iso(num_point)-n) - data(5,point_iso(num_point)-(n+5));
        
        
        if num_serie == 'A'
            
            while difference > 0
                
                n=n+2 ;
                difference = data(5,point_iso(num_point)-n) - data(5,point_iso(num_point)-(n+5));
                
            end
            
        else
            
            while difference < 0
                
                n=n+2;
                difference = data(5,point_iso(num_point)-n) - data(5,point_iso(num_point)-(n+5));
                
            end
            
            
        end
        
        start_contraction(num_point,1)=point_iso(num_point)-n;
        Y2(1,num_point)=data(5,point_iso(num_point)-n);
    end
    
    
    for e=1:1:length(start_contraction)
        x = [start_contraction(e) start_contraction(e)];
        y = [min(torque)-0.05 max(torque)+0.05];
        line(x,y);
    end
    movegui('south')

    %          texte = strcat("n=",string(length(start_contraction)));
    %          CreateStruct.Interpreter = 'tex';
    %          CreateStruct.WindowStyle = 'modal';
    %          m=msgbox("Etes-vous satisfait de la selection ?",texte,CreateStruct);
    %          set(m,'Position',[350 499 150 70])
    %          uiwait(m);
    
    dlgTitle    = texte;
    dlgQuestion = 'Etes-vous satisfait de la selection ?';
    choice = questdlg(dlgQuestion,dlgTitle,'Oui','Non', 'Oui');
 
     if choice=='Non'
        while choice=='Non'
            
            close gcf
            h=figure('name',num_serie);
            plot(torque) ;
            title('Cliquez manuellement sur le début de chaque contraction puis cliquez sur entré')
            ylabel('Moment de force')

            %set(gcf,'Position',[100 300 600 600]);
            [start_contraction,Y2] = ginput ;
            hold on
            movegui('south')

            for e=1:1:length(start_contraction)
                x = [start_contraction(e) start_contraction(e)];
                y = [min(torque)-0.05 max(torque)+0.05];
                line(x,y);
            end
            texte = strcat("n=",string(length(start_contraction)));
            dlgTitle    = texte;
            dlgQuestion = 'Etes-vous satisfait de la selection ?';
            choice = questdlg(dlgQuestion,dlgTitle,'Oui','Non', 'Oui');
            
            close gcf
        end
        close gcf
     end
        movegui('south')

        prompt = {'Essais à reject (séparer les chiffres par une virgule):'};
        dims = [1 100];
        definput = {'0'};
        dlgtitle = 'Verif';
        OUT = inputdlg(prompt,dlgtitle,dims,definput);
        
    close gcf
end
end



