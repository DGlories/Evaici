%% Figure torque individuel

clc
clear

rate=512 %%%%%%%%%% 
 

load('E:\Data_eVAICI\4_Data_extraites\Vect_RMS.mat')
load('E:\Data_eVAICI\4_Data_extraites\Vect_TORQUE.mat')
load('E:\Data_eVAICI\4_Data_extraites\Fatigue_MVC.mat')
load('E:\Data_eVAICI\4_Data_extraites\Val_RMS.mat')
load('E:\Data_eVAICI\4_Data_extraites\Val_TOR.mat')

figure
sgtitle('Torque par sujets avec le passif retiré') 

subplot(2,4,1)

for x=1:1:size(Vect_TOR,1)
plot(Vect_TOR{x, 1})
A(x,:)=Vect_TOR{x,1};
hold on 
end
ylabel('Torque (N/m)')

title('Len-60')


subplot(2,4,2)

for x=1:1:size(Vect_TOR,1)
plot(Vect_TOR{x, 2})
B(x,:)=Vect_TOR{x,2};
hold on 
end
title('Len-90')


subplot(2,4,3)

for x=1:1:size(Vect_TOR,1)
plot(Vect_TOR{x, 3})
C(x,:)=Vect_TOR{x,3};
hold on 
end
title('Len-120')


subplot(2,4,4)

for x=1:1:size(Vect_TOR,1)
plot(Vect_TOR{x, 7})
D(x,:)=Vect_TOR{x,7};
hold on 
end
title('ISO')

subplot(2,4,5)

for x=1:1:size(Vect_TOR,1)
plot(Vect_TOR{x, 4})
E(x,:)=Vect_TOR{x,4};
hold on 
end
ylabel('Torque (N/m)')

title('Sho-60')


subplot(2,4,6)

for x=1:1:size(Vect_TOR,1)
plot(Vect_TOR{x, 5})
F(x,:)=Vect_TOR{x,5};
hold on 
end
title('Sho-90')


subplot(2,4,7)

for x=1:1:size(Vect_TOR,1)
plot(Vect_TOR{x, 6})
G(x,:)=Vect_TOR{x,6};
hold on 
end
title('Sho-120')

subplot(2,4,8)
multilineText = sprintf('Aniso:\n5sec de repos\n2sec de pré-activation\nContraction (1 à 2sec)\n2sec de repos');

text(0.05,0.78,multilineText,'FontSize',12,'fontname','times')

multilineText2 = sprintf('Iso:\n4sec de repos\n4sec de contraction\n3sec de repos');
text(0.05,0.3,multilineText2,'FontSize',12,'fontname','times')



%% Figure torque moyens de tous les sujets
figure
sgtitle('Torque moyen de tous les sujets') 

% Fenetres

%60 : 
Line1_60=8*rate-0.2*rate;
Line2_60=8*rate+0.2*rate;

%90 : 
Line1_90=7.75*rate-0.15*rate;
Line2_90=7.75*rate+0.15*rate;

%120 : 
Line1_120=7.5*rate-0.1*rate;
Line2_120=7.5*rate+0.1*rate;

%ISO : 
Line1_ISO=6.75*rate-0.15*rate;
Line2_ISO=6.75*rate+0.15*rate;


%figure
subplot(2,4,1)
moyennes = mean(A);
ecart_types = std(A);

x = 1 : length(moyennes);
curve1 = moyennes-ecart_types;
curve2 = moyennes+ecart_types;
%plot(x, curve1, 'k', 'LineWidth', 2);
%plot(x, curve2, 'k', 'LineWidth', 2);
x2 = [x, fliplr(x)];
inBetween = [curve1, fliplr(curve2)];
p=fill(x2, inBetween, 'black','FaceAlpha',0.1);
p.LineWidth = 0.0000000001
hold on 
plot(moyennes,'k')
plot(curve1,'w')
plot(curve2,'w')
line([1 1],[0 10], 'color','white')
line([100 100],[0 10], 'color','white')

