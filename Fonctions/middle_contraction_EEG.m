
function [point]=middle_contraction_EEG(data,rate,mode,Num_position,Angle_int,Vitesse,Serie)

%-------------------------------------------------------------------------------------------------------------
%Code rédigé par Dorian et Célia
% Modifié par Célia le 13/07/2023 - 17/07/2023
% Modifié par Dorian le 20/08/2023


%--------------------------------------------------------------------------------------------------------------
 

point = find(data(Num_position,:)-Angle_int>0 & data(Num_position,:)-Angle_int<0.02);  % Trouve les points où la position correspond à la mesure ISO


for w=[1:1:length(point)-1];
    S=w+1;
    Temporaire(1,w)=point(1,w)-point(1,S);
end

Out= find(Temporaire>=-2);
point(:,Out)=[];               % Exclu les doublons

for q=[1:1:length(point)]
    Sens(q,1)=data(Num_position,point(q))-(data(Num_position,point(q)-200));
end

if mode == 'SHO'
    Excl=find(Sens>0);
    point(:,Excl)=[];  % si le sens du mouvement est vers le bas = concentrique = ne garde que les points en descente
elseif mode == 'LEN'
    Excl=find(Sens<0);
    point(:,Excl)=[];  % si le sens du mouvement est vers le haut = excentrique = ne garde que les points en montée
end
% Ici, "point" = passage du mouvement a l'angle de la position ISO

% %%% Verification de la fenetre %%%
% 
% data_time=[1:1:size(data,2)]/rate;
% figure('name','ANISO');
% ax1 = axes; 
% yyaxis left                
% plot(data_time,data(Num_position,:))
% movegui('south')
% ylabel('Position')
% ax1.XTickMode = 'manual'; 
% ax1.YTickMode = 'manual'; 
% ax1.YLim = [min(ax1.YTick), max(ax1.YTick)];  % see [4]
% ax1.XLimMode = 'manual'; 
% 
% hold on
% ytick = ax1.YTick;  
% yyaxis right
% ylabel('RMS-TB')
% 
% 
% plot(data_time,data(72,:), 'Color', [1 0.5 0 0.3]); % Ici, [0 0 1] correspond au bleu (RGB) et 0.5 à l'opacité



%title(strcat(mode,'-',Vitesse,'-',Serie))

%set(gcf,'Position',[100 300 600 600]);
for contraction=[1:1:length(point)]
    milieu(contraction,1)=point(contraction)/rate;
end


% Y(1:length(milieu))=Angle_int;
% yyaxis left
% scatter(milieu,Y, 90,'b', 'LineWidth', 2)


if Serie(1)=='A'
    

       yyaxis left
       
    for h=1:1:length(milieu)
    I=num2str(h);
    text(milieu(h),max(data(Num_position,:))+0.1,I,'FontSize',14,'color','r')
    end


    ax2 = axes('position', ax1.Position);
    ax2.Color = 'none';
    hold on
    
    ylabel('Moment')
    plot(data_time,data(69,:),'-k')
    
    prompt = {'Essais à reject si bug (séparer les chiffres par une virgule):'};
    dlgtitle = 'Check bug antago';
    dims = [1 100];
    definput = {'0'};
    answer = inputdlg(prompt,dlgtitle,dims,definput);


else
%     prompt = {'Pour quel mouvement le torque est nul (1 seul mouv) :','Essais à reject (séparer les chiffres par une virgule):'};
%     dlgtitle = 'Check effet passif --> cliquez sur "Cancel" pour plot le moment de force';
%     dims = [1 100];
%     definput = {'1','0'};
%     answer = inputdlg(prompt,dlgtitle,dims,definput);
%     
%     if isempty(answer)
%     ax2 = axes('position', ax1.Position);
%     ax2.Color = 'none';
%     hold on
%     
%     ylabel('Moment')
%     plot(data_time,data(69,:),'-k')
%     
%     prompt = {'Pour quel mouvement le torque est nul (1 seul mouv) :','Essais à reject (séparer les chiffres par une virgule):'};
%     dlgtitle = 'Check effet passif';
%     dims = [1 100];
%     definput = {'1','0'};
%     answer = inputdlg(prompt,dlgtitle,dims,definput);
%     end
%         
% end


% if Serie(1)=='A'
%     PASS='0';
%     OUT=answer{1,1};
% else
%     PASS=answer{1,1};
%     OUT=answer{2,1};
% end


close gcf

end



