function [RMS,TORQUE]=fenetreISO_RMS(Matr_Rej_1,s,S,rate,Moment)

% Modifié par Dorian le 20/08/2023

% % keyboard
%
%         mode={'ISO'};
%         m=1;
%
%         vitesse=fieldnames(Matr_Rej_1.(S{s}).(mode{m}));
%
%         for v=1:1:length(vitesse) % Pour toutes les vitesses
%             repet=fieldnames(Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}));
%             VIT=(vitesse{v});
%
%             if VIT(1)=='V'
%                 d=4.5*rate;
%                 h=2.5*rate;
%             elseif VIT(1)=='M'
%                 d=2.5*rate;
%                 h=3.0*rate;
%             end
%
%
%             for r=1:1:length(repet)
%                 REP=repet{r};
%                 if REP(1)=='A'
%                 else
%                     DS=Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).(REP).data(Torque,:,:);%%%%%%%%%%%%%
%
%                     % a partir de 4seconde, prendre la ou la RMS est la plus stable sur 300ms
%                     % pour V000
%
%                     w=d;
%                     for W=1:1:length(DS)-w-h
%                         ET=std(DS(1,w:w+0.3*rate,:));
%                         Variabilite(W,:,1)=ET(1,1,:);
%                         w=w+1;
%                     end
%
%                     MIN=min(Variabilite);
%
%                     for f=1:1:length(MIN)
%                         G=Variabilite(:,f);
%                         LocMIN(1,f)=find(G==MIN(f));
%                     end
%
%                     for q=1:1:length(LocMIN)
%                         plot(DS(1,:,q))
%                         hold on
%                         scatter(LocMIN(q)+d,DS(1,LocMIN(q)+d,q))
%                         scatter(LocMIN(q)+d+0.3*rate,DS(1,LocMIN(q)+d+0.3*rate,q))
%                         movegui('south')
%
%                         texte = strcat('Controle');
%                         dlgTitle    = texte;
%                         dlgQuestion = 'Etes-vous satisfait de la selection ?';
%                         choice = questdlg(dlgQuestion,dlgTitle,'Oui','Non', 'Oui');
%                         close gcf
%
%                         if choice=='Non'
%                             plot(DS(1,:,q))
%                             title('Selectionne le dÃ©but de la fenetre d"interet')
%                             [start_contraction,Y2] = ginput(1) ;
%                             close gcf
%                             LocMIN(1,q)=start_contraction;
%                         end
%                         ds=Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).(REP).data(65,:,q);
%                         rms(1,q) = sqrt(trapz([1:length(ds(1,LocMIN(1,q):LocMIN(1,q)+0.3*rate,:))]./rate,(ds(1,LocMIN(1,q):LocMIN(1,q)+0.3*rate,:)).^2)/(length(ds(1,LocMIN(1,q):LocMIN(1,q)+0.3*rate,:)).*(1/rate))) ;
%
%                         torque(1,q)=mean(Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).(REP).data(Moment,d:d+round(0.3*rate),q));
%
%                         clearvars -except RMS Matr_Rej_1 torque dossier dossier2 s h S r v m vitesse mode REP repet d rms DS LocMIN Torque rate Moment
%
%                     end
%
%                     RMS.(S{s}).(mode{m}).(vitesse{v}).(REP).RMS=rms;
%
%                     TORQUE.(S{s}).(mode{m}).(vitesse{v}).(REP).torque=torque;
%
%                     clear rms DS LocMIN Variabilite
%
%                 end
%             end
%
%         end
%


mode={'ISO'};
m=1;

vitesse=fieldnames(Matr_Rej_1.(S{s}).(mode{m}));