line([Line1_60, Line1_60], ylim, 'Color', 'k', 'LineStyle', '-', 'LineWidth', 1);
line([Line2_60, Line2_60], ylim, 'Color', 'k', 'LineStyle', '-', 'LineWidth', 1);

title('Len-60')
ylabel('Torque (N/m)')



subplot(2,4,2)
moyennes = mean(B);
ecart_types = std(B);

x = 1 : length(moyennes);
curve1 = moyennes-ecart_types;
curve2 = moyennes+ecart_types;
%plot(x, curve1, 'k', 'LineWidth', 2);
%plot(x, curve2, 'k', 'LineWidth', 2);
x2 = [x, fliplr(x)];
inBetween = [curve1, fliplr(curve2)];
p=fill(x2, inBetween, 'black','FaceAlpha',0.1);
p.LineWidth = 0.0000000001
hold on 
plot(moyennes,'k')
plot(curve1,'w')
plot(curve2,'w')
line([1 1],[0 10], 'color','white')
line([100 100],[0 10], 'color','white')
title('Len-90')

line([Line1_90, Line1_90], ylim, 'Color', 'k', 'LineStyle', '-', 'LineWidth', 1);
line([Line2_90, Line2_90], ylim, 'Color', 'k', 'LineStyle', '-', 'LineWidth', 1);

subplot(2,4,3)
moyennes = mean(C);
ecart_types = std(C);

x = 1 : length(moyennes);
curve1 = moyennes-ecart_types;
curve2 = moyennes+ecart_types;
%plot(x, curve1, 'k', 'LineWidth', 2);
%plot(x, curve2, 'k', 'LineWidth', 2);
x2 = [x, fliplr(x)];
inBetween = [curve1, fliplr(curve2)];
p=fill(x2, inBetween, 'black','FaceAlpha',0.1);
p.LineWidth = 0.0000000001
hold on 
plot(moyennes,'k')
plot(curve1,'w')
plot(curve2,'w')
line([1 1],[0 10], 'color','white')
line([100 100],[0 10], 'color','white')
title('Len-120')

line([Line1_120, Line1_120], ylim, 'Color', 'k', 'LineStyle', '-', 'LineWidth', 1);
line([Line2_120, Line2_120], ylim, 'Color', 'k', 'LineStyle', '-', 'LineWidth', 1);


subplot(2,4,4)
moyennes = mean(D);
ecart_types = std(D);

x = 1 : length(moyennes);
curve1 = moyennes-ecart_types;
curve2 = moyennes+ecart_types;
%plot(x, curve1, 'k', 'LineWidth', 2);
%plot(x, curve2, 'k', 'LineWidth', 2);
x2 = [x, fliplr(x)];
inBetween = [curve1, fliplr(curve2)];
p=fill(x2, inBetween, 'black','FaceAlpha',0.1);
p.LineWidth = 0.0000000001
hold on 
plot(moyennes,'k')
plot(curve1,'w')
plot(curve2,'w')
line([1 1],[0 10], 'color','white')
line([100 100],[0 10], 'color','white')
title('ISO')

line([Line1_ISO, Line1_ISO], ylim, 'Color', 'k', 'LineStyle', '-', 'LineWidth', 1);
line([Line2_ISO, Line2_ISO], ylim, 'Color', 'k', 'LineStyle', '-', 'LineWidth', 1);


subplot(2,4,5)
moyennes = mean(E);
ecart_types = std(E);

x = 1 : length(moyennes);
curve1 = moyennes-ecart_types;
curve2 = moyennes+ecart_types;
%plot(x, curve1, 'k', 'LineWidth', 2);
%plot(x, curve2, 'k', 'LineWidth', 2);
x2 = [x, fliplr(x)];
inBetween = [curve1, fliplr(curve2)];
p=fill(x2, inBetween, 'black','FaceAlpha',0.1);
p.LineWidth = 0.0000000001
hold on 
plot(moyennes,'k')
plot(curve1,'w')
plot(curve2,'w')
line([1 1],[0 10], 'color','white')
line([100 100],[0 10], 'color','white')
title('Sho-60')
ylabel('Torque (N/m)')

line([Line1_60, Line1_60], ylim, 'Color', 'k', 'LineStyle', '-', 'LineWidth', 1);
line([Line2_60, Line2_60], ylim, 'Color', 'k', 'LineStyle', '-', 'LineWidth', 1);


subplot(2,4,6)
moyennes = mean(F);
ecart_types = std(F);

x = 1 : length(moyennes);
curve1 = moyennes-ecart_types;
curve2 = moyennes+ecart_types;
%plot(x, curve1, 'k', 'LineWidth', 2);
%plot(x, curve2, 'k', 'LineWidth', 2);
x2 = [x, fliplr(x)];
inBetween = [curve1, fliplr(curve2)];
p=fill(x2, inBetween, 'black','FaceAlpha',0.1);
p.LineWidth = 0.0000000001
hold on 
plot(moyennes,'k')
plot(curve1,'w')
plot(curve2,'w')
line([1 1],[0 10], 'color','white')
line([100 100],[0 10], 'color','white')
title('Sho-90')

line([Line1_90, Line1_90], ylim, 'Color', 'k', 'LineStyle', '-', 'LineWidth', 1);
line([Line2_90, Line2_90], ylim, 'Color', 'k', 'LineStyle', '-', 'LineWidth', 1);

subplot(2,4,7)
moyennes = mean(G);
ecart_types = std(G);

x = 1 : length(moyennes);
curve1 = moyennes-ecart_types;
curve2 = moyennes+ecart_types;
%plot(x, curve1, 'k', 'LineWidth', 2);
%plot(x, curve2, 'k', 'LineWidth', 2);
x2 = [x, fliplr(x)];
inBetween = [curve1, fliplr(curve2)];
p=fill(x2, inBetween, 'black','FaceAlpha',0.1);
p.LineWidth = 0.0000000001
hold on 
plot(moyennes,'k')
plot(curve1,'w')
plot(curve2,'w')
line([1 1],[0 10], 'color','white')
line([100 100],[0 10], 'color','white')
title('Sho-120')

line([Line1_120, Line1_120], ylim, 'Color', 'k', 'LineStyle', '-', 'LineWidth', 1);
line([Line2_120, Line2_120], ylim, 'Color', 'k', 'LineStyle', '-', 'LineWidth', 1);

subplot(2,4,8)
multilineText = sprintf('Aniso: fenetre de 24°\n=200ms pour 120°/s\n=300ms pour 90°/s\n=400ms pour 60°');

text(0.05,0.78,multilineText,'FontSize',12,'fontname','times')

multilineText2 = sprintf('Iso: 300ms\n sur la même temporalité que aniso\nAutour de 2,75sec\napres le debut de la contraction');
text(0.05,0.3,multilineText2,'FontSize',12,'fontname','times')


%% Figure RMS individuel

figure
sgtitle('RMS individuelle non normalisée') 

subplot(2,4,1)

for x=1:1:size(Vect_RMS,1)
plot(Vect_RMS{x, 1})
A(x,:)=Vect_RMS{x,1};
hold on 
end

subplot(2,4,2)

for x=1:1:size(Vect_RMS,1)
plot(Vect_RMS{x, 2})
B(x,:)=Vect_RMS{x,2};
hold on 
end


subplot(2,4,3)

for x=1:1:size(Vect_RMS,1)
plot(Vect_RMS{x, 3})
C(x,:)=Vect_RMS{x,3};
hold on 
end


subplot(2,4,4)

for x=1:1:size(Vect_RMS,1)
plot(Vect_RMS{x, 7})
D(x,:)=Vect_RMS{x,7};
hold on 
end

subplot(2,4,5)

for x=1:1:size(Vect_RMS,1)
plot(Vect_RMS{x, 4})
E(x,:)=Vect_RMS{x,4};
hold on 
end


subplot(2,4,6)

for x=1:1:size(Vect_RMS,1)
plot(Vect_RMS{x, 5})
F(x,:)=Vect_RMS{x,5};
hold on 
end


subplot(2,4,7)

for x=1:1:size(Vect_RMS,1)
plot(Vect_RMS{x, 6})
G(x,:)=Vect_RMS{x,6};
hold on 
end