for v=1:1:length(vitesse) % Pour toutes les vitesses
    repet=fieldnames(Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}));
    VIT=(vitesse{v});
    
    if VIT(1)=='V'
        d=6.60*rate; % 4 sec de repos + 2sec de préactivation + 0.75 sec (=milieu du mouvement pour 90°/s)-0.15 pour avoir le début
        
        for r=1:1:length(repet)
            REP=repet{r};
            if REP(1)=='A'
            else
                DS=Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).(REP).data(Moment,:,:);%%%%%%%%%%%%%
                                
                
                for q=1:1:size(DS,3)
                    plot(DS(1,:,q))
                    hold on
                    scatter(d,DS(1,round(d),q))
                    scatter(d+0.3*rate,DS(1,round(d+0.3*rate),q))
                    
                    movegui('south')
                    
                    texte = strcat('Controle');
                    dlgTitle    = texte;
                    dlgQuestion = 'Etes-vous satisfait de la selection ?';
                    choice = questdlg(dlgQuestion,dlgTitle,'Oui','Non', 'Oui');
                    close gcf
                    
                    if choice=='Non'
                        plot(DS(1,:,q))
                        title('Selectionne le dÃ©but de la fenetre d"interet')
                        [start_contraction,Y2] = ginput(1) ;
                        close gcf
                        d=round(start_contraction); %%%%%%%%%%%%%%%%%%%%%%%%%%%
                    end
                    
                    ds=Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).(REP).data(65,:,q); %%%%%%%%%%%%%%%%%%%%%%!!!!!!!!!!!!
                    rms_var(1,q) = rms(ds(1,d:d+round(0.3*rate),:)) ;
                    
                    torque(1,q)=mean(Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).(REP).data(Moment,d:d+round(0.3*rate),q));
                    
                    clearvars -except VIT RMS TORQUE Matr_Rej_1 dossier dossier2 s h S r v d m vitesse mode REP repet d rms_var torque DS LocMIN rate Torque Moment
                    
                 
                end
                
                RMS.(S{s}).(mode{m}).(vitesse{v}).(REP).RMS=rms_var;
                
                TORQUE.(S{s}).(mode{m}).(vitesse{v}).(REP).TORQUE=torque;
                
                
                clear rms_var torque DS LocMIN Variabilite
                
            end
        end
        
    elseif VIT(1)=='M'
        
        d=2.5*rate;
        h=3.0*rate;
        
            for r=1:1:length(repet)
            REP=repet{r};
       
        DS=Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).(REP).data(72,:,:);%%%%%%%%%%%%%

                  
                    w=d;
                    for W=1:1:length(DS)-w-h
                        MED=median(DS(1,w:w+round(0.3*rate),:));
                        MEDSTOCK(W,:,1)=MED(1,1,:);
                        w=w+1;
                    end

                    MAX=max(MEDSTOCK);

                    for f=1:1:length(MAX)
                        G=MEDSTOCK(:,f);
                        LocMIN(1,f)=min(find(G==MAX(f)));
                    end

                    for q=1:1:length(LocMIN)
                        plot(Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).(REP).data(Moment,:,q))
                        yyaxis right
                        plot(DS(1,:,q))
                        hold on
                        scatter(LocMIN(q)+d,DS(1,LocMIN(q)+d,q),'k','LineWidth', 2)
                        scatter(LocMIN(q)+d+round(0.3*rate),DS(1,LocMIN(q)+d+round(0.3*rate),q),'k','LineWidth', 2)
                        movegui('south')

                        texte = strcat('Controle');
                        dlgTitle    = texte;
                        dlgQuestion = 'Etes-vous satisfait de la selection ?';
                        choice = questdlg(dlgQuestion,dlgTitle,'Oui','Non', 'Oui');
                        close gcf

                        if choice=='Non'
                            plot(DS(1,:,q))
                            title('Selectionne le dÃ©but de la fenetre d"interet')
                            [start_contraction,Y2] = ginput(1) ;
                            close gcf
                            LocMIN(1,q)=start_contraction;
                        end
                        
                        ds=Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).(REP).data(65,:,q);
                        rms_var(1,q)=rms(ds(1,LocMIN(1,q)+d:LocMIN(1,q)+d+round(0.3*rate),1));
                        torque(1,q)=mean(Matr_Rej_1.(S{s}).(mode{m}).(vitesse{v}).(REP).data(Moment,d:d+round(0.3*rate),q));

                        clearvars -except TORQUE RMS Matr_Rej_1 torque dossier dossier2 s h S r v m vitesse mode REP repet d rms_var DS LocMIN Torque rate Moment

                    end

                    RMS.(S{s}).(mode{m}).(vitesse{v}).(REP).RMS=rms_var;

                    TORQUE.(S{s}).(mode{m}).(vitesse{v}).(REP).torque=torque;

                    clear rms_var DS LocMIN Variabilite

                end
            end
        
        
        
        
        
    end
    
    
    
    
end