subplot(2,4,8)
multilineText = sprintf('Aniso:\n5sec de repos\n2sec de pré-activation\nContraction (1 à 2sec)\n2sec de repos');

text(0.05,0.78,multilineText,'FontSize',12,'fontname','times')

multilineText2 = sprintf('Iso:\n4sec de repos\n4sec de contraction\n3sec de repos');
text(0.05,0.3,multilineText2,'FontSize',12,'fontname','times')

%% Figure RMS moyens de tous les sujets

% Fenetres

%60 : 
Line1_60=8*rate-0.2*rate;
Line2_60=8*rate+0.2*rate;

%90 : 
Line1_90=7.75*rate-0.15*rate;
Line2_90=7.75*rate+0.15*rate;

%120 : 
Line1_120=7.5*rate-0.1*rate;
Line2_120=7.5*rate+0.1*rate;

%ISO : 
Line1_ISO=6.75*rate-0.15*rate;
Line2_ISO=6.75*rate+0.15*rate;


%figure

figure
sgtitle('RMS moyenne non normalisée') 

subplot(2,4,1)
moyennes = mean(A);
ecart_types = std(A);

x = 1 : length(moyennes);
curve1 = moyennes-ecart_types;
curve2 = moyennes+ecart_types;
%plot(x, curve1, 'k', 'LineWidth', 2);
%plot(x, curve2, 'k', 'LineWidth', 2);
x2 = [x, fliplr(x)];
inBetween = [curve1, fliplr(curve2)];
p=fill(x2, inBetween, 'black','FaceAlpha',0.1);
p.LineWidth = 0.0000000001
hold on 
plot(moyennes,'k')
plot(curve1,'w')
plot(curve2,'w')


title('Len-60')

line([Line1_60, Line1_60], ylim, 'Color', 'k', 'LineStyle', '-', 'LineWidth', 1);
line([Line2_60, Line2_60], ylim, 'Color', 'k', 'LineStyle', '-', 'LineWidth', 1);

subplot(2,4,2)
moyennes = mean(B);
ecart_types = std(B);

x = 1 : length(moyennes);
curve1 = moyennes-ecart_types;
curve2 = moyennes+ecart_types;
%plot(x, curve1, 'k', 'LineWidth', 2);
%plot(x, curve2, 'k', 'LineWidth', 2);
x2 = [x, fliplr(x)];
inBetween = [curve1, fliplr(curve2)];
p=fill(x2, inBetween, 'black','FaceAlpha',0.1);
p.LineWidth = 0.0000000001
hold on 
plot(moyennes,'k')
plot(curve1,'w')
plot(curve2,'w')

line([Line1_90, Line1_90], ylim, 'Color', 'k', 'LineStyle', '-', 'LineWidth', 1);
line([Line2_90, Line2_90], ylim, 'Color', 'k', 'LineStyle', '-', 'LineWidth', 1);

title('Len-90')


subplot(2,4,3)
moyennes = mean(C);
ecart_types = std(C);

x = 1 : length(moyennes);
curve1 = moyennes-ecart_types;
curve2 = moyennes+ecart_types;
%plot(x, curve1, 'k', 'LineWidth', 2);
%plot(x, curve2, 'k', 'LineWidth', 2);
x2 = [x, fliplr(x)];
inBetween = [curve1, fliplr(curve2)];
p=fill(x2, inBetween, 'black','FaceAlpha',0.1);
p.LineWidth = 0.0000000001
hold on 
plot(moyennes,'k')
plot(curve1,'w')
plot(curve2,'w')

line([Line1_120, Line1_120], ylim, 'Color', 'k', 'LineStyle', '-', 'LineWidth', 1);
line([Line2_120, Line2_120], ylim, 'Color', 'k', 'LineStyle', '-', 'LineWidth', 1);

title('Len-120')


subplot(2,4,4)
moyennes = mean(D);
ecart_types = std(D);

x = 1 : length(moyennes);
curve1 = moyennes-ecart_types;
curve2 = moyennes+ecart_types;
%plot(x, curve1, 'k', 'LineWidth', 2);
%plot(x, curve2, 'k', 'LineWidth', 2);
x2 = [x, fliplr(x)];
inBetween = [curve1, fliplr(curve2)];
p=fill(x2, inBetween, 'black','FaceAlpha',0.1);
p.LineWidth = 0.0000000001
hold on 
plot(moyennes,'k')
plot(curve1,'w')
plot(curve2,'w')


line([Line1_ISO, Line1_ISO], ylim, 'Color', 'k', 'LineStyle', '-', 'LineWidth', 1);
line([Line2_ISO, Line2_ISO], ylim, 'Color', 'k', 'LineStyle', '-', 'LineWidth', 1);

title('ISO')


subplot(2,4,5)
moyennes = mean(E);
ecart_types = std(E);

x = 1 : length(moyennes);
curve1 = moyennes-ecart_types;
curve2 = moyennes+ecart_types;
%plot(x, curve1, 'k', 'LineWidth', 2);
%plot(x, curve2, 'k', 'LineWidth', 2);
x2 = [x, fliplr(x)];
inBetween = [curve1, fliplr(curve2)];
p=fill(x2, inBetween, 'black','FaceAlpha',0.1);
p.LineWidth = 0.0000000001
hold on 
plot(moyennes,'k')
plot(curve1,'w')
plot(curve2,'w')

line([Line1_60, Line1_60], ylim, 'Color', 'k', 'LineStyle', '-', 'LineWidth', 1);
line([Line2_60, Line2_60], ylim, 'Color', 'k', 'LineStyle', '-', 'LineWidth', 1);


title('Sho-60')


subplot(2,4,6)
moyennes = mean(F);
ecart_types = std(F);

x = 1 : length(moyennes);
curve1 = moyennes-ecart_types;
curve2 = moyennes+ecart_types;
%plot(x, curve1, 'k', 'LineWidth', 2);
%plot(x, curve2, 'k', 'LineWidth', 2);
x2 = [x, fliplr(x)];
inBetween = [curve1, fliplr(curve2)];
p=fill(x2, inBetween, 'black','FaceAlpha',0.1);
p.LineWidth = 0.0000000001
hold on 
plot(moyennes,'k')
plot(curve1,'w')
plot(curve2,'w')

line([Line1_90, Line1_90], ylim, 'Color', 'k', 'LineStyle', '-', 'LineWidth', 1);
line([Line2_90, Line2_90], ylim, 'Color', 'k', 'LineStyle', '-', 'LineWidth', 1);

title('Sho-90')


subplot(2,4,7)
moyennes = mean(G);
ecart_types = std(G);

x = 1 : length(moyennes);
curve1 = moyennes-ecart_types;
curve2 = moyennes+ecart_types;
%plot(x, curve1, 'k', 'LineWidth', 2);
%plot(x, curve2, 'k', 'LineWidth', 2);
x2 = [x, fliplr(x)];
inBetween = [curve1, fliplr(curve2)];
p=fill(x2, inBetween, 'black','FaceAlpha',0.1);
p.LineWidth = 0.0000000001
hold on 
plot(moyennes,'k')
plot(curve1,'w')
plot(curve2,'w')

line([Line1_120, Line1_120], ylim, 'Color', 'k', 'LineStyle', '-', 'LineWidth', 1);
line([Line2_120, Line2_120], ylim, 'Color', 'k', 'LineStyle', '-', 'LineWidth', 1);

title('Sho-120')


subplot(2,4,8)
multilineText = sprintf('Aniso: fenetre de 24°\n=200ms pour 120°/s\n=300ms pour 90°/s\n=400ms pour 60°');

text(0.05,0.78,multilineText,'FontSize',12,'fontname','times')

multilineText2 = sprintf('Iso: 300ms\n sur la même temporalité que aniso\nAutour de 2,75sec\napres le debut de la contraction');
text(0.05,0.3,multilineText2,'FontSize',12,'fontname','times')

%% Boxplot

for x=1:1:size(Val_TOR,1)
    New_Val_TOR(x,1:7)=Val_TOR(x,1:7)*100/Val_TOR(x,8)
    New_Val_RMS(x,1:7)=Val_RMS(x,1:7)*100/Val_RMS(x,8)
end

fig=figure 
sgtitle('Torque quantifié sur les fenetres dinterets et normalisé par le Torque moyen en MVC (R1)') 

positions = [0.85,1.15,1.45, 1.85,2.15,2.45 2.85]

boxplot(New_Val_TOR,'Widths',0.2,'Colors', 'k','position', positions,'labels',{'LEN 60','LEN 90','LEN 120','CON 60','CON 90','CON 120','ISO'},'symbol','kx')
out=findobj(gca,'tag','Outliers');
delete(out)
box off
get(gca,'fontname')  % shows you what you are using.
set(gca,'fontname','times')
controle_col = [    0.5020    0.5020    0.5020];
ylabel('Torque (%)')

for x=[1:1:length(New_Val_TOR)]
    hold on
    A=New_Val_TOR(x,1);
    scatter(0.73,A,14,controle_col,'filled');
end

for x=[1:1:length(New_Val_TOR)]
    hold on
    A=New_Val_TOR(x,2);
    scatter(1.03,A,14,controle_col,'filled');
end

for x=[1:1:length(New_Val_TOR)]
    hold on
    A=New_Val_TOR(x,3);
    scatter(1.33,A,14,controle_col,'filled');
end

for x=[1:1:length(New_Val_TOR)]
    hold on
    A=New_Val_TOR(x,4);
    scatter(1.73,A,14,controle_col,'filled');
end

for x=[1:1:length(New_Val_TOR)]
    hold on
    A=New_Val_TOR(x,5);
    scatter(2.03,A,14,controle_col,'filled');
end

for x=[1:1:length(New_Val_TOR)]
    hold on
    A=New_Val_TOR(x,6);
    scatter(2.33,A,14,controle_col,'filled');
end

for x=[1:1:length(New_Val_TOR)]
    hold on
    A=New_Val_TOR(x,7);
    scatter(2.73,A,14,controle_col,'filled');
end

A=mean(New_Val_TOR(:,1));
B=mean(New_Val_TOR(:,2));
C=mean(New_Val_TOR(:,3));
D=mean(New_Val_TOR(:,4));
E=mean(New_Val_TOR(:,5));
F=mean(New_Val_TOR(:,6));
G=mean(New_Val_TOR(:,7));

scatter(0.85,A,[],'d','filled','k');
scatter(1.15,B,[],'d','filled','k');
scatter(1.45,C,[],'d','filled','k');
scatter(1.85,D,[],'d','filled','k');
scatter(2.15,E,[],'d','filled','k');
scatter(2.45,F,[],'d','filled','k');
scatter(2.85,G,[],'d','filled','k');

%RMS
fig=figure
sgtitle('RMS quantifiée sur les fenetres dinterets et normalisée par la RMS moyenne en MVC (R1)') 

positions = [0.85,1.15,1.45, 1.85,2.15,2.45 2.85]

boxplot(New_Val_RMS,'Widths',0.2,'Colors', 'k','position', positions,'labels',{'LEN 60','LEN 90','LEN 120','CON 60','CON 90','CON 120','ISO'},'symbol','kx')
out=findobj(gca,'tag','Outliers');
delete(out)
box off
get(gca,'fontname')  % shows you what you are using.
set(gca,'fontname','times')
controle_col = [    0.5020    0.5020    0.5020];
ylabel('RMS (%)')
for x=[1:1:length(New_Val_RMS)]
    hold on
    A=New_Val_RMS(x,1);
    scatter(0.73,A,14,controle_col,'filled');
end

for x=[1:1:length(New_Val_RMS)]
    hold on
    A=New_Val_RMS(x,2);
    scatter(1.03,A,14,controle_col,'filled');
end

for x=[1:1:length(New_Val_RMS)]
    hold on
    A=New_Val_RMS(x,3);
    scatter(1.33,A,14,controle_col,'filled');
end

for x=[1:1:length(New_Val_RMS)]
    hold on
    A=New_Val_RMS(x,4);
    scatter(1.73,A,14,controle_col,'filled');
end

for x=[1:1:length(New_Val_RMS)]
    hold on
    A=New_Val_RMS(x,5);
    scatter(2.03,A,14,controle_col,'filled');
end

for x=[1:1:length(New_Val_RMS)]
    hold on
    A=New_Val_RMS(x,6);
    scatter(2.33,A,14,controle_col,'filled');
end

for x=[1:1:length(New_Val_RMS)]
    hold on
    A=New_Val_RMS(x,7);
    scatter(2.73,A,14,controle_col,'filled');
end

A=mean(New_Val_RMS(:,1));
B=mean(New_Val_RMS(:,2));
C=mean(New_Val_RMS(:,3));
D=mean(New_Val_RMS(:,4));
E=mean(New_Val_RMS(:,5));
F=mean(New_Val_RMS(:,6));
G=mean(New_Val_RMS(:,7));

scatter(0.85,A,[],'d','filled','k');
scatter(1.15,B,[],'d','filled','k');
scatter(1.45,C,[],'d','filled','k');
scatter(1.85,D,[],'d','filled','k');
scatter(2.15,E,[],'d','filled','k');
scatter(2.45,F,[],'d','filled','k');
scatter(2.85,G,[],'d','filled','k');

%% Fatigue MVC RMS

fig=figure

sgtitle('RMS quantfiée sur les MVC pour observer une éventuelle fatigue') 

positions = [1,2,3]

boxplot(Fatigue.RMS,'Widths',0.2,'Colors', 'k','position', positions,'labels',{'R1','R2','R3'},'symbol','kx')
out=findobj(gca,'tag','Outliers');
delete(out)
box off
get(gca,'fontname')  % shows you what you are using.
set(gca,'fontname','times')
controle_col = [    0.5020    0.5020    0.5020];

for x=[1:1:length(Fatigue.RMS)]
    hold on
    A=Fatigue.RMS(x,1);
    scatter(0.75,A,14,controle_col,'filled');
end

for x=[1:1:length(Fatigue.RMS)]
    hold on
    A=Fatigue.RMS(x,2);
    scatter(1.75,A,14,controle_col,'filled');
end

for x=[1:1:length(Fatigue.RMS)]
    hold on
    A=Fatigue.RMS(x,3);
    scatter(2.75,A,14,controle_col,'filled');
end


A=mean(Fatigue.RMS(:,1));
B=mean(Fatigue.RMS(:,2));
C=mean(Fatigue.RMS(:,3));

scatter(1,A,[],'d','filled','k');
scatter(2,B,[],'d','filled','k');
scatter(3,C,[],'d','filled','k');


%% Torque fatigue

fig=figure
sgtitle('Torque quantfié sur les MVC pour observer une éventuelle fatigue') 

positions = [1,2,3]

boxplot(Fatigue.TOR,'Widths',0.2,'Colors', 'k','position', positions,'labels',{'R1','R2','R3'},'symbol','kx')
out=findobj(gca,'tag','Outliers');
delete(out)
box off
get(gca,'fontname')  % shows you what you are using.
set(gca,'fontname','times')
controle_col = [    0.5020    0.5020    0.5020];
ylabel('Torque (N/m)')
for x=[1:1:length(Fatigue.TOR)]
    hold on
    A=Fatigue.TOR(x,1);
    scatter(0.75,A,14,controle_col,'filled');
end

for x=[1:1:length(Fatigue.TOR)]
    hold on
    A=Fatigue.TOR(x,2);
    scatter(1.75,A,14,controle_col,'filled');
end

for x=[1:1:length(Fatigue.TOR)]
    hold on
    A=Fatigue.TOR(x,3);
    scatter(2.75,A,14,controle_col,'filled');
end


A=mean(Fatigue.TOR(:,1));
B=mean(Fatigue.TOR(:,2));
C=mean(Fatigue.TOR(:,3));

scatter(1,A,[],'d','filled','k');
scatter(2,B,[],'d','filled','k');
scatter(3,C,[],'d','filled','k');
